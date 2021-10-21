%% Figure 2
%2a: Risky Choice rates against EV for medium and large rewards
% [R.Figure2.BinsSM, R.Figure2.BinsML, R. Figure2.BinsSL] = Risk_v_Reward_nosafe(cleanOFC24);
[R.Figure2.BinsMed, R. Figure2.BinsLar] = Risk_v_Reward(data);

%2b: Logistic regression of binary choice behavior on 7 predictors
[R.Figure2.b, R.Figure2.dev, R.Figure2.stats] = LogRegress_Choice(cleanOFC24);
R.Figure2.x = [1:8];
R.Figure2.name = {'Intercept';'Rwd1';'Prob1';'Rwd2';'Prob2';'Prev.C';'Prev.O';'Pos'};

%Plot
figure;

subplot(1,2,1);
hold on;
xlabel('Difference in EV (EV Larger - EV Smaller')
ylabel('Rate for Choosing the Larger Reward')
% plot(R.Figure2.BinsSM(:,1),R.Figure2.BinsSM(:,3));
% plot(R.Figure2.BinsML(:,1),R.Figure2.BinsML(:,3));
% plot(R.Figure2.BinsSL(:,1),R.Figure2.BinsSL(:,3));
plot(R.Figure2.BinsMed(:,1),R.Figure2.BinsMed(:,3));
plot(R.Figure2.BinsLar(:,1),R.Figure2.BinsLar(:,3));
% legend('Small vs. Medium','Medium vs. Large','Small vs. Large');
legend('Medium','Large');

hold on;
subplot(1,2,2);
bar(R.Figure2.x(2:8), R.Figure2.b(2:end));
set(gca,'xticklabel',R.Figure2.name(2:8));
xlabel('Predictor'); ylabel('Regression Coefficient');

%% Figure 3

% 3A Regress trial FRs on reward probability and reward size during Epoch 1

% Pull FRs for given epoch
R.Figure3.O1_FR = EpochIsolation(cleanOFC24, 250, 20);

% average FR over time by collapsing across the bins
for iL = 1:length(R.Figure3.O1_FR)
    R.Figure3.O1_mFR{iL} = (mean(R.Figure3.O1_FR{iL},2))*100;
end
R.Figure3.O1_mFR = R.Figure3.O1_mFR';

% extract the critical predictors
R.Figure3.predictors = Predictors_RwdProb(cleanOFC24,1); R.Figure3.predictors = R.Figure3.predictors';

% separate predictors into independent matrices
for iL = 1:length(R.Figure3.predictors)
    R.Figure3.probs{iL} = R.Figure3.predictors{iL}(:,1);
    R.Figure3.reward{iL} = R.Figure3.predictors{iL}(:,2);
end
R.Figure3.probs = R.Figure3.probs';
R.Figure3.reward = R.Figure3.reward';

% Regression time!!
for iL = 1:length(R.Figure3.O1_mFR)
    [R.Figure3.out.probs.b{iL},R.Figure3.out.probs.dev{iL},R.Figure3.out.probs.stats{iL}] = glmfit(R.Figure3.probs{iL},R.Figure3.O1_mFR{iL});
    [R.Figure3.out.reward.b{iL},R.Figure3.out.reward.dev{iL},R.Figure3.out.reward.stats{iL}] = glmfit(R.Figure3.reward{iL},R.Figure3.O1_mFR{iL});
end
R.Figure3.out.reward.b = R.Figure3.out.reward.b';
R.Figure3.out.probs.b = R.Figure3.out.probs.b';
R.Figure3.out.reward.dev = R.Figure3.out.reward.dev';
R.Figure3.out.probs.dev = R.Figure3.out.probs.dev';
R.Figure3.out.reward.stats = R.Figure3.out.reward.stats';
R.Figure3.out.probs.stats = R.Figure3.out.probs.stats';

% Extract Beta weights for FR on probs and FR on reward for each cell
for iL = 1:length(R.Figure3.out.reward.b)
    R.Figure3.out.reward.betas(iL,1) = R.Figure3.out.reward.b{iL}(2,1);
    R.Figure3.out.probs.betas(iL,1) = R.Figure3.out.probs.b{iL}(2,1);
end

figure;
subplot(2,2,1);
hold on
scatter(R.Figure3.out.reward.betas, R.Figure3.out.probs.betas);
xlabel('Regression Coefficient, Probability');
ylabel('Regression Coefficient, Reward');

