function [nondiff,diff] = poscontrol_rate_SV(in)

warning('off','MATLAB:colon:nonIntegerIndex');

for iJ = 1:length(in)
    r = randperm(length(in{iJ}.vars));
    n = length(r);
    data1{iJ,1} = in{iJ}.psth(r(1:(n/2)),155:174);
    data2{iJ,1} = in{iJ}.psth(r((n/2):end),155:174);
end

for iJ = 1:length(in)
    set1{iJ,1} = nanmean(data1{iJ},2);
    set2{iJ,1} = nanmean(data2{iJ},2);
end

for iJ = 1:length(in)
    [~,p(iJ,1)] = ttest2(set1{iJ},set2{iJ});
end

for iJ = 1:length(p)
    if p(iJ,1) <= 0.05
        p(iJ,2) = 1;
    else
        p(iJ,2) = 0;
    end
end

diff = (sum(p(:,2))/length(p(:,2)))*100;
nondiff = 100 - diff;

end