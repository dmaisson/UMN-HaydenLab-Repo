function output = spatialInformation(input)
% information = sum_across_bins((probability of being in bin i)*((mFR in
% bin i)/(mFR of cell))*log2*((mFR in
% bin i)/(mFR of cell))
% formally:
% prob_i = prob of being in bin i (i.e. % of time spent in bin)
prob_i = input.occupancy./sum(input.occupancy(:));
for iJ = 1:size(prob_i,1)
    for iK = 1:size(prob_i,2)
        if prob_i(iJ,iK) == 0
            prob_i(iJ,iK) = NaN;
        end
    end
end
% mFR_i = mean firing rate in bin i
mFR_i = input.binned_rates_normed;
% mFR = overal; mean firing rate for the input
mFR = nanmean(input.binned_rates_normed(:));
info_in_bin(1:size(mFR_i,1),1:size(mFR_i,2)) = NaN;
for iJ = 1:size(mFR_i,1)
    for iK = 1:size(mFR_i,2)
        info_in_bin(iJ,iK) = abs(prob_i(iJ,iK)*(mFR_i(iJ,iK)/mFR)*log2(mFR_i(iJ,iK)/mFR));
        if isnan(info_in_bin(iJ,iK))
            info_in_bin(iJ,iK) = 0;
        end
    end
end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
spatialInfo = sum(info_in_bin(:));

output = input;
output.info_in_bin = info_in_bin;
output.spatialInfo = spatialInfo;