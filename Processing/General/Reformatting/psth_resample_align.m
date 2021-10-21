function [data] = psth_resample_align(start)
%% resize set
for iJ = 1:size(start,1)
    for iK = 1:size(start{iJ}.psth,1)
        if size(start{iJ}.psth,2) > 750 && size(start{iJ}.psth,2) < 1500
            data{iJ}(iK,:) = FR_CollapseBins(start{iJ}.psth(iK,:),2);
        elseif size(start{iJ}.psth,2) == 1500
            temp{iJ}(iK,:) = start{iJ}.psth(iK,201:1200);
            data{iJ}(iK,:) = FR_CollapseBins(temp{iJ}(iK,:),2);
        elseif size(start{iJ}.psth,2) == 750
            data{iJ}(iK,:) = start{iJ}.psth(iK,101:600);
        end
    end
end
clear start temp
data = data';

end