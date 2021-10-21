function sigs = filter_sigs(in,ind,probs)

for iJ = 1:length(ind)
    sigs.safe.Ep1{iJ,1}.vars = in.safe.Ep1{ind(iJ)}.vars;
    sigs.safe.Ep1{iJ,1}.psth = in.safe.Ep1{ind(iJ)}.psth;
    sigs.safe.Ep2{iJ,1}.vars = in.safe.Ep2{ind(iJ)}.vars;
    sigs.safe.Ep2{iJ,1}.psth = in.safe.Ep2{ind(iJ)}.psth;
    
    sigs.eqlow.Ep1{iJ,1}.vars = in.eqlow.Ep1{ind(iJ)}.vars;
    sigs.eqlow.Ep1{iJ,1}.psth = in.eqlow.Ep1{ind(iJ)}.psth;
    sigs.eqlow.Ep2{iJ,1}.vars = in.eqlow.Ep2{ind(iJ)}.vars;
    sigs.eqlow.Ep2{iJ,1}.psth = in.eqlow.Ep2{ind(iJ)}.psth;
    
    sigs.eqhigh.Ep1{iJ,1}.vars = in.eqhigh.Ep1{ind(iJ)}.vars;
    sigs.eqhigh.Ep1{iJ,1}.psth = in.eqhigh.Ep1{ind(iJ)}.psth;
    sigs.eqhigh.Ep2{iJ,1}.vars = in.eqhigh.Ep2{ind(iJ)}.vars;
    sigs.eqhigh.Ep2{iJ,1}.psth = in.eqhigh.Ep2{ind(iJ)}.psth;
    for iK = 1:length(probs)
        sigs.low.Ep1{iK,1}.cell{iJ,1}.vars = in.low.Ep1{iK}.cell{ind(iJ)}.vars;
        sigs.low.Ep1{iK,1}.cell{iJ,1}.psth = in.low.Ep1{iK}.cell{ind(iJ)}.psth;
        sigs.low.Ep2{iK,1}.cell{iJ,1}.vars = in.low.Ep2{iK}.cell{ind(iJ)}.vars;
        sigs.low.Ep2{iK,1}.cell{iJ,1}.psth = in.low.Ep2{iK}.cell{ind(iJ)}.psth;
        
        sigs.high.Ep1{iK,1}.cell{iJ,1}.vars = in.high.Ep1{iK}.cell{ind(iJ)}.vars;
        sigs.high.Ep1{iK,1}.cell{iJ,1}.psth = in.high.Ep1{iK}.cell{ind(iJ)}.psth;
        sigs.high.Ep2{iK,1}.cell{iJ,1}.vars = in.high.Ep2{iK}.cell{ind(iJ)}.vars;
        sigs.high.Ep2{iK,1}.cell{iJ,1}.psth = in.high.Ep2{iK}.cell{ind(iJ)}.psth;
    end
end
for iJ = 1:length(ind)
    sigs.mFR.safe(iJ,:) = nanmean(nanmean(in.safe.Ep1{ind(iJ),:}.psth));
    sigs.mFR.eqlow(iJ,:) = nanmean(nanmean(in.eqlow.Ep1{ind(iJ),:}.psth));
    sigs.mFR.eqhigh(iJ,:) = nanmean(nanmean(in.eqlow.Ep1{ind(iJ),:}.psth));
    for iK = 1:length(probs)
        sigs.mFR.low(iJ,iK) = nanmean(nanmean(in.low.Ep1{iK}.cell{ind(iJ),:}.psth));
        sigs.mFR.high(iJ,iK) = nanmean(nanmean(in.high.Ep1{iK}.cell{ind(iJ),:}.psth));
    end
end

end