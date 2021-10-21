function [out] = mFR_safeVrisk_SV(in,range)
%This is a function that computes the differences between mean firing rates
%between safe offers and risky offer with SV equivalence

%   This function will first separate trials by epoch (1 and 2), offer type
%   (safe and gamble), and probability range (the range of probibilities
%   for risky offers contained within a bin of mutable size). It will the
%   concatenate the firing rates from both epochs into a single array of a
%   given offer type and prob range. For each offer type, it will then
%   calculate the mean firing rate (for both safe and gamble) for each 
%   probability range (for risky offers). Then, for each cell and each
%   probability range, it will compute a 2-sample t-test against the safe
%   offer mean firing rate to determine which cells have mean firing rates
%   that are the same/different between the safe offer and the risky offer,
%   regardless of SV equivalence (though this particular comparison will be
%   identifiable later, by finding the index of the prob range with SV
%   equivalence and pull on only those comparisons).


%% Set startup variables
n = length(in);
probs = 0:range:1;

%% Separate data by epoch, offer type, and prob range
% get rid of all trils on which prob = 0
for iJ = 1:length(in)
    for iK = length(in{iJ}.vars):-1:1
        if in{iJ}.vars(iK,2) == 0 || in{iJ}.vars(iK,5) == 0
            in{iJ}.vars(iK,:) = [];
            in{iJ}.psth(iK,:) = [];
        end
    end
end
% create an empty set of matrices
for iJ = 1:length(probs)-1
    for iK = 1:length(in)
        safe.Ep1{iK,1}.vars(1:10,1:4) = NaN;
        safe.Ep1{iK,1}.psth(1:10,1:25) = NaN;
        
        safe.Ep2{iK,1}.vars(1:10,1:4) = NaN;
        safe.Ep2{iK,1}.psth(1:10,1:25) = NaN;
        
        tlow.Ep1{iJ,1}.cell{iK,1}.vars(1:10,1:4) = NaN;
        tlow.Ep1{iJ,1}.cell{iK,1}.psth(1:10,1:25) = NaN;
        
        thigh.Ep1{iJ,1}.cell{iK,1}.vars(1:10,1:4) = NaN;
        thigh.Ep1{iJ,1}.cell{iK,1}.psth(1:10,1:25) = NaN;
        
        tlow.Ep2{iJ,1}.cell{iK,1}.vars(1:10,1:4) = NaN;
        tlow.Ep2{iJ,1}.cell{iK,1}.psth(1:10,1:25) = NaN;
        
        thigh.Ep2{iJ,1}.cell{iK,1}.vars(1:10,1:4) = NaN;
        thigh.Ep2{iJ,1}.cell{iK,1}.psth(1:10,1:25) = NaN;
    end
