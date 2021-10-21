function [nonSafeTrials,safeTrials] = getSafeTrials(trialdata)

offer1prob = [trialdata.offer1prob];
offer2prob = [trialdata.offer2prob];
nonSafeTrials = find((offer1prob~=1)&(offer2prob~=1));
safeTrials = find((offer1prob==1)|(offer2prob==1));


end