%% 3B/C sample cell, FR over time across all 3 epochs
t=35;%37
% isolate 6 seconds (1s prior to Offer1 start, 5s after Offer 1 start)
    % Offer 1 starts at bin 300 
    % 10ms bins = 100 bins in 1s
    % range is from bin 200 - bin 800 (6k ms = 6 seconds)

% Group FR from above range by trials with High, Med, and Low offers
    % Offer1 rwd size is column2
[R.Figure3.sample.Offer1.low,R.Figure3.sample.Offer1.med,R.Figure3.sample.Offer1.high] = FR_OfferGrouping(cleanOFC24,t,2,1,10);

    % Offer2 rwd size is column5
[R.Figure3.sample.Offer2.low,R.Figure3.sample.Offer2.med,R.Figure3.sample.Offer2.high] = FR_OfferGrouping(cleanOFC24,t,5,1,10);


% FR (spikes/sec) for each reward value over time
    % get rid of NaN values
R.Figure3.sample.Offer1.iso.low = TrialSpikeIsolation(R.Figure3.sample.Offer1.low);
R.Figure3.sample.Offer1.iso.med = TrialSpikeIsolation(R.Figure3.sample.Offer1.med);
R.Figure3.sample.Offer1.iso.high = TrialSpikeIsolation(R.Figure3.sample.Offer1.high);
R.Figure3.sample.Offer2.iso.low = TrialSpikeIsolation(R.Figure3.sample.Offer2.low);
R.Figure3.sample.Offer2.iso.med = TrialSpikeIsolation(R.Figure3.sample.Offer2.med);
R.Figure3.sample.Offer2.iso.high = TrialSpikeIsolation(R.Figure3.sample.Offer2.high);

    % collapse 10ms bins into 100ms bins
R.Figure3.sample.Offer1.iso.collapse.low = mean(FR_CollapseBins(R.Figure3.sample.Offer1.iso.low,10),1)*100;
R.Figure3.sample.Offer1.iso.collapse.med = mean(FR_CollapseBins(R.Figure3.sample.Offer1.iso.med,10),1)*100;
R.Figure3.sample.Offer1.iso.collapse.high = mean(FR_CollapseBins(R.Figure3.sample.Offer1.iso.high,10),1)*100;
R.Figure3.sample.Offer2.iso.collapse.low = mean(FR_CollapseBins(R.Figure3.sample.Offer2.iso.low,10),1)*100;
R.Figure3.sample.Offer2.iso.collapse.med = mean(FR_CollapseBins(R.Figure3.sample.Offer2.iso.med,10),1)*100;
R.Figure3.sample.Offer2.iso.collapse.high = mean(FR_CollapseBins(R.Figure3.sample.Offer2.iso.high,10),1)*100;

subplot(2,2,2);
hold on
plot(R.Figure3.sample.Offer1.iso.collapse.low, 'r')
plot(R.Figure3.sample.Offer1.iso.collapse.med, 'g')
plot(R.Figure3.sample.Offer1.iso.collapse.high, 'b')
legend('Small Offer Value', 'Medium Offer Value', 'Large Offer Value');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('Firing Rate (spks/second)');

subplot(2,2,3);
hold on
plot(R.Figure3.sample.Offer2.iso.collapse.low, 'r')
plot(R.Figure3.sample.Offer2.iso.collapse.med, 'g')
plot(R.Figure3.sample.Offer2.iso.collapse.high, 'b')
legend('Small Offer Value', 'Medium Offer Value', 'Large Offer Value');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('Firing Rate (spks/second)');

