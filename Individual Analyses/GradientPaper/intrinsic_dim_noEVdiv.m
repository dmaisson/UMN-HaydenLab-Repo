function out = intrinsic_dim_noEVdiv(in,token,percent)

for iJ = 1:length(in)
    if token == 0
        spikes1{iJ,1} = in{iJ}.psth(:,155:179);
        spikes2{iJ,1} = in{iJ}.psth(:,205:229);
    elseif token == 1
        spikes1{iJ,1} = in{iJ}.psth(:,155:179);
        spikes2{iJ,1} = in{iJ}.psth(:,193:217);
    end
end

%% mFR for each cell (collapse acros trials)
for iJ = 1:length(spikes1)
    epoch1(:,iJ) = nanmean(spikes1{iJ})';
    epoch2(:,iJ) = nanmean(spikes2{iJ})';
end

%% PCA
[~,~,~,~,VarE{1},~] = pca(epoch1);
for iJ = 1:length(VarE{1})
    total_VarE_ep1(iJ,1) = sum(VarE{1}(1:iJ));
end

[~,~,~,~,VarE{2},~] = pca(epoch2);
for iJ = 1:length(VarE{2})
    total_VarE_ep2(iJ,1) = sum(VarE{2}(1:iJ));
end

%% intrinsic dimensionality (# PCs to explain X% of variance)
int_dim(1,1) = length(find(total_VarE_ep1 <= percent));
int_dim(1,2) = length(find(total_VarE_ep2 <= percent));

%% Calculate slope between each set of VarEs
x = 1:length(VarE{1});

for iJ = 2:length(x)
    ep1_slope(iJ) = ((VarE{1}(iJ) - VarE{1}(iJ-1))/(x(iJ) - x(iJ-1)));
    ep2_slope(iJ) = ((VarE{2}(iJ) - VarE{2}(iJ-1))/(x(iJ) - x(iJ-1)));
end

ep1_slope = ep1_slope';
ep2_slope = ep2_slope';

ep1_slope(1) = [];
ep2_slope(1) = [];

%% Collect results
out.int_dim = int_dim;
out.total_VarE_ep1 = total_VarE_ep1;
out.total_VarE_ep2 = total_VarE_ep2;
out.VarE = VarE;
out.ep1_slope = ep1_slope;
out.ep2_slope = ep2_slope;

end