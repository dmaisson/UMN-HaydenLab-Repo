function out = pairwise_corr(in)
%% Define the starting matrices
safemat = in.safemat;
lowmat = in.lowmat;
highmat = in.highmat;

%% Determine the pairwise correlations within each matrix
for iJ = 1:size(safemat,2)
    for iK = 1:size(safemat,2)
        corrmat1(iJ,iK) = corr(safemat(:,iJ), safemat(:,iK));
        corrmat2(iJ,iK) = corr(lowmat(:,iJ), lowmat(:,iK));
        corrmat3(iJ,iK) = corr(highmat(:,iJ),highmat(:,iK));
    end
end
clear iJ iK lowmat highmat;

%% Find the cluster-based ordering of cells within correlation matrix
Z = linkage(corrmat1');
c = cluster(Z,'maxclust',3);
c(:,2) = (1:length(c));
c = sortrows(c,1);
cellorder = c(:,2);
clear Z c;

%% Reorder the original safe data based on cluster
for iJ = 1:size(corrmat1,2)
    mat1(:,iJ) = corrmat1(:,cellorder(iJ));
end
clear cellorder iJ corrmat1 safemat;

%%
figure;
subplot 131
imagesc(mat1); colormap jet; colorbar;
% ax = gca;
% ax.CLim = ([-1 1]);

subplot 132
imagesc(corrmat2); colormap jet; colorbar;
% ax = gca;
% ax.CLim = ([-1 1]);

subplot 133
imagesc(corrmat3); colormap jet; colorbar;
% ax = gca;
% ax.CLim = ([-1 1]);

%% Remove top triangle
for iJ = 1:length(corrmat1)
    if iJ == 1
        corrmat1(iJ,:) = NaN;
        corrmat2(iJ,:) = NaN;
        corrmat3(iJ,:) = NaN;
    else
        corrmat1(iJ,iJ:end) = NaN;
        corrmat2(iJ,iJ:end) = NaN;
        corrmat3(iJ,iJ:end) = NaN;
    end
end

%% calculate the correlation between pairwise correlations safe v risky
for iJ = 1:length(corrmat1)
    if iJ == 1
        pair1 = corrmat1(:,iJ);
    else
        pair1 = cat(1,pair1,corrmat1(:,iJ));
    end
end
for iJ = 1:length(corrmat2)
    if iJ == 1
        pair2 = corrmat2(:,iJ);
    else
        pair2 = cat(1,pair2,corrmat2(:,iJ));
    end
end
for iJ = 1:length(corrmat3)
    if iJ == 1
        pair3 = corrmat3(:,iJ);
    else
        pair3 = cat(1,pair3,corrmat3(:,iJ));
    end
end

for iJ = length(pair1):-1:1
    if isnan(pair1(iJ))
        pair1(iJ) = [];
        pair2(iJ) = [];
        pair3(iJ) = [];
    end
end
[out.corr.safelow.r,out.corr.safelow.p] = corr(pair1,pair2);
[out.corr.safehigh.r,out.corr.safehigh.p] = corr(pair1,pair3);

%% Plot pairwise scatter (pairwise safe vs pairwise risky)
figure;
subplot 121
scatter(pair1,pair2);
xlim([-1 1]);
ylim([-1 1]);
xlabel('pairwise correlation - safe');
ylabel('pairwise correlation - low');

subplot 122
scatter(pair1,pair3);
xlim([-1 1]);
ylim([-1 1]);
xlabel('pairwise correlation - safe');
ylabel('pairwise correlation - high');

end