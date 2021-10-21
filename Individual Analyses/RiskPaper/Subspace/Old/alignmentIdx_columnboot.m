function aIdx = alignmentIdx_columnboot(mat1,mat2,mat3,sel_dim)

r = randperm(size(mat1,2));
for iJ = 1:size(mat1,2)
    ii = randi(3);
    if ii == 1
        umat1(:,iJ) = mat1(:,r(iJ));
    elseif ii == 2
        umat1(:,iJ) = mat2(:,r(iJ));
    elseif ii == 3
        umat1(:,iJ) = mat3(:,r(iJ));
    end
end
r = randperm(size(mat1,2));
for iJ = 1:size(mat1,2)
    ii = randi(3);
    if ii == 1
        umat2(:,iJ) = mat1(:,r(iJ));
    elseif ii == 2
        umat2(:,iJ) = mat2(:,r(iJ));
    elseif ii == 3
        umat2(:,iJ) = mat3(:,r(iJ));
    end
end

%% This function is to calculate how much each eigenvectors are aligned.
    %   We take PCs from one data set, and covariance matrix from the other data set.
    [PC_2,~,~]= pca(umat2,'Rows', 'complete');
    Cov_1 = nancov(umat1);
    [~, Eig_val] = eig(Cov_1);
    Eig_val_1 = sort(diag(Eig_val),'descend');
    
    if sel_dim > 0 % This is for testing with selected number of dimension.
       PC_2 = PC_2(:, 1:sel_dim); 
       Eig_val_1 = Eig_val_1(1:sel_dim);
    end
    aIdx = trace(PC_2'*Cov_1*PC_2)/sum(Eig_val_1); % Compute for original
    clear PC_2 Cov_1 Eig_val Eig_val_1;
        
end