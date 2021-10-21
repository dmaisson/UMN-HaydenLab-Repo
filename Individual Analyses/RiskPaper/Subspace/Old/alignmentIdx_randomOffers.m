function aIdx = alignmentIdx_randomOffers(in,sel_dim)

%% define variables
probs = 0:0.05:1;
probs(7) = 0.3;

%% Separate data by epoch, offer type, and prob range
% get rid of all trils on which prob = 0
for iJ = 1:length(in)
    for iK = length(in{iJ}.vars):-1:1
        if in{iJ}.vars(iK,2) == 0 || in{iJ}.vars(iK,5) == 0
            in{iJ}.vars(iK,:) = [];
            in{iJ}.psth(iK,:) = [];
        end
    end
end
% fill the empty matrices with data from the trials and spikes
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,2) == 1
            % 1. safe offers
            safe{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
            if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                safe{iJ,1}.vars(iK,4) = 1; %side of offer is Left
            elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                safe{iJ,1}.vars(iK,4) = 0; %side of offer is Right
            end
            safe{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
        elseif in{iJ}.vars(iK,2) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    low{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
                    if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        low{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        low{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    low{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
                end
            end
        elseif in{iJ}.vars(iK,2) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    high{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
                    if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        high{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        high{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    high{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
                end
            end
        end
    end
end

for iJ = length(safe):-1:1
    if isempty(safe{iJ})
        safe(iJ) = [];
        for iK = 1:length(probs)-1
            low{iK}.cell(iJ) = [];
            high{iK}.cell(iJ) = [];
        end
    end
end
for iJ = length(low):-1:1
    for iK = 1:length(probs)-1
        if isempty(low{iJ}.cell{iK})
            safe(iK) = [];
            low{iJ}.cell(iK) = [];
            high{iJ}.cell(iK) = [];
        end
    end
end
for iJ = length(high):-1:1
    for iK = 1:length(probs)-1
        if isempty(high{iJ}.cell{iK})
            safe(iK) = [];
            low{iJ}.cell(iK) = [];
            high{iJ}.cell(iK) = [];
        end
    end
end

% clear empty spots from sets
for iJ = 1:length(safe)
    for iK = length(safe{iJ}.vars):-1:1
        if safe{iJ}.vars(iK,2) == 0 || isnan(safe{iJ}.vars(iK,2))
            safe{iJ}.vars(iK,:) = [];
            safe{iJ}.psth(iK,:) = [];
        end
    end
    for iL = 1:length(probs)-1
        for iK = length(low{iL}.cell{iJ}.vars):-1:1
            if low{iL}.cell{iJ}.vars(iK,2) == 0 || isnan(low{iL}.cell{iJ}.vars(iK,2))
                low{iL}.cell{iJ}.vars(iK,:) = [];
                low{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
        for iK = length(high{iL}.cell{iJ}.vars):-1:1
            if high{iL}.cell{iJ}.vars(iK,2) == 0 || isnan(high{iL}.cell{iJ}.vars(iK,2))
                high{iL}.cell{iJ}.vars(iK,:) = [];
                high{iL}.cell{iJ}.psth(iK,:) = [];
            end
        end
    end
end

clear iJ iK iL;
n = length(safe);

%%
for iJ = 1:n %for each cell
    for iK = 1:size(safe{iJ}.vars,1) %for each trial for that cell
        left{iJ,1}(iK,1:50) = NaN; %create NaN array with trial rows and 50 time bins
        right{iJ,1}(iK,1:50) = NaN; %create another
        if safe{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left{iJ,1}(iK,:) = safe{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right{iJ,1}(iK,:) = safe{iJ}.psth(iK,:); %do the same
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left{iJ})';
    temp1right(:,iJ) = nanmean(right{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
safemat = cat(1,temp1left,temp1right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
% safemat = cat(1,temp1,temp2);
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right safe;

%%
for iL = 1:length(probs)-1
    for iJ = 1:n %for each cell
        for iK = 1:size(low{iL}.cell{iJ}.vars,1) %for each trial for that cell
            left{iJ,1}(iK,1:50) = NaN; %create NaN array with trial rows and 50 time bins
            right{iJ,1}(iK,1:50) = NaN; %create another
            if low{iL}.cell{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
                left{iJ,1}(iK,:) = low{iL}.cell{iJ}.psth(iK,:); %fill the NaN array with those FRs
            elseif low{iL}.cell{iJ}.vars(iK,4) == 0 %if the offer position was on the right
                right{iJ,1}(iK,:) = low{iL}.cell{iJ}.psth(iK,:); %do the same
            end
        end
        %take the mean FRs across trials, and transpose into a column
        temp1left(:,iJ) = nanmean(left{iJ})';
        temp1right(:,iJ) = nanmean(right{iJ})';
    end

    %concatenate the matrices on the first dimension, keeping epochs
    %together, sequentially (Ep1left with Ep1right, etc.)
    lowmats{iL,1} = cat(1,temp1left,temp1right);
    clear temp1left temp1right left right;
end

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
% safemat = cat(1,temp1,temp2);
clear iJ iK iL low;

%%
for iL = 1:length(probs)-1
    for iJ = 1:n %for each cell
        for iK = 1:size(high{iL}.cell{iJ}.vars,1) %for each trial for that cell
            left{iJ,1}(iK,1:50) = NaN; %create NaN array with trial rows and 50 time bins
            right{iJ,1}(iK,1:50) = NaN; %create another
            if high{iL}.cell{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
                left{iJ,1}(iK,:) = high{iL}.cell{iJ}.psth(iK,:); %fill the NaN array with those FRs
            elseif high{iL}.cell{iJ}.vars(iK,4) == 0 %if the offer position was on the right
                right{iJ,1}(iK,:) = high{iL}.cell{iJ}.psth(iK,:); %do the same
            end
        end
        %take the mean FRs across trials, and transpose into a column
        temp1left(:,iJ) = nanmean(left{iJ})';
        temp1right(:,iJ) = nanmean(right{iJ})';
    end

    %concatenate the matrices on the first dimension, keeping epochs
    %together, sequentially (Ep1left with Ep1right, etc.)
    highmats{iL,1} = cat(1,temp1left,temp1right);
    clear temp1left temp1right left right;
end

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
% safemat = cat(1,temp1,temp2);
clear iJ iK iL high;

%%
for iG = 1:1000
r = randperm(size(safemat,1));
for iK = 1:size(safemat,1)
    i = randi(3);
    if i == 1
        mat1(iK,:) = safemat(r(iK),:);
    elseif i == 2
        j = randi(length(probs)-1);
        mat1(iK,:) = lowmats{j}(r(iK),:);
    elseif i == 3
        j = randi(length(probs)-1);
        mat1(iK,:) = highmats{j}(r(iK),:);
    end
end

r = randperm(size(safemat,1));
for iK = 1:size(safemat,1)
    i = randi(3);
    if i == 1
        mat2(iK,:) = safemat(r(iK),:);
    elseif i == 2
        j = randi(length(probs)-1);
        mat2(iK,:) = lowmats{j}(r(iK),:);
    elseif i == 3
        j = randi(length(probs)-1);
        mat2(iK,:) = highmats{j}(r(iK),:);
    end
end

%% check variance
for iJ = 1:size(safemat,1)
    h1(iJ,iG) = vartest2(safemat(1,:),mat1(1,:));
    h2(iJ,iG) = vartest2(safemat(1,:),mat2(1,:));
end

%% This function is to calculate how much each eigenvectors are aligned.
    %   We take PCs from one data set, and covariance matrix from the other data set.
    [PC_2,~,~]= pca(mat2,'Rows', 'complete');
    Cov_1 = nancov(mat1);
    [~, Eig_val] = eig(Cov_1);
    Eig_val_1 = sort(diag(Eig_val),'descend');
    
    if sel_dim > 0 % This is for testing with selected number of dimension.
       PC_2 = PC_2(:, 1:sel_dim); 
       Eig_val_1 = Eig_val_1(1:sel_dim);
    end
    aIdx(iG,1) = trace(PC_2'*Cov_1*PC_2)/sum(Eig_val_1); % Compute for original
    clear PC_2 Cov_1 Eig_val Eig_val_1;

end
        
end