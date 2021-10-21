function [int_dim,total_VarE_ep1,total_VarE_ep2,VarE] = intrinsic_dim(in,token,percent)

for iJ = 1:length(in)
    if token == 0
        spikes1{iJ,1} = in{iJ}.psth(:,155:179);
        spikes2{iJ,1} = in{iJ}.psth(:,205:229);
    elseif token == 1
        spikes1{iJ,1} = in{iJ}.psth(:,155:179);
        spikes2{iJ,1} = in{iJ}.psth(:,193:217);
    end
end

%% separate by condition (EV - in 3 bins)
evs = 0.1:0.1:3;
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,3) > evs(1,1) && in{iJ}.vars(iK,3) <= evs(1,10)
            bin_spikes1{iJ,1}.bin1(iK,:) = spikes1{iJ}(iK,:);
            bin_spikes1{iJ,1}.bin2(iK,1:25) = NaN;
            bin_spikes1{iJ,1}.bin3(iK,1:25) = NaN;
        elseif in{iJ}.vars(iK,3) > evs(1,10) && in{iJ}.vars(iK,3) <= evs(1,20)
            bin_spikes1{iJ,1}.bin2(iK,:) = spikes1{iJ}(iK,:);
            bin_spikes1{iJ,1}.bin1(iK,1:25) = NaN;
            bin_spikes1{iJ,1}.bin3(iK,1:25) = NaN;
        elseif in{iJ}.vars(iK,3) > evs(1,20) && in{iJ}.vars(iK,3) <= evs(1,30)
            bin_spikes1{iJ,1}.bin3(iK,:) = spikes1{iJ}(iK,:);
            bin_spikes1{iJ,1}.bin1(iK,1:25) = NaN;
            bin_spikes1{iJ,1}.bin2(iK,1:25) = NaN;
        end
    end
end

for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,6) > evs(1,1) && in{iJ}.vars(iK,6) <= evs(1,10)
            bin_spikes2{iJ,1}.bin1(iK,:) = spikes2{iJ}(iK,:);
            bin_spikes2{iJ,1}.bin2(iK,1:25) = NaN;
            bin_spikes2{iJ,1}.bin3(iK,1:25) = NaN;
        elseif in{iJ}.vars(iK,6) > evs(1,10) && in{iJ}.vars(iK,6) <= evs(1,20)
            bin_spikes2{iJ,1}.bin2(iK,:) = spikes2{iJ}(iK,:);
            bin_spikes2{iJ,1}.bin1(iK,1:25) = NaN;
            bin_spikes2{iJ,1}.bin3(iK,1:25) = NaN;
        elseif in{iJ}.vars(iK,6) > evs(1,20) && in{iJ}.vars(iK,6) <= evs(1,30)
            bin_spikes2{iJ,1}.bin3(iK,:) = spikes2{iJ}(iK,:);
            bin_spikes2{iJ,1}.bin1(iK,1:25) = NaN;
            bin_spikes2{iJ,1}.bin2(iK,1:25) = NaN;
        end
    end
end

%%
for iJ = 1:length(spikes1)
    bin1(:,iJ) = nanmean(bin_spikes1{iJ}.bin1)';
    bin2(:,iJ) = nanmean(bin_spikes1{iJ}.bin2)';
    bin3(:,iJ) = nanmean(bin_spikes1{iJ}.bin3)';
end
t = cat(1,bin1,bin2);
epoch1 = cat(1,t,bin3);

[~,~,~,~,VarE{1},~] = pca(epoch1);
for iJ = 1:length(VarE{1})
    total_VarE_ep1(iJ,1) = sum(VarE{1}(1:iJ));
end

for iJ = 1:length(spikes1)
    bin1(:,iJ) = nanmean(bin_spikes2{iJ}.bin1)';
    bin2(:,iJ) = nanmean(bin_spikes2{iJ}.bin2)';
    bin3(:,iJ) = nanmean(bin_spikes2{iJ}.bin3)';
end
t = cat(1,bin1,bin2);
epoch2 = cat(1,t,bin3);

[~,~,~,~,VarE{2},~] = pca(epoch2);
for iJ = 1:length(VarE{2})
    total_VarE_ep2(iJ,1) = sum(VarE{2}(1:iJ));
end

%% intrinsic dimensionality (# PCs to explain X% of variance)
int_dim(1,1) = length(find(total_VarE_ep1 <= percent));
int_dim(1,2) = length(find(total_VarE_ep2 <= percent));

end