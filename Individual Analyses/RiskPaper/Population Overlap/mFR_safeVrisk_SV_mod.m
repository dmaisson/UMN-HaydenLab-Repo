function [out] = mFR_safeVrisk_SV_mod(in,rng)
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
probs = 0:rng:1;

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
        
        safe.pre_trial{iK,1}.psth(1:10,1:25) = NaN;
        
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
            safe.Ep1{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
            safe.Ep1{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
            
            safe.pre_trial{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,125:149);
                        
        elseif in{iJ}.vars(iK,2) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) <= probs(iL+1) %if prob is in range
                    tlow.Ep1{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,1:4);
                    tlow.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
                    tlow.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                end
            end
        elseif in{iJ}.vars(iK,2) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) <= probs(iL+1) %if prob is in range
                    thigh.Ep1{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,1:4);
                    thigh.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
                    thigh.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                end
            end
        end
        
        if in{iJ}.vars(iK,5) == 1
            % 1. safe offers
            safe.Ep2{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
            safe.Ep2{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
            safe.Ep2{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
        elseif in{iJ}.vars(iK,5) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    tlow.Ep2{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
                    tlow.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
                    tlow.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
                end
            end
        elseif in{iJ}.vars(iK,5) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    thigh.Ep2{iL,1}.cell{iJ,1}.vars(iK,:) = in{iJ}.vars(iK,4:7);
                    thigh.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = in{iJ}.vars(iK,9);
                    thigh.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
                end
            end
        end
    end
end


%% clear empty spots from sets
for iA = 1:size(safe.Ep1,1)
    safe.Ep1{iA,1}.psth = safe.Ep1{iA,1}.psth((~isnan(safe.Ep1{iA,1}.vars(:,1))&(safe.Ep1{iA,1}.vars(:,1)~=0)),:);
    safe.Ep1{iA,1}.vars = safe.Ep1{iA,1}.vars((~isnan(safe.Ep1{iA,1}.vars(:,1))&(safe.Ep1{iA,1}.vars(:,1)~=0)),:);
    
    safe.Ep2{iA,1}.psth = safe.Ep2{iA,1}.psth((~isnan(safe.Ep2{iA,1}.vars(:,1))&(safe.Ep2{iA,1}.vars(:,1)~=0)),:);
    safe.Ep2{iA,1}.vars = safe.Ep2{iA,1}.vars((~isnan(safe.Ep2{iA,1}.vars(:,1))&(safe.Ep2{iA,1}.vars(:,1)~=0)),:);
       
    safe.pre_trial{iA,1}.psth = safe.pre_trial{iA,1}.psth((~isnan(safe.Ep1{iA,1}.vars(:,1))&(safe.Ep1{iA,1}.vars(:,1)~=0)),:);
end
    
for iB = 1:size(tlow.Ep1,1)
    for iA = 1:size(tlow.Ep1{iB}.cell,1)
        tlow.Ep1{iB,1}.cell{iA,1}.psth = tlow.Ep1{iB,1}.cell{iA,1}.psth((~isnan(tlow.Ep1{iB,1}.cell{iA,1}.vars(:,1))&(tlow.Ep1{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        tlow.Ep1{iB,1}.cell{iA,1}.vars = tlow.Ep1{iB,1}.cell{iA,1}.vars((~isnan(tlow.Ep1{iB,1}.cell{iA,1}.vars(:,1))&(tlow.Ep1{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        
        tlow.Ep2{iB,1}.cell{iA,1}.psth = tlow.Ep2{iB,1}.cell{iA,1}.psth((~isnan(tlow.Ep2{iB,1}.cell{iA,1}.vars(:,1))&(tlow.Ep2{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        tlow.Ep2{iB,1}.cell{iA,1}.vars = tlow.Ep2{iB,1}.cell{iA,1}.vars((~isnan(tlow.Ep2{iB,1}.cell{iA,1}.vars(:,1))&(tlow.Ep2{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        
        thigh.Ep1{iB,1}.cell{iA,1}.psth = thigh.Ep1{iB,1}.cell{iA,1}.psth((~isnan(thigh.Ep1{iB,1}.cell{iA,1}.vars(:,1))&(thigh.Ep1{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        thigh.Ep1{iB,1}.cell{iA,1}.vars = thigh.Ep1{iB,1}.cell{iA,1}.vars((~isnan(thigh.Ep1{iB,1}.cell{iA,1}.vars(:,1))&(thigh.Ep1{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        
        thigh.Ep2{iB,1}.cell{iA,1}.psth = thigh.Ep2{iB,1}.cell{iA,1}.psth((~isnan(thigh.Ep2{iB,1}.cell{iA,1}.vars(:,1))&(thigh.Ep2{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
        thigh.Ep2{iB,1}.cell{iA,1}.vars = thigh.Ep2{iB,1}.cell{iA,1}.vars((~isnan(thigh.Ep2{iB,1}.cell{iA,1}.vars(:,1))&(thigh.Ep2{iB,1}.cell{iA,1}.vars(:,1)~=0)),:);
    end
end

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



%% Collect variables
out.high = high;
out.low = low;
out.probs = probs;
out.safe = safe;

end