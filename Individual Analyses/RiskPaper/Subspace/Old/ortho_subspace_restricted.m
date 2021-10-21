function R = ortho_subspace_restricted(in,sv)
%% define variables
probs = 0:0.05:1;

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
            safe.Ep1{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
            if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                safe.Ep1{iJ,1}.vars(iK,4) = 1; %side of offer is Left
            elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                safe.Ep1{iJ,1}.vars(iK,4) = 0; %side of offer is Right
            end
            safe.Ep1{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:174);
        elseif in{iJ}.vars(iK,2) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    low.Ep1{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
                    if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        low.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        low.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    low.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:174);
                end
            end
        elseif in{iJ}.vars(iK,2) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    high.Ep1{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,1:3);
                    if in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        high.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        high.Ep1{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    high.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:174);
                end
            end
        end
        
        if in{iJ}.vars(iK,5) == 1
            % 1. safe offers
            safe.Ep2{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,4:6);
            if in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                safe.Ep2{iJ,1}.vars(iK,4) = 1; %side of offer is Left
            elseif in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                safe.Ep2{iJ,1}.vars(iK,4) = 0; %side of offer is Right
            end
            safe.Ep2{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:224);
        elseif in{iJ}.vars(iK,5) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    low.Ep2{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,4:6);
                    if in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        low.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        low.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    low.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:224);
                end
            end
        elseif in{iJ}.vars(iK,5) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,4) > probs(iL) && ...
                        in{iJ}.vars(iK,4) < probs(iL+1) %if prob is in range
                    high.Ep2{iL,1}.cell{iJ,1}.vars(iK,1:3) = in{iJ}.vars(iK,4:6);
                    if in{iJ}.vars(iK,7) == 0 %if Side of Offer1 is Right
                        high.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = 1; %side of offer is Left
                    elseif in{iJ}.vars(iK,7) == 1 %if Side of Offer1 is Left
                        high.Ep2{iL,1}.cell{iJ,1}.vars(iK,4) = 0; %side of offer is Right
                    end
                    high.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:224);
                end
            end
        end
    end
end

x = find(probs == sv.low);
lowSVeq.Ep1 = low.Ep1{x}.cell;
lowSVeq.Ep2 = low.Ep2{x}.cell;
x = find(probs == sv.high);
highSVeq.Ep1 = high.Ep1{x}.cell;
highSVeq.Ep2 = high.Ep2{x}.cell;
clear low high probs x sv;

