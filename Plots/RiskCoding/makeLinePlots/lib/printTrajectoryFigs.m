function printTrajectoryFigs(measureName,allFactors,allTrialdata,allIdx,factors_noSafe,trialdata_noSafe,idx_noSafe,monkey,plotOpt)

disp(['getting trajectory figures'])
get_measures; % this is supposed to just convert your wrapped trials into easily referencable variables
% you don't need to run it if you have your own way of indexing trials, as
% long as you end up wtih "measure_high" and "measure_low" below

% Define indices for the lines
[idx_high,idx_low] = getNewIdxFromMeasure(idx_noSafe,'3',measureName,trialdata_noSafe);
% eval(['measure = ' measureName ';']);
% measure_high = measure(idx_high);
% measure_low = measure(idx_low);

lineFigureSize = [600 400];
printTrajectoryFigs_lineGraphs

set(gcf,'Position',[100 100 lineFigureSize(1)+100 lineFigureSize(2)+100]); grid('on');

end