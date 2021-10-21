function aIdx = alignmentIdx_fullboot(mat1,mat2,mat3,sel_dim)

temp = cat(1,mat1(1:size(mat1,1)/2,:),mat2(1:size(mat1,1)/2,:));
startleft = cat(1,temp,mat3(1:size(mat1,1)/2,:));
clear temp;
temp = cat(1,mat1((size(mat1,1)/2)+1:end,:),mat2((size(mat1,1)/2)+1:100,:));
startright = cat(1,temp,mat3((size(mat1,1)/2)+1:100,:));
clear temp

r = randperm(size(startleft,1));
for iJ = 1:size(mat1,1)/2
    left(iJ,:) = startleft(r(iJ),:);
end
r = randperm(size(startright,1));
for iJ = 1:size(mat1,1)/2
    right(iJ,:) = startright(r(iJ),:);
end
umat1 = cat(1,left,right);

r = randperm(size(startleft,1));
for iJ = 1:size(mat1,1)/2
    left(iJ,:) = startleft(r(iJ),:);
end
r = randperm(size(startright,1));
for iJ = 1:size(mat1,1)/2
    right(iJ,:) = startright(r(iJ),:);
end
umat2 = cat(1,left,right);

r = randperm(size(mat1,2));
for iJ = 1:length(r)
    tmat1(:,iJ) = umat1(:,r(iJ));
end
r = randperm(size(mat1,2));
for iJ = 1:length(r)
    tmat2(:,iJ) = umat2(:,r(iJ));
end

%% This function is to calculate how much each eigenvectors are aligned.
    %   We take PCs from one data set, and covariance matrix from the other data set.
    [PC_2,~,~]= pca(tmat2,'Rows', 'complete');
    Cov_1 = nancov(tmat1);
    [~, Eig_val] = eig(Cov_1);
    Eig_val_1 = sort(diag(Eig_val),'descend');
    
    if sel_dim > 0 % This is for testing with selected number of dimension.
       PC_2 = PC_2(:, 1:sel_dim); 
       Eig_val_1 = Eig_val_1(1:sel_dim);
    end
    aIdx = trace(PC_2'*Cov_1*PC_2)/sum(Eig_val_1); % Compute for original
    clear PC_2 Cov_1 Eig_val Eig_val_1;
    
        
end