function R = ortho_subspace_EvenOdd(in,sv)
%% define variables
probs = 0:0.05:1; probs(7) = 0.3;
svlow = interp1(probs,probs,sv.low,'nearest');
svhigh = interp1(probs,probs,sv.high,'nearest');

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
            safe.Ep1{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
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
                    low.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
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
                    high.Ep1{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,150:199);
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
            safe.Ep2{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:249);
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
                    low.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:249);
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
                    high.Ep2{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,200:249);
                end
            end
        end
    end
end

x = find(probs == svlow);
lowSVeq.Ep1 = low.Ep1{x}.cell;
lowSVeq.Ep2 = low.Ep2{x}.cell;
x = find(probs == svhigh);
highSVeq.Ep1 = high.Ep1{x}.cell;
highSVeq.Ep2 = high.Ep2{x}.cell;
clear low high probs x sv;

for iJ = 1:length(safe.Ep1)
    for iK = length(safe.Ep1{iJ}.vars):-1:1
        if safe.Ep1{iJ}.vars(iK,2) == 0 || isnan(safe.Ep1{iJ}.vars(iK,2))
            safe.Ep1{iJ}.vars(iK,:) = [];
            safe.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(safe.Ep2{iJ}.vars):-1:1
        if safe.Ep2{iJ}.vars(iK,2) == 0 || isnan(safe.Ep2{iJ}.vars(iK,2))
            safe.Ep2{iJ}.vars(iK,:) = [];
            safe.Ep2{iJ}.psth(iK,:) = [];
        end
    end
end
for iJ = 1:length(lowSVeq.Ep1)
    for iK = length(lowSVeq.Ep1{iJ}.vars):-1:1
        if lowSVeq.Ep1{iJ}.vars(iK,2) == 0 || isnan(lowSVeq.Ep1{iJ}.vars(iK,2))
            lowSVeq.Ep1{iJ}.vars(iK,:) = [];
            lowSVeq.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(lowSVeq.Ep2{iJ}.vars):-1:1
        if lowSVeq.Ep2{iJ}.vars(iK,2) == 0 || isnan(lowSVeq.Ep2{iJ}.vars(iK,2))
            lowSVeq.Ep2{iJ}.vars(iK,:) = [];
            lowSVeq.Ep2{iJ}.psth(iK,:) = [];
        end
    end
end
for iJ = 1:length(highSVeq.Ep1)
    for iK = length(highSVeq.Ep1{iJ}.vars):-1:1
        if highSVeq.Ep1{iJ}.vars(iK,2) == 0 || isnan(highSVeq.Ep1{iJ}.vars(iK,2))
            highSVeq.Ep1{iJ}.vars(iK,:) = [];
            highSVeq.Ep1{iJ}.psth(iK,:) = [];
        end
    end
    for iK = length(highSVeq.Ep2{iJ}.vars):-1:1
        if highSVeq.Ep2{iJ}.vars(iK,2) == 0 || isnan(highSVeq.Ep2{iJ}.vars(iK,2))
            highSVeq.Ep2{iJ}.vars(iK,:) = [];
            highSVeq.Ep2{iJ}.psth(iK,:) = [];
        end
    end
end

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

clear iJ iK iL;
n = length(safe.Ep1);

%% create matrix of mFRs per cell, per offer constitution, per timeXepoch