end
% fill the empty matrices with data from the trials and spikes
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,2) == 1
            % 1. safe offers
            safe.Ep1{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,1:4);
            safe.Ep1{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
            safe.Ep1{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
        elseif in{iJ}.vars(iK,2) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) <= probs(iL+1) %if prob is in range
                    tlow.Ep1{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,1:4);
                    tlow.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
                    tlow.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                end
            end
        elseif in{iJ}.vars(iK,2) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) <= probs(iL+1) %if prob is in range
                    thigh.Ep1{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,1:4);
                    thigh.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
                    thigh.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                end
            end
        end
        
        if in{iJ}.vars(iK,5) == 1
            % 1. safe offers
            safe.Ep2{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
            safe.Ep2{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
            safe.Ep2{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
        elseif in{iJ}.vars(iK,5) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    tlow.Ep2{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
                    tlow.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
                    tlow.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
                end
            end
        elseif in{iJ}.vars(iK,5) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    thigh.Ep2{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
                    thigh.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,7);
                    thigh.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
                end
            end
        end
    end
end


%% clear empty spots from sets
for iJ = 1:length(safe.Ep1)
    for iK = length(safe.Ep1{iJ}.vars):-1:1
        if safe.Ep1{iJ}.vars(iK,2) == 0 || isnan(safe.Ep1{iJ}.vars(iK,2))
            safe.Ep1{iJ}.vars(iK,:) = [];
            safe.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iL = 1:length(tlow.Ep1)
        for iK = length(tlow.Ep1{iL}.cell{iJ}.vars):-1:1
            if (tlow.Ep1{iL}.cell{iJ}.vars(iK,2) == 0)...
                    || isempty(tlow.Ep1{iL}.cell{iJ})...
                    || isnan(tlow.Ep1{iL}.cell{iJ}.vars(iK,2))
                tlow.Ep1{iL}.cell{iJ}.vars(iK,:) = [];
                tlow.Ep1{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
    end
    for iL = 1:length(thigh.Ep1)
        for iK = length(thigh.Ep1{iL}.cell{iJ}.vars):-1:1
            if (thigh.Ep1{iL}.cell{iJ}.vars(iK,2) == 0)...
                    || isempty(thigh.Ep1{iL}.cell{iJ})...
                    || isnan(thigh.Ep1{iL}.cell{iJ}.vars(iK,2))
                thigh.Ep1{iL}.cell{iJ}.vars(iK,:) = [];
                thigh.Ep1{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
    end
end

for iJ = 1:length(safe.Ep2)
    for iK = length(safe.Ep2{iJ}.vars):-1:1
        if safe.Ep2{iJ}.vars(iK,2) == 0 || isnan(safe.Ep2{iJ}.vars(iK,2))
            safe.Ep2{iJ}.vars(iK,:) = [];
            safe.Ep2{iJ}.psth(iK,:) = [];
        end
    end
    for iL = 1:length(tlow.Ep2)
        for iK = length(tlow.Ep2{iL}.cell{iJ}.vars):-1:1
            if (tlow.Ep2{iL}.cell{iJ}.vars(iK,2) == 0)...
                    || isempty(tlow.Ep2{iL}.cell{iJ})...
                    || isnan(tlow.Ep2{iL}.cell{iJ}.vars(iK,2))
                tlow.Ep2{iL}.cell{iJ}.vars(iK,:) = [];
                tlow.Ep2{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
    end
    for iL = 1:length(thigh.Ep2)
        for iK = length(thigh.Ep2{iL}.cell{iJ}.vars):-1:1
            if (thigh.Ep2{iL}.cell{iJ}.vars(iK,2) == 0)...
                    || isempty(thigh.Ep2{iL}.cell{iJ})...
                    || isnan(thigh.Ep2{iL}.cell{iJ}.vars(iK,2))
                thigh.Ep2{iL}.cell{iJ}.vars(iK,:) = [];
                thigh.Ep2{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
    end
end

clear iJ iK iL;

%% concatenate +/- X%

for iJ = 1:length(probs)-1
    if iJ < (length(probs)-1)
        for iK = 1:n
            low.Ep1{iJ,1}.cell{iK,1}.vars = ...
                cat(1,tlow.Ep1{iJ}.cell{iK}.vars,tlow.Ep1{iJ+1}.cell{iK}.vars);
            low.Ep1{iJ,1}.cell{iK,1}.psth = ...
                cat(1,tlow.Ep1{iJ}.cell{iK}.psth,tlow.Ep1{iJ+1}.cell{iK}.psth);
            low.Ep2{iJ,1}.cell{iK,1}.vars = ...
                cat(1,tlow.Ep2{iJ}.cell{iK}.vars,tlow.Ep2{iJ+1}.cell{iK}.vars);
            low.Ep2{iJ,1}.cell{iK,1}.psth = ...
                cat(1,tlow.Ep2{iJ}.cell{iK}.psth,tlow.Ep2{iJ+1}.cell{iK}.psth);
            
            high.Ep1{iJ,1}.cell{iK,1}.vars = ...
                cat(1,thigh.Ep1{iJ}.cell{iK}.vars,thigh.Ep1{iJ+1}.cell{iK}.vars);
            high.Ep1{iJ,1}.cell{iK,1}.psth = ...
                cat(1,thigh.Ep1{iJ}.cell{iK}.psth,thigh.Ep1{iJ+1}.cell{iK}.psth);
            high.Ep2{iJ,1}.cell{iK,1}.vars = ...
                cat(1,thigh.Ep2{iJ}.cell{iK}.vars,thigh.Ep2{iJ+1}.cell{iK}.vars);
            high.Ep2{iJ,1}.cell{iK,1}.psth = ...
                cat(1,thigh.Ep2{iJ}.cell{iK}.psth,thigh.Ep2{iJ+1}.cell{iK}.psth);
        end
    else
        for iK = 1:n
            low.Ep1{iJ,1}.cell{iK,1}.vars = tlow.Ep1{iJ}.cell{iK}.vars;
            low.Ep1{iJ,1}.cell{iK,1}.psth = tlow.Ep1{iJ}.cell{iK}.psth;
            low.Ep2{iJ,1}.cell{iK,1}.vars = tlow.Ep2{iJ}.cell{iK}.vars;
            low.Ep2{iJ,1}.cell{iK,1}.psth = tlow.Ep2{iJ}.cell{iK}.psth;

            high.Ep1{iJ,1}.cell{iK,1}.vars = thigh.Ep1{iJ}.cell{iK}.vars;
            high.Ep1{iJ,1}.cell{iK,1}.psth = thigh.Ep1{iJ}.cell{iK}.psth;
            high.Ep2{iJ,1}.cell{iK,1}.vars = thigh.Ep2{iJ}.cell{iK}.vars;
            high.Ep2{iJ,1}.cell{iK,1}.psth = thigh.Ep2{iJ}.cell{iK}.psth;
        end
    end
end
clear tlow thigh;

%% 1. calculate the average firing rate in response to safe offers

for iJ = 1:length(safe.Ep1)
    x = nanmean(safe.Ep1{iJ}.psth,1); %averages across trials
    mFR.safe(iJ,1) = nanmean(x); %averages across time bins
    sem.safe(iJ,1) = (nanstd(x)/sqrt(length(x)));
    clear x;
end
clear iJ;

%% 2. calculate the average firing rate in response to gamble offers 
    %for each prob range
for iL = 1:length(low.Ep1)
    for iJ = 1:length(low.Ep1{iL}.cell)
        x = nanmean(low.Ep1{iL}.cell{iJ}.psth,1);
        mFR.low(iJ,iL) = nanmean(x);
        sem.low(iJ,iL) = (nanstd(x)/sqrt(length(x)));
    end
end
clear Ep1low Ep2low x iJ iK iL;

%% 3. ""                   "" high stakes ""
for iL = 1:length(high.Ep1)
    for iJ = 1:length(high.Ep1{iL}.cell)
        x = nanmean(high.Ep1{iL}.cell{iJ}.psth,1);
        mFR.high(iJ,iL) = nanmean(x);
        sem.high(iJ,iL) = (nanstd(x)/sqrt(length(x)));
    end
end
clear Ep1high Ep2high x iJ iK iL;

%% 4. mFR for ITIs
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        ITI{iJ,1}(iK,:) = in{iJ}.psth(iK,100:149);
    end
end

for iJ = 1:length(ITI)
    mFR.ITI(iJ,1) = nanmean(nanmean(ITI{iJ},2));
end

%% 5. For each cell, t-test FRs between safe and gamble for each prob bin
% Calculate mFR for safe trial across time
for iJ = 1:length(safe.Ep1)
    tsafe{iJ,1} = nanmean(safe.Ep1{iJ}.psth,2); %averages across trials
end

% Calculate mFR for gamble trial across time, for each prob bin
for iJ = 1:length(low.Ep1)
    for iK = 1:length(low.Ep1{iJ}.cell)
        tlow{iJ,1}{iK,1} = nanmean(low.Ep1{iJ}.cell{iK}.psth,2); %averages across trials
    end
end
for iJ = 1:length(high.Ep1)
    for iK = 1:length(high.Ep1{iJ}.cell)
        thigh{iJ,1}{iK,1} = nanmean(high.Ep1{iJ}.cell{iK}.psth,2); %averages across trials
    end
end

% for each prob bin, run a t-test between each cell
for iJ = 1:length(tlow)
    for iK = 1:length(tlow{iJ})
        [~,test{iJ,1}.low(iK,1)] = ttest2(tsafe{iK},tlow{iJ}{iK},'Alpha',0.05);
        [~,test{iJ,1}.high(iK,1)] = ttest2(tsafe{iK},thigh{iJ}{iK},'Alpha',0.05);
    end
end
clear ci p stats tsafe thigh tlow iJ iK iL;

%% Collect variables
out.high = high;
out.low = low;
out.mFR = mFR;
out.sem = sem;
out.probs = probs;
out.safe = safe;
out.test = test;

end