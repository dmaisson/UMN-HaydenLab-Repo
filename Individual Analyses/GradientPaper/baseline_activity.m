function out = baseline_activity(start,area)
%area == 0 for vmPFC and pgACC; area == 1 for sgACC and dACC
%% resize the firing rates
for iJ = 1:size(start,1)
    for iK = 1:size(start{iJ}.psth,1)
        if size(start{iJ}.psth,2) > 750 && size(start{iJ}.psth,2) < 1500
            data{iJ}.psth(iK,:) = FR_CollapseBins(start{iJ}.psth(iK,:),2);
        elseif size(start{iJ}.psth,2) == 1500
            temp{iJ}.psth(iK,:) = start{iJ}.psth(iK,201:1200);
            data{iJ}.psth(iK,:) = FR_CollapseBins(temp{iJ}.psth(iK,:),2);
        elseif size(start{iJ}.psth,2) == 750
            data{iJ}.psth(iK,:) = start{iJ}.psth(iK,101:600);
        end
    end
    data{iJ}.vars = start{iJ}.vars;
end
clear start temp
data = data';

%% mean firing rates per epoch
for iJ = 1:length(data)
    x = data{iJ}.psth(50:150);
    if area == 0
    out(iJ,1) = (nanmean(nanmean(x,2)))*50;
    elseif area == 1
    out(iJ,1) = nanmean(nanmean(x,2));
    end
end
figure;
hist(out,25);

end