function out = check_variance(in,probs)

for iJ = 1:length(in.safe.Ep1)
    mFRsafe{iJ,1} = nanmean(in.safe.Ep1{iJ}.psth,2);
    mFReqlow{iJ,1} = nanmean(in.eqlow.Ep1{iJ}.psth,2);
    mFReqhigh{iJ,1} = nanmean(in.eqhigh.Ep1{iJ}.psth,2);
    for iK = 1:length(probs)
        mFRlow{iK,1}.Ep1{iJ,1} = nanmean(in.low.Ep1{iK}.cell{iJ}.psth,2);
        mFRhigh{iK,1}.Ep1{iJ,1} = nanmean(in.high.Ep1{iK}.cell{iJ}.psth,2);
    end
end

for iJ = 1:length(mFRsafe)
    variance_S(iJ,1) = var(mFRsafe{iJ});
    variance_eqL(iJ,1) = var(mFReqlow{iJ});
    variance_eqH(iJ,1) = var(mFReqhigh{iJ});
    for iK = 1:length(mFRlow)
        variance_L(iJ,iK) = var(mFRlow{iK}.Ep1{iJ});
        variance_H(iJ,iK) = var(mFRhigh{iK}.Ep1{iJ});
    end
end

out.prop_var_SL = variance_S./variance_L;
out.prop_var_SH = variance_S./variance_H;
out.prop_var_SeqL = variance_S./variance_eqL;
out.prop_var_SeqH = variance_S./variance_eqH;

end
    