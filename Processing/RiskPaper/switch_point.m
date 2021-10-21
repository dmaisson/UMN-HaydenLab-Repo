function [flip,y,z] = switch_point(input,minimum,maximum,binsize)
%switch_point: This is a function that determine the 50/50 choice point.

%   This function estimates the probability value for the risky offer
%   that results in an approximately 50/50 choice rate between the safe and
%   risky offers. The risky-offer probibility for which the subject is
%   equally likely to choose the risky and safe offers is the point of
%   Subjective Value Equivalence.

%%
% Finds the probabilities for the low-stakes offers
for iJ = 1:size(input,1)
    for iK = 1:size(input{iJ},1)
        if input{iJ}(iK,2) == 2
            x{iJ,1}(iK,1) = input{iJ}(iK,1);
        elseif input{iJ}(iK,2) ~= 2
            x{iJ,1}(iK,1) = input{iJ}(iK,4);
        end
    end
end

Bins=(minimum:binsize:maximum)';

for iL = 1:length(Bins)
    Bins(iL,2) = 0; %will be used to count low-stakes risk choice
    Bins(iL,3) = 0; %will be used to count high-stakes risk choice
end

% cycle binning matrix over dataset to count events within bin
for iL = 1:size(Bins,1)
    for iK = 1:size(x,1)
        for iJ = 1:size(x{iK},1)
            if (input{iK}(iJ,2) == 1 && input{iK}(iJ,9) == 1)...
                    || (input{iK}(iJ,5) == 1 && input{iK}(iJ,9) == 0)
                if x{iK}(iJ) > Bins(iL,1) && x{iK}(iJ) < Bins(iL+1,1)
                    Bins(iL,2) = Bins(iL,2) + 1; 
                end
            elseif (input{iK}(iJ,2) == 1 && input{iK}(iJ,9) == 0)...
                    || (input{iK}(iJ,5) == 1 && input{iK}(iJ,9) == 1) 
                if x{iK}(iJ) > Bins(iL,1) && x{iK}(iJ) < Bins(iL+1,1) 
                    Bins(iL,3) = Bins(iL,3) + 1;
                end
            end
        end
    end
    y(iL,1)=((Bins(iL,2)/(Bins(iL,3) + Bins(iL,2))*100));
end

z = Bins(:,1);
for iJ = 1:length(y)
    if isnan(y(iJ))
        y(iJ) = 0;
    end
end
n = 50;
[~,~,idx] = unique(round(abs(y-n)),'stable');
temp = idx(max(idx));
flip = z(temp);

end