function [out] = mFR_riskVrisk_SV(in,probs,sv)
%% Separate data by epoch, offer type, and prob range
for iJ = 1:length(in)
    for iL = length(in{iJ}.vars):-1:1
        if in{iJ}.vars(iL,2) == 0 || in{iJ}.vars(iL,5) == 0
            in{iJ}.vars(iL,:) = [];
            in{iJ}.psth(iL,:) = [];
        end
    end
end

for iJ = 1:length(probs)-1
    for iL = 1:length(in)
        low.Ep1{iJ,1}.cell{iL,1}.vars(1:10,1:3) = NaN;
        low.Ep1{iJ,1}.cell{iL,1}.psth(1:10,1:25) = NaN;
        
        high.Ep1{iJ,1}.cell{iL,1}.vars(1:10,1:3) = NaN;
        high.Ep1{iJ,1}.cell{iL,1}.psth(1:10,1:25) = NaN;
        
        low.Ep2{iJ,1}.cell{iL,1}.vars(1:10,1:3) = NaN;
        low.Ep2{iJ,1}.cell{iL,1}.psth(1:10,1:25) = NaN;
        
        high.Ep2{iJ,1}.cell{iL,1}.vars(1:10,1:3) = NaN;
        high.Ep2{iJ,1}.cell{iL,1}.psth(1:10,1:25) = NaN;
    end
end

for iJ = 1:length(in)
    for iL = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iL,2) == 2
            % 2. risky offers with low stakes
            for iK = 1:length(probs)-1
                if in{iJ}.vars(iL,1) > probs(iK) && ...
                        in{iJ}.vars(iL,1) < probs(iK+1) %if prob is in range
                    low.Ep1{iK,1}.cell{iJ,1}.vars(iL,:) = in{iJ}.vars(iL,1:3);
                    low.Ep1{iK,1}.cell{iJ,1}.psth(iL,:) = in{iJ}.psth(iL,155:179);
                end
            end
        elseif in{iJ}.vars(iL,2) == 3
            % 3. risky offers with high stakes
            for iK = 1:length(probs)-1
                if in{iJ}.vars(iL,1) > probs(iK) && ...
                        in{iJ}.vars(iL,1) < probs(iK+1) %if prob is in range
                    high.Ep1{iK,1}.cell{iJ,1}.vars(iL,:) = in{iJ}.vars(iL,1:3);
                    high.Ep1{iK,1}.cell{iJ,1}.psth(iL,:) = in{iJ}.psth(iL,155:179);
                end
            end
        end
        %EPOCH2
        if in{iJ}.vars(iL,5) == 2
            % 2. risky offers with low stakes
            for iK = 1:length(probs)-1
                if in{iJ}.vars(iL,4) > probs(iK) && ...
                        in{iJ}.vars(iL,4) < probs(iK+1) %if prob is in range
                    low.Ep2{iK,1}.cell{iJ,1}.vars(iL,:) = in{iJ}.vars(iL,4:6);
                    low.Ep2{iK,1}.cell{iJ,1}.psth(iL,:) = in{iJ}.psth(iL,205:229);
                end
            end
        elseif in{iJ}.vars(iL,5) == 3
            % 3. risky offers with high stakes
            for iK = 1:length(probs)-1
                if in{iJ}.vars(iL,4) > probs(iK) && ...
                        in{iJ}.vars(iL,4) < probs(iK+1) %if prob is in range
                    high.Ep2{iK,1}.cell{iJ,1}.vars(iL,:) = in{iJ}.vars(iL,4:6);
                    high.Ep2{iK,1}.cell{iJ,1}.psth(iL,:) = in{iJ}.psth(iL,205:229);
                end
            end
        end
    end
end

%% clear empty spots from sets
for iJ = 1:length(low.Ep1)
    for iK = 1:length(low.Ep1{iJ}.cell)
        for iL = length(low.Ep1{iJ}.cell{iK}.vars):-1:1
            if low.Ep1{iJ}.cell{iK}.vars(iL,2) == 0
                low.Ep1{iJ}.cell{iK}.vars(iL,:) = [];
                low.Ep1{iJ}.cell{iK}.psth(iL,:) = [];
            end
        end
    end
    for iK = 1:length(high.Ep1{iJ}.cell)
        for iL = length(high.Ep1{iJ}.cell{iK}.vars):-1:1
            if high.Ep1{iJ}.cell{iK}.vars(iL,2) == 0
                high.Ep1{iJ}.cell{iK}.vars(iL,:) = [];
                high.Ep1{iJ}.cell{iK}.psth(iL,:) = [];
            end
        end
    end