for iJ = length(safe.Ep1):-1:1
    if isempty(safe.Ep1{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end
for iJ = length(safe.Ep2):-1:1
    if isempty(safe.Ep2{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end
for iJ = length(lowSVeq.Ep1):-1:1
    if isempty(lowSVeq.Ep1{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end
for iJ = length(lowSVeq.Ep2):-1:1
    if isempty(lowSVeq.Ep2{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end
for iJ = length(highSVeq.Ep1):-1:1
    if isempty(highSVeq.Ep1{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end
for iJ = length(highSVeq.Ep2):-1:1
    if isempty(highSVeq.Ep2{iJ})
        safe.Ep1(iJ) = [];
        safe.Ep2(iJ) = [];
        lowSVeq.Ep1(iJ) = [];
        lowSVeq.Ep2(iJ) = [];
        highSVeq.Ep1(iJ) = [];
        highSVeq.Ep2(iJ) = [];
    end
end

% clear empty spots from sets
for iJ = 1:length(safe.Ep1)
    for iK = length(safe.Ep1{iJ}.vars):-1:1
        if safe.Ep1{iJ}.vars(iK,2) == 0 || isnan(safe.Ep1{iJ}.vars(iK,2))
            safe.Ep1{iJ}.vars(iK,:) = [];
            safe.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(lowSVeq.Ep1{iJ}.vars):-1:1
        if lowSVeq.Ep1{iJ}.vars(iK,2) == 0 || isnan(lowSVeq.Ep1{iJ}.vars(iK,2))
            lowSVeq.Ep1{iJ}.vars(iK,:) = [];
            lowSVeq.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(highSVeq.Ep1{iJ}.vars):-1:1
        if highSVeq.Ep1{iJ}.vars(iK,2) == 0 || isnan(highSVeq.Ep1{iJ}.vars(iK,2))
            highSVeq.Ep1{iJ}.vars(iK,:) = [];
            highSVeq.Ep1{iJ}.psth(iK,:) = [];
        end
    end
end

for iJ = 1:length(safe.Ep2)
    for iK = length(safe.Ep2{iJ}.vars):-1:1
        if safe.Ep2{iJ}.vars(iK,2) == 0 || isnan(safe.Ep2{iJ}.vars(iK,2))
            safe.Ep2{iJ}.vars(iK,:) = [];
            safe.Ep2{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(lowSVeq.Ep2{iJ}.vars):-1:1
        if lowSVeq.Ep2{iJ}.vars(iK,2) == 0 || isnan(lowSVeq.Ep2{iJ}.vars(iK,2))
            lowSVeq.Ep2{iJ}.vars(iK,:) = [];
            lowSVeq.Ep2{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(highSVeq.Ep2{iJ}.vars):-1:1
        if highSVeq.Ep2{iJ}.vars(iK,2) == 0 || isnan(highSVeq.Ep2{iJ}.vars(iK,2))
            highSVeq.Ep2{iJ}.vars(iK,:) = [];
            highSVeq.Ep2{iJ}.psth(iK,:) = [];
        end
    end
end
clear iJ iK iL;
n = length(safe.Ep1);

%% create matrix of mFRs per cell, per offer constitution, per timeXepoch

for iJ = 1:n %for each cell
    for iK = 1:size(safe.Ep1{iJ}.vars,1) %for each trial for that cell
        left.Ep1{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep1{iJ,1}(iK,1:25) = NaN; %create another
        if safe.Ep1{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep1{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep1{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep1{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %do the same
        end
    end
    %repeate the process for Epoch2
    for iK = 1:size(safe.Ep2{iJ}.vars,1)
        left.Ep2{iJ,1}(iK,1:25) = NaN;
        right.Ep2{iJ,1}(iK,1:25) = NaN;
        if safe.Ep2{iJ}.vars(iK,4) == 1
            left.Ep2{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:);
        elseif safe.Ep2{iJ}.vars(iK,4) == 0
            right.Ep2{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:);
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep1{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep1{iJ})';
    temp2left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp2right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
temp1 = cat(1,temp1left,temp1right);
temp2 = cat(1,temp2left,temp2right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
safemat = cat(1,temp1,temp2);
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right safe;

for iJ = 1:n %for each cell
    for iK = 1:size(lowSVeq.Ep1{iJ}.vars,1) %for each trial for that cell
        left.Ep1{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep1{iJ,1}(iK,1:25) = NaN; %create another
        if lowSVeq.Ep1{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep1{iJ,1}(iK,:) = lowSVeq.Ep1{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif lowSVeq.Ep1{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep1{iJ,1}(iK,:) = lowSVeq.Ep1{iJ}.psth(iK,:); %do the same
        end
    end
    %repeate the process for Epoch2
    for iK = 1:size(lowSVeq.Ep2{iJ}.vars,1)
        left.Ep2{iJ,1}(iK,1:25) = NaN;
        right.Ep2{iJ,1}(iK,1:25) = NaN;
        if lowSVeq.Ep2{iJ}.vars(iK,4) == 1
            left.Ep2{iJ,1}(iK,:) = lowSVeq.Ep2{iJ}.psth(iK,:);
        elseif lowSVeq.Ep2{iJ}.vars(iK,4) == 0
            right.Ep2{iJ,1}(iK,:) = lowSVeq.Ep2{iJ}.psth(iK,:);
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep1{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep1{iJ})';
    temp2left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp2right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
temp1 = cat(1,temp1left,temp1right);
temp2 = cat(1,temp2left,temp2right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
lowmat = cat(1,temp1,temp2);
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right lowSVeq;

for iJ = 1:n %for each cell
    for iK = 1:size(highSVeq.Ep1{iJ}.vars,1) %for each trial for that cell
        left.Ep1{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep1{iJ,1}(iK,1:25) = NaN; %create another
        if highSVeq.Ep1{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep1{iJ,1}(iK,:) = highSVeq.Ep1{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif highSVeq.Ep1{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep1{iJ,1}(iK,:) = highSVeq.Ep1{iJ}.psth(iK,:); %do the same
        end
    end
    %repeate the process for Epoch2
    for iK = 1:size(highSVeq.Ep2{iJ}.vars,1)
        left.Ep2{iJ,1}(iK,1:25) = NaN;
        right.Ep2{iJ,1}(iK,1:25) = NaN;
        if highSVeq.Ep2{iJ}.vars(iK,4) == 1
            left.Ep2{iJ,1}(iK,:) = highSVeq.Ep2{iJ}.psth(iK,:);
        elseif highSVeq.Ep2{iJ}.vars(iK,4) == 0
            right.Ep2{iJ,1}(iK,:) = highSVeq.Ep2{iJ}.psth(iK,:);
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep1{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep1{iJ})';
    temp2left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp2right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
temp1 = cat(1,temp1left,temp1right);
temp2 = cat(1,temp2left,temp2right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
highmat = cat(1,temp1,temp2);
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right highSVeq;

%% normalization and gaussian smoothing (sigma = 1)
y = imgaussfilt(safemat,1);
safemat = Z_score(y);
clear y;

y = imgaussfilt(lowmat,1);
lowmat = Z_score(y);
clear y;

y = imgaussfilt(highmat,1);
highmat = Z_score(y);
clear y;

%% PCA and cross-category projections
[R.PCs.safelow,R.VarE.safelow,R.projected1.safelow, R.projected2.safelow] = ...
    project_to_lowD_DM(safemat, lowmat);
[R.PCs.lowsafe,R.VarE.lowsafe,R.projected1.lowsafe, R.projected2.lowsafe] = ...
    project_to_lowD_DM(lowmat, safemat);

[R.PCs.safehigh,R.VarE.safehigh,R.projected1.safehigh, R.projected2.safehigh] = ...
    project_to_lowD_DM(safemat, highmat);
[R.PCs.highsafe,R.VarE.highsafe,R.projected1.highsafe, R.projected2.highsafe] = ...
    project_to_lowD_DM(highmat, safemat);

%% Plot explained variance
figure;
subplot 221;
hold on;
x(:,1) = R.VarE.safelow{1,1}(1:10,:);
x(:,2) = R.VarE.safelow{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe offer', 'eq. low stakes offer');

subplot 222;
hold on;
x(:,1) = R.VarE.lowsafe{1,1}(1:10,:);
x(:,2) = R.VarE.lowsafe{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq. low stakes offer','safe offer');

subplot 223;
hold on;
x(:,1) = R.VarE.safehigh{1,1}(1:10,:);
x(:,2) = R.VarE.safehigh{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe offer', 'eq. high stakes offer');

subplot 224;
hold on;
x(:,1) = R.VarE.highsafe{1,1}(1:10,:);
x(:,2) = R.VarE.highsafe{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq. high stakes offer','safe offer');

%% Collect
R.safemat = safemat;
R.lowmat = lowmat;
R.highmat = highmat;

end