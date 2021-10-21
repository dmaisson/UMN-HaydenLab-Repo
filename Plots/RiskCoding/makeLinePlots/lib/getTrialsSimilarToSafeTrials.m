function [allIdx,idx_noSafe] = getTrialsSimilarToSafeTrials(allTrialdata,allIdx,trialdata_noSafe,idx_noSafe,safeEVwindow,epoch,monkey)

if strcmp(monkey,'Vader'), safeEV = 0.1100;
elseif strcmp(monkey,'Pumbaa'), safeEV = 0.045; end



[allIdx_likeSafe,allIdx_notlikeSafe] = similarEVtoSafe(allTrialdata,safeEV,safeEVwindow,epoch);
[allIdx_nonSafe,allIdx_safe] = Neural_getSafeTrials(allTrialdata);
% because 'likeSafe' and 'notlikeSafe' are specific to the epoch, need to eliminate trials where the other offer was safe:
allIdx_likeSafe = setdiff(allIdx_likeSafe,allIdx_safe);
allIdx_notlikeSafe = setdiff(allIdx_notlikeSafe,allIdx_safe);

allIdx.analysis_2bins.likeSafe.high = allIdx_likeSafe;
allIdx.analysis_2bins.likeSafe.low = allIdx_notlikeSafe;

allIdx.analysis_3bins.likeSafe.high = allIdx_likeSafe;
allIdx.analysis_3bins.likeSafe.low = allIdx_notlikeSafe;

allIdx.analysis_4bins.likeSafe.high = allIdx_likeSafe;
allIdx.analysis_4bins.likeSafe.low = allIdx_notlikeSafe;



[idx_noSafe_likeSafe,idx_noSafe_notlikeSafe] = similarEVtoSafe(trialdata_noSafe,safeEV,safeEVwindow,epoch);
[idx_noSafe_nonSafe,idx_noSafe_safe] = Neural_getSafeTrials(trialdata_noSafe);
% because 'likeSafe' and 'notlikeSafe' are specific to the epoch, need to eliminate trials where the other offer was safe:
idx_noSafe_likeSafe = setdiff(idx_noSafe_likeSafe,idx_noSafe_safe);
idx_noSafe_notlikeSafe = setdiff(idx_noSafe_notlikeSafe,idx_noSafe_safe);

idx_noSafe.analysis_2bins.likeSafe.high = idx_noSafe_likeSafe;
idx_noSafe.analysis_2bins.likeSafe.low = idx_noSafe_notlikeSafe;

idx_noSafe.analysis_3bins.likeSafe.high = idx_noSafe_likeSafe;
idx_noSafe.analysis_3bins.likeSafe.low = idx_noSafe_notlikeSafe;

idx_noSafe.analysis_4bins.likeSafe.high = idx_noSafe_likeSafe;
idx_noSafe.analysis_4bins.likeSafe.low = idx_noSafe_notlikeSafe;


end