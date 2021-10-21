function out = Multi_LogReg_SV(in)

raw_fr1 = in.ortho.both.safemat;
raw_fr2 = in.ortho.both.lowmat;

    [PCs, ~, ~, ~, ~] = pca(raw_fr1);%,'Rows','complete');
		
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
% 	VarE{2}	= (100*nanvar(projected2)./sum(nanvar(projected2)))';
    
raw_fr2 = in.ortho.both.highmat;

    [PCs, ~, ~, ~, ~] = pca(raw_fr1,'Rows','complete');
		
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
    projected1 = zeros( size(raw_fr1(:,1:n)) ); projected3 = zeros( size(raw_fr1(:,1:n)) );
    for iD = 1 : size(raw_fr1(1:size(ProjMat,1),:), 1)
        % for each row, project the data into the PC space; then repeat the
        % process by projecting the second data set into that same PC space
        projected1(iD, :) = ProjMat*raw_fr1(iD, 1:n)';
        projected3(iD, :) = ProjMat*raw_fr2(iD, 1:n)';
    end
% 	VarE{2}	= (100*nanvar(projected3)./sum(nanvar(projected3)))';
    
    projectedsafe = projected1;
    projectedlow = projected2;
    projectedhigh = projected3;
    
    clearvars -except projectedsafe projectedlow projectedhigh;


    %% Logistic Reg
    % safe vs low
    t = cat(1,projectedsafe,projectedlow);
    d = cat(1,t,projectedhigh);
    a(1:size(projectedsafe,1),1) = 1;
    b(1:size(projectedlow,1),1) = 2;
    c(1:size(projectedlow,1),1) = 3;
    t1 = cat(1,a,b);
    y = cat(1,t1,c);
    x = d(:,1:10);
    
    [out.b,~,~,~,stats] = regress(y,x);
    out.r2 = stats(1,1);
    out.F = stats(1,2);
    out.p = stats(1,3);
    out.errvar = stats(1,4);

end