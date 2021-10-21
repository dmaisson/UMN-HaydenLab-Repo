function VarE = exp_variance(in,token)

varEV1 = in.modrate.r.EV1;
varEV2 = in.modrate.r.EV2;

for iJ = 1:size(varEV1,1)
    for iK = 1:size(varEV1,2)
        VarE{1}(iJ,iK) = (varEV1(iJ,iK) * varEV1(iJ,iK))*100;%across time
    end
end
for iJ = 1:size(varEV2,1)
    for iK = 1:size(varEV2,2)
        VarE{2}(iJ,iK) = (varEV2(iJ,iK) * varEV2(iJ,iK))*100;
    end
end

VarE{3} = nanmean(VarE{1},1);%across trials
VarE{4} = nanmean(VarE{2},1);
VarE{5} = nanstd(VarE{1},1)/sqrt(size(VarE{1},1));
VarE{6} = nanstd(VarE{2},1)/sqrt(size(VarE{2},1));
if token == 0
VarE{7} = nanmean(VarE{3}(12:17));%across epoch
VarE{8} = nanmean(VarE{4}(22:27));
VarE{9} = nanmean(VarE{5}(12:17));
VarE{10} = nanmean(VarE{6}(22:27));
elseif token == 1
VarE{7} = nanmean(VarE{3}(12:17));%across epoch
VarE{8} = nanmean(VarE{4}(19:24));
VarE{9} = nanmean(VarE{5}(12:17));
VarE{10} = nanmean(VarE{6}(19:24));
end

end