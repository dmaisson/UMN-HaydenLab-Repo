function [PCs, VarE, projected1, projected2] = project_to_lowD(raw_fr1, raw_fr2)

	%% This function is to linearly reduce dimension based on PCA (or Factor Analysis)
	%	Input for reach epoch is Gaussian smoothed firing rate data.
    %   Shape of the input is "(n_time x n_cond) x n_neuron" matrix. 
	%   Output is eigenvector and variance explained. 
    
	% 1. Perform dimensionality reduction
    % provides the projection matrix, the eigvalues, and the explained
    % variance due to each PC, from the first data set
    [PCs, ~, eigVal, ~, VarE{1}] = pca(raw_fr1,'Rows','complete');
		
	% Sanity check (it works fine)
    ProjMat = PCs'; %transposes the projection matrix
    projected1 = zeros( size(raw_fr1) ); projected2 = zeros( size(raw_fr1) );
    for iD = 1 : size(raw_fr1(1:size(ProjMat,1),:), 1)
        % for each row, project the data into the PC space; then repeat the
        % process by projecting the second data set into that same PC space
        projected1(iD, :) = ProjMat*raw_fr1(iD, :)';
        projected2(iD, :) = ProjMat*raw_fr2(iD, :)';
    end
	VarE{2}	= (100*var(projected2)./sum(var(projected2)))';		
end