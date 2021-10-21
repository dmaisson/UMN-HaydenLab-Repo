clear;

%% options
monkey = 'Pumbaa';
epoch = 'offer2';
measure = 'likeSafe'; % you can see a list of measures with built-in indices by opening 'allIdx.analysis_3bins'
accurateTrialsOnly = 1;
safeEVwindow = 0.05; %(for getting trials that are similar value to safe trials); "0.05" means within 5 percent
plotOpt.plotHigh = 1; 
plotOpt.plotLow = 0; 
plotOpt.plotSafe = 1;

%% execution

% start by loading your factors, wrapped trials ("trialdata"), and indices ("idx")
dataDirectory = ['C:\Users\Phase_Space\Documents\export'];
cd(dataDirectory);
eval(['load(''' monkey '_factors.mat'');']);

% remove inaccurate trials if you want
if accurateTrialsOnly, [allFactors,allTrialdata,allIdx] = eliminateInaccurateTrials(allFactors,allTrialdata,allIdx); end

% get a version of your factors, trialdata, and index WITHOUT safe trials
dealWithSafeTrials;

% add in an index that compares safe trials to those with similar value
[allIdx,idx_noSafe] = getTrialsSimilarToSafeTrials(allTrialdata,allIdx,trialdata_noSafe,idx_noSafe,safeEVwindow,epoch,monkey);

% plot lines
printTrajectoryFigs(measure,allFactors,allTrialdata,allIdx,factors_noSafe,trialdata_noSafe,idx_noSafe,monkey,plotOpt)
