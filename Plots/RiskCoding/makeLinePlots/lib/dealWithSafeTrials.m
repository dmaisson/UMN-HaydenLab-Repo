
offer1prob = [allTrialdata.offer1prob];
offer2prob = [allTrialdata.offer2prob];

allIdx.nonSafeTrials = find((offer1prob~=1)&(offer2prob~=1));
nonSafeTrials = find((offer1prob~=1)&(offer2prob~=1));

trialdata_noSafe = allTrialdata(nonSafeTrials);
factors_noSafe = allFactors(:,nonSafeTrials,:);
[idx_noSafe] = dealWithSafeTrials_fixIndices(allIdx,allTrialdata);

clearvars offer1prob offer2prob


