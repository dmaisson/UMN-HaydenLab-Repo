function aIdx = generate_random_alignIndex(all_epoch_data)

	%% This function is to generate random alignment index. 
    %   The function is implicating 
	[~, n_neuron] = size(all_epoch_data); %
	
	cov_all = cov(all_epoch_data);
	[eigVect, eigVal] = eig(cov_all);
	var_data = 1;   n_set = 2;
	n_boot	 = 1000; n_dim = 10;
	
	aIdx = zeros( n_boot, 1 );
	for iB = 1 : n_boot
        rand_dim = [datasample(1:n_neuron, n_neuron, 'replace', false); ...
            datasample(1:n_neuron, n_neuron, 'replace', false)];
		rand_dim = rand_dim';
		
 		vAlign = cell( 1, n_set );
        for i = 1 : n_set
            rng(iB+7*i);
            sel_eigVect = eigVect(:, rand_dim(:, i)); 
            diag_eigVal = diag(eigVal);
            sel_eigVal  = diag(diag_eigVal(rand_dim(:, i))); 
            
            %this is just a randomly generated set of normally distributed
            %data. It is meant to serve as cell X PC (top 10) set of fake
            %PCs(?)
            v = var_data.*randn(n_dim, n_neuron)'; 
            
            denominator = norm(sel_eigVect*sqrt(sel_eigVal)*v);
            numerator	= sel_eigVect*sqrt(sel_eigVal)*v;
            vAlign{i}	= orth(numerator/denominator);
        end
		aIdx(iB, 1) = trace(vAlign{2}'*vAlign{1}*vAlign{1}'*vAlign{2})/n_dim;	
	end
end