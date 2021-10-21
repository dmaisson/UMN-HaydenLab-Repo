function [allFactors,allTrialdata,allIdx] = eliminateInaccurateTrials(allFactors,allTrialdata,allIdx)

accuracy = [allTrialdata.accuracy];
accurateTrials = find(accuracy);

allFactors = allFactors(:,accurateTrials,:);
allTrialdata = allTrialdata(accurateTrials);

fn2 = fieldnames(allIdx.analysis_2bins);
fn3 = fieldnames(allIdx.analysis_3bins);
fn4 = fieldnames(allIdx.analysis_4bins);

for i = 1:length(fn2)
    
    thisIdx_high = eval(['allIdx.analysis_2bins.' fn2{i} '.high']);
    newIdx_high = intersect(thisIdx_high,accurateTrials);
    eval(['allIdx.analysis_2bins.' fn2{i} '.high = newIdx_high;']);
    
    thisIdx_low = eval(['allIdx.analysis_2bins.' fn2{i} '.low']);
    newIdx_low = intersect(thisIdx_low,accurateTrials);
    eval(['allIdx.analysis_2bins.' fn2{i} '.low = newIdx_low;']);
    
end

for i = 1:length(fn3)
    
    thisIdx_high = eval(['allIdx.analysis_3bins.' fn3{i} '.high']);
    newIdx_high = intersect(thisIdx_high,accurateTrials);
    eval(['allIdx.analysis_3bins.' fn3{i} '.high = newIdx_high;']);
    
    try
        thisIdx_mid = eval(['allIdx.analysis_3bins.' fn3{i} '.mid']);
        newIdx_low = intersect(thisIdx_mid,accurateTrials);
        eval(['allIdx.analysis_3bins.' fn3{i} '.mid = newIdx_mid;']);
    end
    
    thisIdx_low = eval(['allIdx.analysis_3bins.' fn3{i} '.low']);
    newIdx_low = intersect(thisIdx_low,accurateTrials);
    eval(['allIdx.analysis_3bins.' fn3{i} '.low = newIdx_low;']);
    
end

for i = 1:length(fn4)
    
    thisIdx_high = eval(['allIdx.analysis_3bins.' fn4{i} '.high']);
    newIdx_high = intersect(thisIdx_high,accurateTrials);
    eval(['allIdx.analysis_3bins.' fn4{i} '.high = newIdx_high;']);
    
    try
        thisIdx_mid = eval(['allIdx.analysis_3bins.' fn4{i} '.mid']);
        newIdx_low = intersect(thisIdx_mid,accurateTrials);
        eval(['allIdx.analysis_3bins.' fn4{i} '.mid = newIdx_mid;']);
    end
    
    thisIdx_low = eval(['allIdx.analysis_3bins.' fn4{i} '.low']);
    newIdx_low = intersect(thisIdx_low,accurateTrials);
    eval(['allIdx.analysis_3bins.' fn4{i} '.low = newIdx_low;']);
    
    
end


end