%% 3D Rate of neurons modulated by offer over Trial Time
% Within each time bin, correlate FR with EV for each offer
    % For each cell, identify EV for each trial (EV1: column 3; EV2:
    % column 6
R.Figure3.out.EVs = PullEV(cleanOFC24);

    % For each cell, pull out FR for given epochs (6 seconds)
for iL = 1:length(cleanOFC24)
    R.Figure3.FR{iL} = cleanOFC24{iL}.psth(:,200:499);
end
R.Figure3.FR = R.Figure3.FR';

    % collapse the FR into given bin (100ms?) for every trial
for iL = 1:length(cleanOFC24)
    R.Figure3.out.FRcol{iL} = FR_CollapseBins(R.Figure3.FR{iL},20);
end
R.Figure3.out.FRcol = R.Figure3.out.FRcol';

% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(R.Figure3.out.FRcol) %for the number of cells
    for iK = 1:size(R.Figure3.out.FRcol{iL},2)
        [R.Figure3.out.cor.EV1.r(iL,iK),R.Figure3.out.cor.EV1.p(iL,iK)] = corr(R.Figure3.out.FRcol{iL}(:,iK),R.Figure3.out.EVs{iL}(:,1)); %EV1
        [R.Figure3.out.cor.EV2.r(iL,iK),R.Figure3.out.cor.EV2.p(iL,iK)] = corr(R.Figure3.out.FRcol{iL}(:,iK),R.Figure3.out.EVs{iL}(:,2)); %EV2
    end
end

% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(R.Figure3.out.cor.EV1.p,2)
    R.Figure3.out.cor.EV1.rate(1,iL) = (sum(R.Figure3.out.cor.EV1.p(:,iL)<.05)/length(R.Figure3.out.cor.EV1.p))*100; %EV1
    R.Figure3.out.cor.EV2.rate(1,iL) = (sum(R.Figure3.out.cor.EV2.p(:,iL)<.05)/length(R.Figure3.out.cor.EV2.p))*100; %EV2
end

% Plot rate over trial time
subplot(2,2,4);
hold on
plot(R.Figure3.out.cor.EV1.rate, 'b') %EV1
plot(R.Figure3.out.cor.EV2.rate, 'r') %EV2
legend('Offer 1 Value', 'Offer 2 Value');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('% neurons modulated');

%% Figure 4

% 4A sample cell, FR over time across all 3 epochs
% isolate 6 seconds (1s prior to Offer1 start, 5s after Offer 1 start)
    % Offer 1 starts at bin 250 
    % 20ms bins = 50 bins in 1s
    % range is from bin 200 - bin 500 (6k ms = 6 seconds)

% Group FR from above range by trials with EV1>EV2, EV1=EV2, and EV1<EV2
    % EV1 is column 3; EV2 is column 6
[R.Figure4.sample.EV1highest,R.Figure4.sample.EVequal,R.Figure4.sample.EV1lowest] = FR_EVGrouping(cleanOFC24,t,20);

% FR (spikes/sec) for each reward value over time
    % get rid of NaN values
R.Figure4.sample.iso.EV1highest = TrialSpikeIsolation(R.Figure4.sample.EV1highest);
R.Figure4.sample.iso.EVequal = TrialSpikeIsolation(R.Figure4.sample.EVequal);
R.Figure4.sample.iso.EV1lowest = TrialSpikeIsolation(R.Figure4.sample.EV1lowest);

    % collapse 20ms bins into 100ms bins
R.Figure4.sample.iso.collapse.EV1high = mean(FR_CollapseBins(R.Figure4.sample.iso.EV1highest,10),1)*100;
R.Figure4.sample.iso.collapse.EVequal = mean(FR_CollapseBins(R.Figure4.sample.iso.EVequal,10),1)*100;
R.Figure4.sample.iso.collapse.EV1low = mean(FR_CollapseBins(R.Figure4.sample.iso.EV1lowest,10),1)*100;

% 4B FR regressed on Offer Value 1 and on Offer Value 2 both in epoch 2
% Pull FRs for given epoch
R.Figure4.Epoch2.FR = EpochIsolation(cleanOFC24,300,20);

% average FR over time by collapsing across the 25 bins
for iL = 1:length(R.Figure4.Epoch2.FR)
    R.Figure4.Epoch2.mFR{iL} = mean(R.Figure4.Epoch2.FR{iL},2)*100;
end
R.Figure4.Epoch2.mFR = R.Figure4.Epoch2.mFR';

% extract the critical predictors
R.Figure4.predictors = Predictors_OfferValue(cleanOFC24); R.Figure4.predictors = R.Figure4.predictors';

% separate predictors into independent matrices
for iL = 1:length(R.Figure4.predictors)
    R.Figure4.OfferVal1{iL} = R.Figure4.predictors{iL}(:,1);
    R.Figure4.OfferVal2{iL} = R.Figure4.predictors{iL}(:,2);
end
R.Figure4.OfferVal1 = R.Figure4.OfferVal1';
R.Figure4.OfferVal2 = R.Figure4.OfferVal2';

% Regression time!!
for iL = 1:length(R.Figure4.Epoch2.mFR)
    [R.Figure4.Epoch2.out.Offer1.b{iL},R.Figure4.Epoch2.out.Offer1.dev{iL},R.Figure4.Epoch2.out.Offer1.stats{iL}] = glmfit(R.Figure4.OfferVal1{iL},R.Figure4.Epoch2.mFR{iL});
    [R.Figure4.Epoch2.out.Offer2.b{iL},R.Figure4.Epoch2.out.Offer2.dev{iL},R.Figure4.Epoch2.out.Offer2.stats{iL}] = glmfit(R.Figure4.OfferVal2{iL},R.Figure4.Epoch2.mFR{iL});
end
R.Figure4.Epoch2.out.Offer1.b = R.Figure4.Epoch2.out.Offer1.b';
R.Figure4.Epoch2.out.Offer2.b = R.Figure4.Epoch2.out.Offer2.b';
R.Figure4.Epoch2.out.Offer1.dev = R.Figure4.Epoch2.out.Offer1.dev';
R.Figure4.Epoch2.out.Offer2.dev = R.Figure4.Epoch2.out.Offer2.dev';
R.Figure4.Epoch2.out.Offer1.stats = R.Figure4.Epoch2.out.Offer1.stats';
R.Figure4.Epoch2.out.Offer2.stats = R.Figure4.Epoch2.out.Offer2.stats';

% Extract Beta weights for FR on probs and FR on reward for each cell
for iL = 1:length(R.Figure4.Epoch2.out.Offer1.b)
    R.Figure4.Epoch2.out.Offer1.betas(iL,1) = R.Figure4.Epoch2.out.Offer1.b{iL}(2,1);
    R.Figure4.Epoch2.out.Offer2.betas(iL,1) = R.Figure4.Epoch2.out.Offer2.b{iL}(2,1);
end

% 4C FR regressed on Offer Value 1 in epoch 1 and Offer Value 2 in epoch 2
% Pull FRs for given epoch
R.Figure4.Epoch1.FR = EpochIsolation(cleanOFC24,250,20);

% average FR over time by collapsing across the 25 bins
for iL = 1:length(R.Figure4.Epoch1.FR)
    R.Figure4.Epoch1.mFR{iL} = mean(R.Figure4.Epoch1.FR{iL},2)*100;
end
R.Figure4.Epoch1.mFR = R.Figure4.Epoch1.mFR';

% Regression time!!
for iL = 1:length(R.Figure4.Epoch1.mFR)
    [R.Figure4.Epoch1.out.Offer1.b{iL},R.Figure4.Epoch1.out.Offer1.dev{iL},R.Figure4.Epoch1.out.Offer1.stats{iL}] = glmfit(R.Figure4.OfferVal1{iL},R.Figure4.Epoch1.mFR{iL});
end
R.Figure4.Epoch1.out.Offer1.b = R.Figure4.Epoch1.out.Offer1.b';
R.Figure4.Epoch1.out.Offer1.dev = R.Figure4.Epoch1.out.Offer1.dev';
R.Figure4.Epoch1.out.Offer1.stats = R.Figure4.Epoch1.out.Offer1.stats';

% Extract Beta weights for FR on probs and FR on reward for each cell
for iL = 1:length(R.Figure4.Epoch1.out.Offer1.b)
    R.Figure4.Epoch1.out.Offer1.betas(iL,1) = R.Figure4.Epoch1.out.Offer1.b{iL}(2,1);
end

% 4D
% Rate of neurons modulated by offer over Trial Time
% Within each time bin, correlate FR with EV for each offer
    % EVs from 4B/C
    % Re-group by chosen and unchosen offer (column 9; chose 1st or 2nd)
for iL = 1:length(R.Figure4.OfferVal1)
    for iK = 1:length(R.Figure4.OfferVal1{iL})
        if cleanOFC24{iL}.vars(iK,9) == 1
            R.Figure4.ChosenEV{iL}(iK,1) = R.Figure4.OfferVal1{iL}(iK,1);
            R.Figure4.UnchosenEV{iL}(iK,1) = R.Figure4.OfferVal2{iL}(iK,1);
        elseif cleanOFC24{iL}.vars(iK,9) ~= 1
            R.Figure4.ChosenEV{iL}(iK,1) = R.Figure4.OfferVal2{iL}(iK,1);
            R.Figure4.UnchosenEV{iL}(iK,1) = R.Figure4.OfferVal1{iL}(iK,1);
        end
    end
end
R.Figure4.ChosenEV = R.Figure4.ChosenEV';
R.Figure4.UnchosenEV = R.Figure4.UnchosenEV';
    
    % For each cell, pull out FR for given epochs (6 seconds)
R.Figure4.FR = R.Figure3.FR;

    % collapse the FR into given bin (200ms?) for every trial
R.Figure4.FRcol = R.Figure3.out.FRcol;

    % For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(R.Figure4.FRcol) %for the number of cells
    for iK = 1:size(R.Figure4.FRcol{iL},2)
        [R.Figure4.cor.chosen.r(iL,iK),R.Figure4.cor.chosen.p(iL,iK)] = corr(R.Figure4.FRcol{iL}(:,iK),R.Figure4.ChosenEV{iL}(:,1)); %Chosen EV
        [R.Figure4.cor.unchosen.r(iL,iK),R.Figure4.cor.unchosen.p(iL,iK)] = corr(R.Figure4.FRcol{iL}(:,iK),R.Figure4.UnchosenEV{iL}(:,1)); %Unchosen EV
    end
end

% For each time bin (column), calculate the % of p-values that are < .05

for iL = 1:size(R.Figure3.out.cor.EV1.p,2)
    R.Figure4.cor.chosen.rate(1,iL) = (sum(R.Figure4.cor.chosen.p(:,iL)<.05)/length(R.Figure4.cor.chosen.p))*100; %Chosen EV
    R.Figure4.cor.unchosen.rate(1,iL) = (sum(R.Figure4.cor.unchosen.p(:,iL)<.05)/length(R.Figure4.cor.unchosen.p))*100; %Unchosen EV
end

% Plot
figure;
subplot(2,2,1);
hold on
plot(R.Figure4.sample.iso.collapse.EV1high, 'b')
plot(R.Figure4.sample.iso.collapse.EVequal, 'k')
plot(R.Figure4.sample.iso.collapse.EV1low, 'r')
legend('EV1>EV2', 'EV1=EV2','EV1<EV2');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('Firing Rate (spks/second)');

subplot(2,2,2);
hold on
scatter(R.Figure4.Epoch2.out.Offer1.betas, R.Figure4.Epoch2.out.Offer2.betas);
xlabel('Regression Coefficient, Offer 1');
ylabel('Regression Coefficient, Offer 2');

subplot(2,2,3);
hold on
scatter(R.Figure4.Epoch1.out.Offer1.betas, R.Figure4.Epoch2.out.Offer2.betas);
xlabel('Regression Coefficient, Offer 1');
ylabel('Regression Coefficient, Offer 2');

subplot(2,2,4);
hold on
plot(R.Figure4.cor.chosen.rate, 'b') %EV1
plot(R.Figure4.cor.unchosen.rate, 'r') %EV2
legend('Chosen Value', 'Unchosen Value');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('% neurons modulated');

%% Figure 5 - Outcome coding
% 5A sample neuron avg FR for trials with Win, Loss, and Safe
[R.Figure5.sample.Safe,R.Figure5.sample.Win,R.Figure5.sample.Loss] = FR_OutcomeGrouping(cleanOFC24,t,20);

% FR (spikes/sec) for each reward value over time
    % get rid of NaN values
R.Figure5.sample.iso.Safe = TrialSpikeIsolation(R.Figure5.sample.Safe);
R.Figure5.sample.iso.Win = TrialSpikeIsolation(R.Figure5.sample.Win);
R.Figure5.sample.iso.Loss = TrialSpikeIsolation(R.Figure5.sample.Loss);

    % collapse 20ms bins into 100ms bins
R.Figure5.sample.iso.collapse.Safe = mean(FR_CollapseBins(R.Figure5.sample.iso.Safe,10),1)*100;
R.Figure5.sample.iso.collapse.Win = mean(FR_CollapseBins(R.Figure5.sample.iso.Win,10),1)*100;
R.Figure5.sample.iso.collapse.Loss = mean(FR_CollapseBins(R.Figure5.sample.iso.Loss,10),1)*100;

% 5B - % correlated with Outcome
% Rate of neurons modulated by Outcome over Trial Time
% Within each time bin, correlate FR with Trial Outcome
    % Group by Outcome (column 10; 1, 2/3, or 0)
for iL = 1:length(cleanOFC24)
    for iK = 1:length(cleanOFC24{iL}.vars)
        R.Figure5.Outcome{iL}(iK,1) = cleanOFC24{iL}.vars(iK,10);
    end
end
R.Figure5.Outcome = R.Figure5.Outcome';
    
    % For each cell, pull out FR for given epochs (6 seconds)
R.Figure5.FR = R.Figure3.FR;

    % collapse the FR into given bin (200ms?) for every trial
R.Figure5.FRcol = R.Figure3.out.FRcol;

    % For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(R.Figure5.FRcol) %for the number of cells
    for iK = 1:size(R.Figure5.FRcol{iL},2)
        [R.Figure5.cor.outcome.r(iL,iK),R.Figure5.cor.outcome.p(iL,iK)] = corr(R.Figure5.FRcol{iL}(:,iK),R.Figure5.Outcome{iL}(:,1));
    end
end

% For each time bin (column), calculate the % of p-values that are < .05

for iL = 1:size(R.Figure5.cor.outcome.p,2)
    R.Figure5.cor.outcome.rate(1,iL) = (sum(R.Figure5.cor.outcome.p(:,iL)<.05)/length(R.Figure5.cor.outcome.p))*100; %Chosen EV
end

% 5C - % correlated with Outcome on previous trial
    % Group by Outcome (column 10; 1, 2/3, or 0)
for iL = 1:length(cleanOFC24)
    for iK = 1:length(cleanOFC24{iL}.vars)
        if iK == 1
            R.Figure5.POutcome{iL}(iK,1) = 0;
        elseif iK > 1
            R.Figure5.POutcome{iL}(iK,1) = cleanOFC24{iL}.vars(iK-1,10);
        end
    end
end
R.Figure5.POutcome = R.Figure5.POutcome';

    % For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(R.Figure5.FRcol) %for the number of cells
    for iK = 1:size(R.Figure5.FRcol{iL},2)
        [R.Figure5.cor.poutcome.r(iL,iK),R.Figure5.cor.poutcome.p(iL,iK)] = corr(R.Figure5.FRcol{iL}(:,iK),R.Figure5.POutcome{iL});
    end
end

% For each time bin (column), calculate the % of p-values that are < .05

for iL = 1:size(R.Figure5.cor.poutcome.p,2)
    R.Figure5.cor.poutcome.rate(1,iL) = (sum(R.Figure5.cor.poutcome.p(:,iL)<.05)/length(R.Figure5.cor.poutcome.p))*100; %Chosen EV
end

% Plot
figure;
subplot(2,2,1);
hold on
plot(R.Figure5.sample.iso.collapse.Safe, 'k')
plot(R.Figure5.sample.iso.collapse.Win, 'b')
plot(R.Figure5.sample.iso.collapse.Loss, 'r')
legend('Safe', 'Win','Loss');
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('Firing Rate (spks/second)');

subplot(2,2,3);
hold on
plot(R.Figure5.cor.outcome.rate, 'b') %Outcome
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('% neurons modulated');

subplot(2,2,4);
hold on
plot(R.Figure5.cor.poutcome.rate, 'b') %Previous Outcome
xlabel('Time in 100ms - 1s pre-Offer1 to 5s Post');
ylabel('% neurons modulated');

%% Additional Maths
%Integration
[R.Figure3.Integ.cor.r,R.Figure3.Integ.cor.p] = corr(R.Figure3.out.probs.betas,R.Figure3.out.reward.betas);

%Inhibition
[R.Figure4.Inhib.cor.r,R.Figure4.Inhib.cor.p] = corr(R.Figure4.Epoch2.out.Offer1.betas,R.Figure4.Epoch2.out.Offer2.betas);

%Alignment
[R.Figure4.Align.cor.r,R.Figure4.Align.cor.p] = corr(R.Figure4.Epoch2.out.Offer2.betas,R.Figure4.Epoch1.out.Offer1.betas);

%WM
[R.Add.WM.cor.r,R.Add.WM.cor.p] = corr(R.Figure4.Epoch1.out.Offer1.betas,R.Figure4.Epoch2.out.Offer1.betas);

%Avg. Beta
R.AvgBeta.EV1Ep1 = mean(R.Figure4.Epoch1.out.Offer1.betas);
R.AvgBeta.EV1Ep2 = mean(R.Figure4.Epoch2.out.Offer1.betas);
R.AvgBeta.EV2Ep2 = mean(R.Figure4.Epoch2.out.Offer2.betas);

%% More Coding
data = cleanOFC24;

% Epoch 1 Spiking on Offer1 side
R.Add.Pos1.predictors = Predictors_Position(data,1);
R.Add.Pos1.predictors = R.Add.Pos1.predictors';

for iL = 1:length(R.Figure3.O1_mFR)
    [R.Add.Pos1.b{iL},R.Add.Pos1.dev{iL},R.Add.Pos1.stats{iL}] = glmfit(R.Add.Pos1.predictors{iL},R.Figure3.O1_mFR{iL});
end
R.Add.Pos1.b = R.Add.Pos1.b';
R.Add.Pos1.dev = R.Add.Pos1.dev';
R.Add.Pos1.stats = R.Add.Pos1.stats';

% Extract Beta weights for FR on probs and FR on reward for each cell
for iL = 1:length(R.Add.Pos1.b)
    R.Add.Pos1.betas(iL,1) = R.Add.Pos1.b{iL}(2,1);
end
R.AvgBeta.Pos1 = mean(R.Add.Pos1.betas);


% Epoch 2 Spiking on Offer2 side
R.Add.Pos2.predictors = Predictors_Position(data,2);
R.Add.Pos2.predictors = R.Add.Pos2.predictors';

for iL = 1:length(R.Figure4.Epoch2.mFR)
    [R.Add.Pos2.b{iL},R.Add.Pos2.dev{iL},R.Add.Pos2.stats{iL}] = glmfit(R.Add.Pos2.predictors{iL},R.Figure4.Epoch2.mFR{iL});
end
R.Add.Pos2.b = R.Add.Pos2.b';
R.Add.Pos2.dev = R.Add.Pos2.dev';
R.Add.Pos2.stats = R.Add.Pos2.stats';

for iL = 1:length(R.Add.Pos2.b)
    R.Add.Pos2.betas(iL,1) = R.Add.Pos2.b{iL}(2,1);
end
R.AvgBeta.Pos2 = mean(R.Add.Pos2.betas);


% Epoch 3 Spiking on Chosen side
R.Add.Pos3.predictors = Predictors_Position(data,3);
R.Add.Pos3.predictors = R.Add.Pos3.predictors';

%spikes
R.Add.Epoch3.FR = EpochIsolation(data,400,20);

% average FR over time by collapsing across the 25 bins
for iL = 1:length(R.Add.Epoch3.FR)
    R.Add.Epoch3.mFR{iL} = mean(R.Add.Epoch3.FR{iL},2)*100;
end
R.Add.Epoch3.mFR = R.Add.Epoch3.mFR';

for iL = 1:length(R.Add.Epoch3.mFR)
    [R.Add.Pos3.b{iL},R.Add.Pos3.dev{iL},R.Add.Pos3.stats{iL}] = glmfit(R.Add.Pos3.predictors{iL},R.Add.Epoch3.mFR{iL});
end
R.Add.Pos3.b = R.Add.Pos3.b';
R.Add.Pos3.dev = R.Add.Pos3.dev';
R.Add.Pos3.stats = R.Add.Pos3.stats';

for iL = 1:length(R.Add.Pos3.b)
    R.Add.Pos3.betas(iL,1) = R.Add.Pos3.b{iL}(2,1);
end
R.AvgBeta.Pos3 = mean(R.Add.Pos3.betas);


%Ambivalence Coding
R.Add.Amb.predictors = Predictors_Amb(data);
R.Add.Amb.predictors = R.Add.Amb.predictors';

for iL = 1:length(R.Figure3.O1_mFR)
    [R.Add.Amb.b{iL},R.Add.Amb.dev{iL},R.Add.Amb.stats{iL}] = glmfit(R.Add.Amb.predictors{iL},R.Add.Epoch3.mFR{iL});
end
R.Add.Amb.b = R.Add.Amb.b';
R.Add.Amb.dev = R.Add.Amb.dev';
R.Add.Amb.stats = R.Add.Amb.stats';

for iL = 1:length(R.Add.Amb.b)
    R.Add.Amb.betas(iL,1) = R.Add.Amb.b{iL}(2,1);
end
R.AvgBeta.Amb = mean(R.Add.Amb.betas);
%% Clean-up
clearvars -except R
%% Save
cd 'C:\Users\david\Desktop'
save ('FigureData.mat','-v7.3');