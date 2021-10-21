function output = sig_spatialInfo(input)

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

for iH = 1:1000
    info_in_bin(1:size(mFR_i,1),1:size(mFR_i,2)) = NaN;
    rand1 = randi(size(prob_i,1));
    rand2 = randi(size(prob_i,2));
    rand3 = randi(size(prob_i,1));
    rand4 = randi(size(prob_i,2));
    rand5 = randi(size(prob_i,1));
    rand6 = randi(size(prob_i,2));
    for iJ = 1:size(mFR_i,1)
        for iK = 1:size(mFR_i,2)
            info_in_bin(iJ,iK) = abs(prob_i(rand1,rand2)*...
                (mFR_i(rand3,rand4)/mFR)*log2(mFR_i(rand5,rand6)/mFR));
%             if isnan(info_in_bin(iJ,iK))
%                 info_in_bin(iJ,iK) = 0;
%             end
        end
    end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
    shuffle(iH,1) = nansum(info_in_bin(:));
end
shuffle = sort(shuffle);   
rank = find(input.spatialInfo > shuffle);
Info_pvalue = size(rank,1)/1000;
if Info_pvalue >= 0.95
    sig = 1;
else
    sig = 0;
end

output = input;
output.shuffle = shuffle;
output.rank = rank;
output.Info_pvalue = Info_pvalue;
output.sig = sig;