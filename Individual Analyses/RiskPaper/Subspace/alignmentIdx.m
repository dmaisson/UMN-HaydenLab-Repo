function [aIdx] = alignmentIdx(mat1,mat2,sel_dim)
%% This function compute alignment index
    % The input:
    % mat1 is the first matrix for the data being compared (the actual
    % effect, such as epoch 1 or safe trials, etc). mat2 is the second
    % matrix for the data being compared. mat3 is the first control matrix
    % (such as either odd or even trial data). mat 4 is the second control
    % matrix. sel_dim is the number of selected dimensions (ex. the top 10
    % PCs of the PCA, then sel_dim = 10)
    
    % The output: 
    % is a 4X4 array. The first row, first column, is the
    % alignment index for the matrices in question. The first row, second
    % column is the alignment index for control matrices (odd vs even
    % trials). The second row is the mean and std (first and second,
    % respectively) of the 1000-bootstrap shuffled alignment indeces.

    %% This function is to calculate how much each eigenvectors are aligned.
    %   We take PCs from one data set, and covariance matrix from the other data set.
    [PC_2,~,~]= pca(mat2,'Rows', 'complete');
    Cov_1 = cov(mat1);
    [~, Eig_val] = eig(Cov_1);
    Eig_val_1 = sort(diag(Eig_val),'descend');
    
    if sel_dim > 0 % This is for testing with selected number of dimension.
       PC_2 = PC_2(:, 1:sel_dim); 
       Eig_val_1 = Eig_val_1(1:sel_dim);
    end
    aIdx(1,1) = trace(PC_2'*Cov_1*PC_2)/sum(Eig_val_1); % Compute for original
    clear PC_2 Cov_1 Eig_val Eig_val_1;
    
    [PC_2,~,~]= pca(mat3,'Rows', 'complete');
    Cov_1 = cov(mat1);
    [~, Eig_val] = eig(Cov_1);
    Eig_val_1 = sort(diag(Eig_val),'descend');
    
    if sel_dim > 0 % This is for testing with selected number of dimension.
       PC_2 = PC_2(:, 1:sel_dim); 
       Eig_val_1 = Eig_val_1(1:sel_dim);
    end
    aIdx(1,2) = trace(PC_2'*Cov_1*PC_2)/sum(Eig_val_1); % Compute for original
    clear PC_2 Cov_1 Eig_val Eig_val_1;
        
    %% shuffle value
    tempmat = cat(1,mat1,mat2);
    mat = cat(1,tempmat,mat3);
    control = generate_random_alignIndex(mat);
    aIdx(2,1) = nanmean(control);
    aIdx(2,2) = nanstd(control);
        
end