function [PCs, VarE, projected1, projected2] = project_to_lowD_DM(raw_fr1, raw_fr2)

	%% This function is to linearly reduce dimension based on PCA (or Factor Analysis)
	%	Input for reach epoch is Gaussian smoothed firing rate data.
    %   Shape of the input is "(n_time x n_cond) x n_neuron" matrix. 
	%   Output is eigenvector and variance explained. 
    
	% 1. Perform dimensionality reduction
    % provides the projection matrix, the eigvalues, and the explained
    % variance due to each PC, from the first data set
    [PCs, a, b, c, VarE{1},d] = pca(raw_fr1,'Algorithm','eig');
		
	% Sanity check (it works fine)
    if size(PCs,1) ~= size(PCs,2)
        check(1,1) = size(PCs,1);
        check(1,2) = size(PCs,2);
        [n,I] = min(check);
        if I == 1
            PCs(:,n+1:end) = [];
        elseif I == 2
            PCs(n+1:end,:) = [];
        end
    else n = length(PCs);
    end
    ProjMat = PCs'; %transposes the projection matrix
    projected1 = zeros( size(raw_fr1(:,1:n)) ); projected2 = zeros( size(raw_fr1(:,1:n)) );
    for iD = 1 : size(raw_fr1(1:size(ProjMat,1),:), 1)
        % for each row, project the data into the PC space; then repeat the
        % process by projecting the second data set into that same PC space
        projected1(iD, :) = ProjMat*raw_fr1(iD, 1:n)';
        projected2(iD, :) = ProjMat*raw_fr2(iD, 1:n)';
    end
	VarE{2}	= (100*nanvar(projected2)./sum(nanvar(projected2)))';		
end