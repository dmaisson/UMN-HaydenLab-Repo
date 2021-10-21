function [output] = mFR_RiskyVsSafe(in,binsize)

% fill cells with NaN
probs = (0:binsize:1)';
for iJ = 1:length(probs)-1
    for iK = 1:length(in)
        for iL = 1:length(in{iK}.vars)
            probbin{iJ,1}.cell{iK,1}.vars(iL,1:size(in{iK}.vars,2)) = NaN;
            probbin{iJ,1}.cell{iK,1}.psth(iL,1:size(in{iK}.psth,2)) = NaN;
        end
    end
end

% separate trials by those in which safe is compared to a given prob range
    % creates a session-length cell array
        % inside each cell in the array is a probability bin-length cell
        % array 
            % inside each cell in the array is a set of trials (vars and
            % psths) for which the gamble offer's probability is within the
            % range of the defined probability-bin
for iJ = 1:length(probbin)
    for iK = 1:length(in)
        for iL = 1:length(in{iK}.vars)
            if in{iK}.vars(iL,2) == 1 % if offer 1 is safe-offer
                if in{iK}.vars(iL,4) > probs(iJ) && ...
                        in{iK}.vars(iL,4) < probs(iJ+1) %if prob is in range
                    probbin{iJ,1}.cell{iK,1}.vars(iL,:) = in{iK}.vars(iL,:);
                    probbin{iJ,1}.cell{iK,1}.psth(iL,:) = in{iK}.psth(iL,:);
                end
            elseif in{iK}.vars(iL,2) ~= 1
                if in{iK}.vars(iL,1) > probs(iJ) && ...
                        in{iK}.vars(iL,1) < probs(iJ+1) %if prob is in range
                    probbin{iJ,1}.cell{iK,1}.vars(iL,:) = in{iK}.vars(iL,:);
                    probbin{iJ,1}.cell{iK,1}.psth(iL,:) = in{iK}.psth(iL,:);
                end
            end
        end
    end
end

%% Calculate the mFR for each epoch1
for iJ = 1:length(probbin)
    for iK = 1:length(probbin{iJ}.cell)
        for iL = 1:length(probbin{iJ}.cell{iK}.vars)
            if probbin{iJ}.cell{iK}.vars(iL,2) == 1 %if offer1 is safe
                output.Ep1{iJ,1}.safe{iK,1}.psth(iL,:) = probbin{iJ}.cell{iK}.psth(iL,155:179);
            elseif probbin{iJ}.cell{iK}.vars(iL,2) ~= 1 %if offer1 is gamble
                output.Ep1{iJ,1}.gamble{iK,1}.psth(iL,:) = probbin{iJ}.cell{iK}.psth(iL,155:179);
            end
            
            if probbin{iJ}.cell{iK}.vars(iL,2) == 1 %if offer1 is safe
                output.Ep2{iJ,1}.safe{iK,1}.psth(iL,:) = probbin{iJ}.cell{iK}.psth(iL,205:229);
            elseif probbin{iJ}.cell{iK}.vars(iL,2) ~= 1 %if offer1 is gamble
                output.Ep2{iJ,1}.gamble{iK,1}.psth(iL,:) = probbin{iJ}.cell{iK}.psth(iL,205:229);
            end
        end
    end
end

%% creates a session X probability bin matrix of mean firing rates
for iJ = 1:length(output.Ep1)
    for iK = 1:length(output.Ep1{iJ}.safe)
        if isempty(output.Ep1{iJ}.safe{iK})
            output.Ep1{iJ}.safe{iK}.psth(1,1) = NaN;
        end
        if isempty(output.Ep2{iJ}.safe{iK})
            output.Ep2{iJ}.safe{iK}.psth(1,1) = NaN;
        end
        if isempty(output.Ep1{iJ}.gamble{iK})
            output.Ep1{iJ}.gamble{iK}.psth(1,1) = NaN;
        end
        if isempty(output.Ep2{iJ}.gamble{iK})
            output.Ep2{iJ}.gamble{iK}.psth(1,1) = NaN;
        end
    end
end

for iJ = 1:length(output.Ep1)
    for iK = 1:length(output.Ep1{iJ}.safe)
        output.Ep1safe.mFR(iK,iJ) = nanmean(nanmean(output.Ep1{iJ}.safe{iK}.psth,1).*50);
        output.Ep1gamble.mFR(iK,iJ) = nanmean(nanmean(output.Ep1{iJ}.gamble{iK}.psth,1).*50);
        output.Ep2safe.mFR(iK,iJ) = nanmean(nanmean(output.Ep2{iJ}.safe{iK}.psth,1).*50);
        output.Ep2gamble.mFR(iK,iJ) = nanmean(nanmean(output.Ep2{iJ}.gamble{iK}.psth,1).*50);
    end
end
for iJ = 1:length(output.Ep1)
    for iK = 1:length(output.Ep1{iJ}.safe)
        output.Ep1safe.sem(iK,iJ) = nanstd(nanmean(output.Ep1{iJ}.safe{iK}.psth,1).*50)/sqrt(length(output.Ep1{iJ}.safe{iK}.psth));
        output.Ep1gamble.sem(iK,iJ) = nanstd(nanmean(output.Ep1{iJ}.gamble{iK}.psth,1).*50)/sqrt(length(output.Ep1{iJ}.safe{iK}.psth));
        output.Ep2safe.sem(iK,iJ) = nanstd(nanmean(output.Ep2{iJ}.safe{iK}.psth,1).*50)/sqrt(length(output.Ep2{iJ}.safe{iK}.psth));
        output.Ep2gamble.sem(iK,iJ) = nanstd(nanmean(output.Ep2{iJ}.gamble{iK}.psth,1).*50)/sqrt(length(output.Ep2{iJ}.safe{iK}.psth));
    end
end
clear iJ;

end