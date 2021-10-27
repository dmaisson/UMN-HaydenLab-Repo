function [T] = Timescales_epochs(start,lagmax)
%% Instructions
%   - autocorrelate between time bins across trials for each cell
% 	- fit the decay function to the autocorrelation data (using levenberg-marquardt)
% 	- extract intrinsic timescale from fitting process (solve for tau)
% 	- compare effect of timescales by regressing on them in 3 ways
% 		- predictor: timescale; outcome: autocorrelation offset
% 		- predictor: mFR; outcome: timescale
% 		- predictor: trial-trial correlation; outcome autocorrelation offset

% inputs:
    % start: a trialized psth for a single cell/channel
    % lagmax: the maximum lag length (in number of bins)
        % this is equal to the number of bins * 33.3ms, such that lagmax of
        % 10 is equal to a maximum lag of 333ms between the points being
        % correlated

%% Autocorrelation
% Correlation between data @ time i and itself @ time j

for iA = 1:size(start,1)

    lag(:,1) = (1:lagmax); % 33.3ms - lagmax*33.3 ms
    for iJ = 1:length(lag) % for each difference in time between bins (from 66.6-333ms)
        for iK = 1:size(start{iA,1},1) % for each cell
            for iL = 1:(size(start{iA,1}{iK},2)-lag(iJ)) % for each bin
                temp(iK,iL) = corr(start{iA,1}{iK}(:,iL),start{iA,1}{iK}(:,iL+lag(iJ))); % correlate bin i and bin j, where i and j are separate by a time distance defined by lag
            end
        end
        temp_avg(:,iJ) = nanmean(temp,2);
    end
    auto = (nanmean(temp_avg,1))';
    autosem = ((nanstd(temp_avg,1))/sqrt(size(temp_avg,1)));
    auto(isnan(auto)) = 0;
    autosem(isnan(autosem)) = 0;
    clear iJ iK iL temp temp_avg;
    lag(1:(lag(end)),1) = (33.3:33.3:(lag(end)*33.3));
%     figure;
%     hold on; errorbar(lag,auto,autosem, 'o');
%     ylim([0 0.15]);
    
    %% Fit the decay function
    % decay function = A[exp(-kD/tau)+B] %inverse is log
    % terms:
    % A = autocorrelation output for each lag size
    % kD = lag (in number of x-sized bins; in this cas 40ms)
    % tau = timescale(unknown)
    % B = offset
    % solve for B when exp term is 1 and/or 0...but what's A?
    %when exp term is 1, B = 0; when exp term is 0, B = 1.
    
    % decay = fit(lag,auto,'exp1');
    % % the result here is a fit function of a*exp(x*b);
    % % if x = kD, then b = -(1/tau); thus, tau = -(1/b) is B-offset is 0;
    % plot(decay,lag,auto);
    x0 = [1 0 0];
    decay_fun = fittype( @(A,b,B,x) (A*(exp((x*b))+B)) );
    decay = fit(lag,auto,decay_fun, 'StartPoint', x0);
%     plot(decay,lag,auto);
    
    %% Maximize fit
    % sum of squared differences between data and line
    A = decay.A;
    b = decay.b;
    B = decay.B;
    % clear decay;
    tau = 1/((-1)*b);
    for iJ = 1:length(auto)
        pred(iJ,1) = (A.*(exp(b.*lag(iJ,1))+B));
        diff(iJ,1) = auto(iJ,1) - pred(iJ,1);
        diff_sq = diff.^2;
    end
    SSe = sum(diff_sq);
    
    %% collect
    T.auto{iA,1} = auto;
    T.autosem{iA,1} = autosem;
    T.decay{iA,1} = decay;
    T.tau{iA,1} = tau;
    T.A{iA,1} = A;
    T.B{iA,1} = B;
    T.lag{iA,1} = lag;
    T.SSe{iA,1} = SSe;
    
    clearvars -except iA start lagmax T
end

end