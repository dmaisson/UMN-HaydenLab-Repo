function [idx_high,idx_low] = getNewIdxFromMeasure(idx_all,analysisBins,measureStr,trialdata_all)

if strcmp(measureStr,'likeSafe')
    idx_high = eval(['idx_all.analysis_' analysisBins 'bins.' measureStr '.high']);
    idx_low = eval(['idx_all.analysis_' analysisBins 'bins.' measureStr '.low']);
else
    measure = eval(['[trialdata_all.' measureStr ']']);
    
    if strcmp(analysisBins,'2')
        
        prctile50 = prctile(measure,50);
        idx_high = find(measure > prctile50);
        idx_low = find(measure <= prctile50);
        
    elseif strcmp(analysisBins,'3')
        
        prctile66 = prctile(measure,66.67);
        prctile33 = prctile(measure,33.33);
        
        idx_high = find(measure > prctile66);
        idx_low = find(measure <= prctile33);
        
    end
end



end