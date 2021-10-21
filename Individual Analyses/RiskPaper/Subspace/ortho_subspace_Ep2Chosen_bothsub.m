function R = ortho_subspace_Ep2Chosen_bothsub(subject1,subject2,range,sv)
%% separate trials by risk-type and calculate mFRs
separated_trials.sub1 = mFR_safeVrisk_SV_chosen(subject1,range);
separated_trials.sub2 = mFR_safeVrisk_SV_chosen(subject2,range);

%% collapse across subs - keeping eq.risky together, and rest together
n1 = length(subject1);
n2 = length(subject2);
safe.Ep2 = cat(1,separated_trials.sub1.safe.Ep2,separated_trials.sub2.safe.Ep2);
n3 = n1+n2;
for iJ = 1:length(separated_trials.sub1.probs)-1
    low.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.low.Ep2{iJ}.cell,separated_trials.sub2.low.Ep2{iJ}.cell);
    high.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.high.Ep2{iJ}.cell,separated_trials.sub2.high.Ep2{iJ}.cell);
end

probs = range:range:1;

% subject1
svlow = interp1(probs,probs,sv.subject1.low,'nearest');
svhigh = interp1(probs,probs,sv.subject1.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(svlow == probs);
eqlow.Ep2 = separated_trials.sub1.low.Ep2{x}.cell;
x = find(svhigh == probs);
eqhigh.Ep2 = separated_trials.sub1.high.Ep2{x}.cell;

% subject2
svlow = interp1(probs,probs,sv.subject2.low,'nearest');
svhigh = interp1(probs,probs,sv.subject2.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(svlow == probs);
eqlow.Ep2 = cat(1,eqlow.Ep2,separated_trials.sub2.low.Ep2{x}.cell);
x = find(svhigh == probs);
eqhigh.Ep2 = cat(1,eqhigh.Ep2,separated_trials.sub2.high.Ep2{x}.cell);

clear iJ x svlow svhigh separated_trials;
separated_trials.safe = safe;
separated_trials.low = low;
separated_trials.high = high;
separated_trials.eqlow = eqlow;
separated_trials.eqhigh = eqhigh;
separated_trials.sv = sv;
separated_trials.n1 = n1;
separated_trials.n2 = n2;
separated_trials.n3 = n3;

clearvars -except separated_trials probs;

safe = separated_trials.safe;
eqlow = separated_trials.eqlow;
eqhigh = separated_trials.eqhigh;

%% create matrix of mFRs per cell, per offer constitution, per timeXepoch
n = length(safe.Ep2);
for iJ = 1:n %for each cell
    for iK = 1:size(safe.Ep2{iJ}.vars,1) %for each trial for that cell
        left.Ep2{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep2{iJ,1}(iK,1:25) = NaN; %create another
        if safe.Ep2{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep2{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif safe.Ep2{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep2{iJ,1}(iK,:) = safe.Ep2{iJ}.psth(iK,:); %do the same
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
safemat = cat(1,temp1left,temp1right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs

clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right safe;

for iJ = 1:n %for each cell
    for iK = 1:size(eqlow.Ep2{iJ}.vars,1) %for each trial for that cell
        left.Ep2{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep2{iJ,1}(iK,1:25) = NaN; %create another
        if eqlow.Ep2{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep2{iJ,1}(iK,:) = eqlow.Ep2{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif eqlow.Ep2{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep2{iJ,1}(iK,:) = eqlow.Ep2{iJ}.psth(iK,:); %do the same
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
lowmat = cat(1,temp1left,temp1right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right eqlow;

for iJ = 1:n %for each cell
    for iK = 1:size(eqhigh.Ep2{iJ}.vars,1) %for each trial for that cell
        left.Ep2{iJ,1}(iK,1:25) = NaN; %create NaN array with trial rows and 50 time bins
        right.Ep2{iJ,1}(iK,1:25) = NaN; %create another
        if eqhigh.Ep2{iJ}.vars(iK,4) == 1 %if the offer position for that trial was on the left
            left.Ep2{iJ,1}(iK,:) = eqhigh.Ep2{iJ}.psth(iK,:); %fill the NaN array with those FRs
        elseif eqhigh.Ep2{iJ}.vars(iK,4) == 0 %if the offer position was on the right
            right.Ep2{iJ,1}(iK,:) = eqhigh.Ep2{iJ}.psth(iK,:); %do the same
        end
    end
    %take the mean FRs across trials, and transpose into a column
    temp1left(:,iJ) = nanmean(left.Ep2{iJ})';
    temp1right(:,iJ) = nanmean(right.Ep2{iJ})';
end

%concatenate the matrices on the first dimension, keeping epochs
%together, sequentially (Ep1left with Ep1right, etc.)
highmat = cat(1,temp1left,temp1right);

%concatenate the left/right matrices along the first dimension to generate
%a matrix of ROW-condition(epoch X time X position) X COLUMN-cell matrix of
%mean FRs
clear temp1 temp2 temp1left temp1right temp2left temp2right iJ iK left right eqhigh;

%% normalization and gaussian smoothing (sigma = 1)
y = imgaussfilt(safemat,1);
for iJ = 1:size(y,2)
safemat(:,iJ) = Z_score(y(:,iJ));
end
clear y;

y = imgaussfilt(lowmat,1);
for iJ = 1:size(y,2)
lowmat(:,iJ) = Z_score(y(:,iJ));
end
clear y;

y = imgaussfilt(highmat,1);
for iJ = 1:size(y,2)
highmat(:,iJ) = Z_score(y(:,iJ));
end
clear y;

%% clean NaNs after gauss filt (?)
for iJ = size(safemat,2):-1:1
    if isnan(safemat(1,iJ)) || isnan(safemat(end,iJ))
        safemat(:,iJ) = [];
        lowmat(:,iJ) = [];
        highmat(:,iJ) = [];
    end
end
for iJ = size(lowmat,2):-1:1
    if isnan(lowmat(1,iJ)) || isnan(lowmat(end,iJ))
        safemat(:,iJ) = [];
        lowmat(:,iJ) = [];
        highmat(:,iJ) = [];
    end
end
for iJ = size(highmat,2):-1:1
    if isnan(highmat(1,iJ)) || isnan(highmat(end,iJ))
        safemat(:,iJ) = [];
        lowmat(:,iJ) = [];
        highmat(:,iJ) = [];
    end
end
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
clear x;
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
clear x;

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