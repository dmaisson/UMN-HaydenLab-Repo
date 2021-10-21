function [H, prob, stat] = ipipi_Hirose(SD,PD,g_0,i,alpha,homogeneity)
% N: Number of participant
% Np: Number of permutatiuon for each participant

% SD: Sample Decoding Accuracies from experiment (N x 1 matrix)
% PD: Permutation Decoding Accuracies (N x Np matrix)
% g_0:  Prevalence threshold, gannma0 (Real number between 0 and 1 default:0.5)
% i:    Index of order statistics (Postive Integer, default: 1)
% alpha: statistical threshold (Real number between 0 and 1 default:0.05)
% homogeneity: 1 if you assume the homogeneity of DA distribution among participants 
%              (boolean, default: 0)

% H: 1 if Prob < alpha, 0 otherwise
% Prob: Probability 
% stat: (structure)
%       .prob_min minimum probability. should be smaller than alpha.
%       .param          predetermined parameters (g_0,i,alpha) 
%                 & number of subjects (N), number of permutations(Np)
%       .order_stat     i-th order statistic of S (real number)
%       .P_0            

%% initialize
% initial parameters
if nargin < 2; error('Two inputs (Sample DA and permuted DA) are required'); end
if nargin < 3 || isempty(g_0); g_0 = 0.5; end
if nargin < 5 || isempty(alpha); alpha = 0.05; end
if nargin < 6 || isempty(homogeneity); homogeneity = 0; end

% sample & permutation size
if size(SD,1) == size(PD,1); N = size(SD,1);
else
    error('Number of rows of SD and PD should be same, Number of participant.')
end
Np = size(PD,2);

% find maximum available i, if i is not specifyed
% find prob_min
if nargin < 4 || isempty(i)
    prob_min = 0;
    i=0;
    while prob_min < alpha
        i=i+1;previous_prob_min = prob_min;
        prob_min =  prob_min + binopdf(i-1,N,(1-g_0));
    end
    prob_min = previous_prob_min;
    i=i-1;
else
    prob_min =  binocdf(i-1,N,(1-g_0));
end

% error if i=1 do not satisfy the constraint 
if i==0
    error('Inappropriate predetermined parameters (alpha,g_0) for this small number of subject. Try larger alpha or smaller g_0')
end

% error if parameters are inappropriate
if prob_min>alpha
    error('Inappropriate predetermined parameters (alpha,g_0,i) for this number of subject. Try smaller i')
end



%% find i-th order statistic of SD
temp = sort(SD);
order_stat = temp(i);

if homogeneity 
%  DA distribution is DIFFERENT among participants 
    % find probability of PD >= order_stat, for each participant
    P_0 = sum(PD(:)>=order_stat)/(Np*N);
    P = g_0 + (1-g_0)*P_0;
   % find probability that order statistic is at or larger than observed one.
    PA = binocdf(i-1,N,1-P);

else    
    %% find probability of PD >= order_stat, for each participant
    % given n???-
    P_0 = sum(PD>=order_stat,2)/Np;
    % given g_0
    P = g_0 + (1-g_0)*P_0;
    %% find probability that order statistic is at or larger than observed one.
    PA = prod(P);
    for ii = 2:i
        ind_0 = combnk(1:N,ii-1); % subject index 
        for jj = 1:size(ind_0,1)
            sub_info = ones(N,1); 
            sub_info(ind_0(jj,:)) = 0;
            this_PA = prod(P.^sub_info.*(1-P).^(1-sub_info));
            PA = PA+this_PA;
        end
        
    end
    
end

%% evaluation, make output
H =(PA<alpha);
prob = PA;

stat.prob_min = prob_min;
stat.param = struct('g_0',g_0,'i',i,'alpha',alpha);
stat.order_stat = order_stat;
stat.P_0 = P_0;
