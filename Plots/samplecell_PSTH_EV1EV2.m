function [mEV1,mEV1Er,mEV2,mEV2Er] = samplecell_PSTH_EV1EV2(data,collapse,col_factor)

for iJ = 1:size(data.psth,1)
    if data.vars(iJ,3) >= data.vars(iJ,6)
        EV1(iJ,:) = data.psth(iJ,100:299);
        EV2(iJ,1:200) = NaN;
    elseif data.vars(iJ,3) <= data.vars(iJ,6)
        EV2(iJ,:) = data.psth(iJ,100:299);
        EV1(iJ,1:200) = NaN;
    end
end

if collapse == 1
EV1 = FR_CollapseBins(EV1,col_factor);
EV2 = FR_CollapseBins(EV2,col_factor);
end

mEV1 = nanmean(EV1);
mEV1Er = (nanstd(EV1))/sqrt(size(EV1,1));
mEV1_upper = (mEV1+mEV1Er);
mEV1_lower = (mEV1-mEV1Er);

mEV2 = nanmean(EV2);
mEV2Er = (nanstd(EV2))/sqrt(size(EV2,1));
mEV2_upper = (mEV2+mEV2Er);
mEV2_lower = (mEV2-mEV2Er);

xticks = linspace(-1,3,size(mEV1,2));

figure;
hold on;
plot(xticks,smoothdata(mEV1));
plot(xticks,smoothdata(mEV1_upper));
plot(xticks,smoothdata(mEV1_lower));
plot(xticks,smoothdata(mEV2));
plot(xticks,smoothdata(mEV2_upper));
plot(xticks,smoothdata(mEV2_lower));

end