for iJ = 1:n %for each cell
    for iK = 1:size(safe.Ep1{iJ}.vars,1) %for each trial for that cell
        left.Ep1.odd{iJ,1}(iK,1:50) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep1.odd{iJ,1}(iK,1:50) = NaN; %create another
        left.Ep1.even{iJ,1}(iK,1:50) = NaN; 
        right.Ep1.even{iJ,1}(iK,1:50) = NaN;
        if safe.Ep1{iJ}.vars(iK,4) == 1 && rem(iK,2) == 1%if the offer position for that trial was on the left
            left.Ep1.odd{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep1{iJ}.vars(iK,4) == 0 && rem(iK,2) == 1%if the offer position was on the right
            right.Ep1.odd{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %do the same
        elseif safe.Ep1{iJ}.vars(iK,4) == 1 && rem(iK,2) == 0%if the offer position for that trial was on the left
            left.Ep1.even{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep1{iJ}.vars(iK,4) == 0 && rem(iK,2) == 0%if the offer position was on the right
            right.Ep1.even{iJ,1}(iK,:) = safe.Ep1{iJ}.psth(iK,:); %do the same
        end
    end
    %repeate the process for Epoch2
    for iK = 1:size(safe.Ep2{iJ}.vars,1) %for each trial for that cell
        left.Ep2.odd{iJ,1}(iK,1:50) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep2.odd{iJ,1}(iK,1:50) = NaN; %create another
        left.Ep2.even{iJ,1}(iK,1:50) = NaN; 
        right.Ep2.even{iJ,1}(iK,1:50) = NaN;
        if safe.Ep2{iJ}.vars(iK,4) == 1 && rem(iK,2) == 1%if the offer position for that trial was on the left
            left.Ep2.odd{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep2{iJ}.vars(iK,4) == 0 && rem(iK,2) == 1%if the offer position was on the right
            right.Ep2.odd{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %do the same
        elseif safe.Ep2{iJ}.vars(iK,4) == 1 && rem(iK,2) == 0%if the offer position for that trial was on the left
            left.Ep2.even{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep2{iJ}.vars(iK,4) == 0 && rem(iK,2) == 0%if the offer position was on the right
            right.Ep2.even{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %do the same
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1leftodd(:,iJ) = nanmean(left.Ep1.odd{iJ})';
    temp1lefteven(:,iJ) = nanmean(left.Ep1.even{iJ})';
    temp1rightodd(:,iJ) = nanmean(right.Ep1.odd{iJ})';
    temp1righteven(:,iJ) = nanmean(right.Ep1.even{iJ})';
    
    temp2leftodd(:,iJ) = nanmean(left.Ep2.odd{iJ})';
    temp2lefteven(:,iJ) = nanmean(left.Ep2.even{iJ})';
    temp2rightodd(:,iJ) = nanmean(right.Ep2.odd{iJ})';
    temp2righteven(:,iJ) = nanmean(right.Ep2.even{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
temp1odd = cat(1,temp1leftodd,temp1rightodd);
temp2odd = cat(1,temp2leftodd,temp2rightodd);
temp1even = cat(1,temp1lefteven,temp1righteven);
temp2even = cat(1,temp2lefteven,temp2righteven);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
safematodd = cat(1,temp1odd,temp2odd);
safemateven = cat(1,temp1even,temp2even);
clear temp1odd temp1even temp2odd temp2even temp1lefteven temp1leftodd temp2lefteven temp2leftodd temp1righteven temp1rightodd temp2righteven temp2rightodd iJ iK left right safe;

%% normalization and gaussian smoothing (sigma = 1)
y = imgaussfilt(safemateven,1);
safemateven = Z_score(y);
clear y;

y = imgaussfilt(safematodd,1);
safematodd = Z_score(y);
clear y;

%% clean NaNs after gauss filt (?)
for iJ = size(safemateven,2):-1:1
    if isnan(safemateven(1,iJ)) || isnan(safemateven(end,iJ))
        safemateven(:,iJ) = [];
        safematodd(:,iJ) = [];
    end
end
for iJ = size(safematodd,2):-1:1
    if isnan(safematodd(1,iJ)) || isnan(safematodd(end,iJ))
        safemateven(:,iJ) = [];
        safematodd(:,iJ) = [];
    end
end

%% PCA and cross-category projections
[R.PCs.oddeven,R.VarE.oddeven,R.projected1.oddeven, R.projected2.oddeven] = ...
    project_to_lowD_DM(safematodd, safemateven);
[R.PCs.evenodd,R.VarE.evenodd,R.projected1.evenodd, R.projected2.evenodd] = ...
    project_to_lowD_DM(safemateven, safematodd);

%% Plot explained variance
figure;
subplot 121;
hold on;
x(:,1) = R.VarE.oddeven{1,1}(1:10,:);
x(:,2) = R.VarE.oddeven{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe offer', 'eq. low stakes offer');

subplot 122;
hold on;
x(:,1) = R.VarE.evenodd{1,1}(1:10,:);
x(:,2) = R.VarE.evenodd{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq. low stakes offer','safe offer');

%% Collect
R.safemateven = safemateven;
R.safematodd = safematodd;

end