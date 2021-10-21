function output = spatialInformation_3D(input)
% information = sum_across_bins((probability of being in bin i)*((mFR in
% bin i)/(mFR of cell))*log2*((mFR in
% bin i)/(mFR of cell))
% formally:
% prob_i = prob of being in bin i (i.e. % of time spent in bin)
prob_i = input.occupancy3D./sum(input.occupancy3D(:));
for iJ = 1:size(prob_i,1)
    for iK = 1:size(prob_i,2)
        for iL = 1:size(prob_i,3)
            if prob_i(iJ,iK,iL) == 0
                prob_i(iJ,iK,iL) = NaN;
            end
        end
    end
end
% mFR_i = mean firing rate in bin i
mFR_i = input.binned_rates_normed3D;
% mFR = overal; mean firing rate for the input
mFR = nanmean(input.binned_rates_normed3D(:));
info_in_bin(1:size(mFR_i,1),1:size(mFR_i,2),1:size(mFR_i,3)) = NaN;
for iJ = 1:size(mFR_i,1)
    for iK = 1:size(mFR_i,2)
        for iL = 1:size(mFR_i,3)
            info_in_bin(iJ,iK,iL) = abs(prob_i(iJ,iK,iL)*(mFR_i(iJ,iK,iL)/mFR)*log2(mFR_i(iJ,iK,iL)/mFR));
            if isnan(info_in_bin(iJ,iK,iL))
                info_in_bin(iJ,iK,iL) = 0;
            end
        end
    end
end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
spatialInfo = sum(info_in_bin(:));

output = input;
output.info_in_bin3D = info_in_bin;
output.spatialInfo3D = spatialInfo;