end

for iJ = 1:length(low.Ep2)
    for iK = 1:length(low.Ep2{iJ}.cell)
        for iL = length(low.Ep2{iJ}.cell{iK}.vars):-1:1
            if low.Ep2{iJ}.cell{iK}.vars(iL,2) == 0
                low.Ep2{iJ}.cell{iK}.vars(iL,:) = [];
                low.Ep2{iJ}.cell{iK}.psth(iL,:) = [];
            end
        end
    end
    for iK = 1:length(high.Ep2{iJ}.cell)
        for iL = length(high.Ep2{iJ}.cell{iK}.vars):-1:1
            if high.Ep2{iJ}.cell{iK}.vars(iL,2) == 0
                high.Ep2{iJ}.cell{iK}.vars(iL,:) = [];
                high.Ep2{iJ}.cell{iK}.psth(iL,:) = [];
            end
        end
    end
end

clear iJ iK iL;
%% concatenate two epochs

for iJ = 1:length(probs)-1
    for iL = 1:length(low.Ep1{iJ}.cell)
        low.both{iJ,1}.cell{iL,1}.vars = cat(1,low.Ep1{iJ}.cell{iL}.vars,...
            low.Ep2{iJ}.cell{iL}.vars);
        low.both{iJ,1}.cell{iL,1}.psth = cat(1,low.Ep1{iJ}.cell{iL}.psth,...
            low.Ep2{iJ}.cell{iL}.psth);
        high.both{iJ,1}.cell{iL,1}.vars = cat(1,high.Ep1{iJ}.cell{iL}.vars,...
            high.Ep2{iJ}.cell{iL}.vars);
        high.both{iJ,1}.cell{iL,1}.psth = cat(1,high.Ep1{iJ}.cell{iL}.psth,...
            high.Ep2{iJ}.cell{iL}.psth);
    end
end

%% 1. calculate the average firing rate in response to gamble offers 
    %for each prob range
for iK = 1:length(low.Ep1)
    for iJ = 1:length(low.Ep1{iK}.cell)
        x = nanmean(low.both{iK}.cell{iJ}.psth,1).*50;
        mFR.low(iJ,iK) = nanmean(x);
        sem.low(iJ,iK) = (nanstd(x)/sqrt(length(x)));
    end
end
clear Ep1low Ep2low x iJ iK iL;

%% 2. ""                   "" high stakes ""
for iK = 1:length(high.Ep1)
    for iJ = 1:length(high.Ep1{iK}.cell)
        x = nanmean(high.both{iK}.cell{iJ}.psth,1).*50;
        mFR.high(iJ,iK) = nanmean(x);
        sem.high(iJ,iK) = (nanstd(x)/sqrt(length(x)));
    end
end
clear Ep1high Ep2high x iJ iK iL;

%% 3. For each cell, t-test FRs between safe and gamble for each prob bin

% Calculate mFR for gamble trial across time, for each prob bin
for iJ = 1:length(low.Ep1)
    for iL = 1:length(low.Ep1{iJ}.cell)
        tlow{iJ,1}{iL,1} = nanmean(low.both{iJ}.cell{iL}.psth,2).*50; %averages across trials
    end
end

for iJ = 1:length(high.Ep1)
    if isnan(sv(iJ,1)) || sv(iJ,1) == 0
        for iK = 1:length(in)
            thigh{iJ,1}{iK,1} = NaN;
        end
    else
        x = find(probs == sv(iJ,1));
        for iL = 1:length(high.Ep1{iJ}.cell)
            thigh{iJ,1}{iL,1} = nanmean(high.both{x}.cell{iL}.psth,2).*50; %averages across trials
        end
    end
end

for iJ = 1:length(high.Ep1)
    for iL = 1:length(high.Ep1{iJ}.cell)
        control{iJ,1}{iL,1} = nanmean(high.both{iJ}.cell{iL}.psth,2).*50; %averages across trials
    end
end

% for each prob bin, run a t-test between each cell
for iJ = 1:length(tlow)
    for iL = 1:length(tlow{iJ})
        [~,test{iJ,1}(iL,1)] = ttest2(tlow{iJ}{iL},thigh{iJ}{iL},'Alpha',0.05);
        [~,controltest{iJ,1}(iL,1)] = ttest2(tlow{iJ}{iL},control{iJ}{iL},'Alpha',0.05);
    end
end
clear ci p stats tsafe thigh tlow iJ iK iL;

%% Collect variables
out.high = high;
out.low = low;
out.mFR = mFR;
out.sem = sem;
out.probs = probs;
out.test = test;
out.control = controltest;

end