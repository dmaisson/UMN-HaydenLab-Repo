function output = sig_spatialInfo_3D(input)

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

for iH = 1:1000
    info_in_bin(1:size(mFR_i,1),1:size(mFR_i,2),1:size(mFR_i,3)) = NaN;
    rand1 = randi(size(prob_i,1));
    rand2 = randi(size(prob_i,2));
    rand3 = randi(size(prob_i,3));
    rand4 = randi(size(prob_i,1));
    rand5 = randi(size(prob_i,2));
    rand6 = randi(size(prob_i,3));
    rand7 = randi(size(prob_i,1));
    rand8 = randi(size(prob_i,2));
    rand9 = randi(size(prob_i,3));
    for iJ = 1:size(mFR_i,1)
        for iK = 1:size(mFR_i,2)
            for iL = 1:size(mFR_i,3)
                info_in_bin(iJ,iK,iL) = abs(prob_i(rand1,rand2,rand3)*...
                    (mFR_i(rand4,rand5,rand6)/mFR)*log2(mFR_i(rand7,rand8,rand9)/mFR));
                if isnan(info_in_bin(iJ,iK,iL))
                    info_in_bin(iJ,iK,iL) = 0;
                end
            end
        end
    end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
    shuffle(iH,1) = sum(info_in_bin(:));
end
shuffle = sort(shuffle);   
rank = find(input.spatialInfo3D > shuffle);
Info_pvalue = size(rank,1)/1000;
if Info_pvalue >= 0.95
    sig = 1;
else
    sig = 0;
end

output = input;
output.shuffle3D = shuffle;
output.rank3D = rank;
output.Info_pvalue3D = Info_pvalue;
output.sig3D = sig;