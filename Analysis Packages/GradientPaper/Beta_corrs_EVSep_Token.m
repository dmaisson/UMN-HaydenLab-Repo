function [R] = Wrapper_MultiReg_EVSep_Habiba(data,ms)
%% Exclude trials with a safe offer
for iL = 1:length(data) %cycle through the cell
    for iK = 1:length(data{iL}.vars) %cycle through each trial in the cell
        if data{iL}.vars(iK,1)==1 || data{iL}.vars(iK,4)==1 %If either prob is 1 ("guarantee")
            data{iL}.vars(iK,:)=NaN; %remove value
            data{iL}.psth(iK,:)=NaN; %remove value
            data{iL}.zvars(iK,:)=NaN; %remove value
        end
        if data{iL}.vars(iK,1)==0 || data{iL}.vars(iK,4)==0 %If either prob is 0%
            data{iL}.vars(iK,:)=NaN; %remove value
            data{iL}.psth(iK,:)=NaN; %remove value
            data{iL}.zvars(iK,:)=NaN; %remove value
        end
    end
end

%% Value definition
epoch1 = 155;
epoch2 = 193;
epoch3 = 230;

%% Epoch Iso
% Pull FRs for given epoch
R.E1_FR = EpochIsolation(data, epoch1, ms);
R.E2_FR = EpochIsolation(data, epoch2, ms);
R.E3_FR = EpochIsolation(data, epoch3, ms);


% average FR over time by collapsing across the bins
for iL = 1:length(R.E1_FR)
    R.E1_mFR{iL} = mean(R.E1_FR{iL},2);
    R.E2_mFR{iL} = mean(R.E2_FR{iL},2);
    R.E3_mFR{iL} = mean(R.E3_FR{iL},2);
end
R.E1_mFR = R.E1_mFR';
R.E2_mFR = R.E2_mFR';
R.E3_mFR = R.E3_mFR';

%% Epoch 1 FR - Regression time!! 
for iL = 1:size(data,1)
    y = R.E1_mFR{iL}; %Epoch1 average FR
    x(:,1) = data{iL}.vars(:,1); %Prob 1
    x(:,2) = data{iL}.vars(:,2); %Size 1
    x(:,3) = data{iL}.vars(:,7);
    x(:,4) = data{iL}.vars(:,9);
%     x(:,5) = data{iL}.vars(:,10);
%     x(:,6) = data{iL}.vars(:,11);
%     x(:,7) = data{iL}.vars(:,12);
    [z,dev,stats] = glmfit(x,y);
    R.Epoch1.b.intercept1(iL,1) = z(1,1);
    R.Epoch1.b.prob1(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
    R.Epoch1.b.size1(iL,1) = z(3,1); %betas from Epoch1 FR on Size1
%     R.Epoch1.b.SideCompreg(iL,1) = z(4,1); %betas from Epoch1 FR on side of first
%     R.Epoch1.b.ChoiceCompreg(iL,1) = z(5,1); %betas from Epoch1 FR on choice
    R.Epoch1.p.prob1(iL,1) = stats.p(2,1);
    R.Epoch1.p.size1(iL,1) = stats.p(3,1);
    clear x y z stats dev
end
for iL = 1:size(data,1)
    y = R.E1_mFR{iL}; %Epoch1 average FR
    x(:,1) = data{iL}.vars(:,3); %EV 1
    x(:,2) = data{iL}.vars(:,7);
    x(:,3) = data{iL}.vars(:,9);
%     x(:,4) = data{iL}.vars(:,10);
%     x(:,5) = data{iL}.vars(:,11);
%     x(:,6) = data{iL}.vars(:,12);
    [z,dev,stats] = glmfit(x,y);
    R.Epoch1.b.intercept2(iL,1) = z(1,1);
    R.Epoch1.b.EV1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
%     R.Epoch1.b.SideEVreg(iL,1) = z(3,1); %betas from Epoch1 FR on side of first
%     R.Epoch1.b.ChoiceEVreg(iL,1) = z(4,1); %betas from Epoch1 FR on choice
    R.Epoch1.p.EV1(iL,1) = stats.p(2,1);
    clear x y z stats dev
end

%% Epoch 2 FR - Regression time!!
for iL = 1:size(data,1)
    y = R.E2_mFR{iL}; %Epoch2 average FR
    x(:,1) = data{iL}.vars(:,1); %Prob 1
    x(:,2) = data{iL}.vars(:,2); %Size 1
    x(:,3) = data{iL}.vars(:,4); %Prob 2
    x(:,4) = data{iL}.vars(:,5); %Size 2
    x(:,5) = data{iL}.vars(:,7);
    x(:,6) = data{iL}.vars(:,9);
%     x(:,7) = data{iL}.vars(:,10);
%     x(:,8) = data{iL}.vars(:,11);
%     x(:,9) = data{iL}.vars(:,12);
    [z,dev,stats] = glmfit(x,y);
    R.Epoch2.b.intercept1(iL,1) = z(1,1);
    R.Epoch2.b.prob1(iL,1) = z(2,1); %betas from Epoch2 FR on Prob1
    R.Epoch2.b.size1(iL,1) = z(3,1); %betas from Epoch2 FR on Size1
    R.Epoch2.b.prob2(iL,1) = z(4,1); %betas from Epoch2 FR on Prob2
    R.Epoch2.b.size2(iL,1) = z(5,1); %betas from Epoch2 FR on Size2
%     R.Epoch2.b.SideCompreg(iL,1) = z(6,1); %betas from Epoch2 FR on side of first
%     R.Epoch2.b.ChoiceCompreg(iL,1) = z(7,1); %betas from Epoch2 FR on choice
    R.Epoch2.p.prob1(iL,1) = stats.p(2,1);
    R.Epoch2.p.size1(iL,1) = stats.p(3,1);
    R.Epoch2.p.prob2(iL,1) = stats.p(4,1);
    R.Epoch2.p.size2(iL,1) = stats.p(5,1);
    clear x y z stats dev
end
for iL = 1:size(data,1)
    y = R.E2_mFR{iL}; %Epoch2 average FR
    x(:,1) = data{iL}.vars(:,3); %EV 1
    x(:,2) = data{iL}.vars(:,6); %EV 2
    x(:,3) = data{iL}.vars(:,7);
    x(:,4) = data{iL}.vars(:,9);
%     x(:,5) = data{iL}.vars(:,10); % outcome
%     x(:,6) = data{iL}.vars(:,11); % jackpot
%     x(:,7) = data{iL}.vars(:,12); % Tokens at start
%     if data{iL}.vars(:,9) == 1
%         x(:,8) = data{iL}.vars(:,1); % prob of chosen offer 1
%     elseif data{iL}.vars(:,9) == 0
%         x(:,8) = data{iL}.vars(:,4); % prob of chosen offer 4
%     end
    [z,dev,stats] = glmfit(x,y);
    R.Epoch2.b.intercept2(iL,1) = z(1,1);
    R.Epoch2.b.EV1(iL,1) = z(2,1); %betas from Epoch2 FR on EV1
    R.Epoch2.b.EV2(iL,1) = z(3,1); %betas from Epoch2 FR on EV2
%     R.Epoch2.b.SideEVreg(iL,1) = z(4,1); %betas from Epoch2 FR on side of first
%     R.Epoch2.b.ChoiceEVreg(iL,1) = z(5,1); %betas from Epoch2 FR on choice
    R.Epoch2.p.EV1(iL,1) = stats.p(2,1);
    R.Epoch2.p.EV2(iL,1) = stats.p(3,1);
    clear x y z stats dev
end

%% Epoch 3 FR - Regression time!! 
for iL = 1:size(data,1)
    y = R.E3_mFR{iL}; %Epoch1 average FR
    x(:,1) = data{iL}.vars(:,3); %EV 1
    x(:,2) = data{iL}.vars(:,6); %EV 2
    x(:,3) = data{iL}.vars(:,7);
    x(:,4) = data{iL}.vars(:,9);
%     x(:,5) = data{iL}.vars(:,10);
%     x(:,6) = data{iL}.vars(:,11);
%     x(:,7) = data{iL}.vars(:,12);
    [z,dev,stats] = glmfit(x,y);
    R.Epoch3.b.intercept2(iL,1) = z(1,1);
    R.Epoch3.b.EV1(iL,1) = z(2,1); %betas from Epoch3 FR on EV1
    R.Epoch3.b.EV2(iL,1) = z(3,1); %betas from Epoch3 FR on EV2
%     R.Epoch3.b.SideEVreg(iL,1) = z(3,1); %betas from Epoch1 FR on side of first
%     R.Epoch3.b.ChoiceEVreg(iL,1) = z(5,1); %betas from Epoch1 FR on choice
    R.Epoch3.p.EV1(iL,1) = stats.p(2,1);
    R.Epoch3.p.EV2(iL,1) = stats.p(3,1);
    clear x y z stats dev
end
%% Cross-Epoch concatenation
% betas from Epoch1 FR on Prob1 and from Epoch2 FR on Prob2
R.cat.prob = cat(1,R.Epoch1.b.prob1,R.Epoch2.b.prob2);
% betas from Epoch1 FR on Size1 and from Epoch2 FR on Size2
R.cat.size = cat(1,R.Epoch1.b.size1,R.Epoch2.b.size2);

%% Correlations
%Pearson Correlations
%Integration - Epoch 1 (Size1 and Prob1 in Epoch1)
[R.Integ.E1.r.format,R.Integ.E1.p.format] = corr(R.Epoch1.b.prob1,R.Epoch1.b.size1,'Type','Pearson');
[R.Integ.E1.r.pop,R.Integ.E1.p.pop] = corr(abs(R.Epoch1.b.prob1),abs(R.Epoch1.b.size1),'Type','Pearson');

%Integration - Epoch 2 (Size2 and Prob2 in Epoch 2)
[R.Integ.E2.r.format,R.Integ.E2.p.format] = corr(R.Epoch2.b.prob2,R.Epoch2.b.size2,'Type','Pearson');
[R.Integ.E2.r.pop,R.Integ.E2.p.pop] = corr(abs(R.Epoch2.b.prob2),abs(R.Epoch2.b.size2),'Type','Pearson');

%Integration - Cross-Epoch (SizeBoth and ProbBoth in respective Epoch)
[R.Integ.cross.r.format,R.Integ.cross.p.format] = corr(R.cat.prob,R.cat.size,'Type','Pearson');
[R.Integ.cross.r.pop,R.Integ.cross.p.pop] = corr(abs(R.cat.prob),abs(R.cat.size),'Type','Pearson');

%Inhibition - EV (EV1 and EV2 in Epoch2)
[R.Inhib.EV.r.format,R.Inhib.EV.p.format] = corr(R.Epoch2.b.EV1,R.Epoch2.b.EV2,'Type','Pearson');
[R.Inhib.EV.r.pop,R.Inhib.EV.p.pop] = corr(abs(R.Epoch2.b.EV1),abs(R.Epoch2.b.EV2),'Type','Pearson');

%Inhibition - Probability (Prob1 and Prob2 in Epoch2)
[R.Inhib.prob.r.format,R.Inhib.prob.p.format] = corr(R.Epoch2.b.prob1,R.Epoch2.b.prob2,'Type','Pearson');
[R.Inhib.prob.r.pop,R.Inhib.prob.p.pop] = corr(abs(R.Epoch2.b.prob1),abs(R.Epoch2.b.prob2),'Type','Pearson');

%Inhibition - Size (Size1 and Size2 in Epoch2)
[R.Inhib.size.r.format,R.Inhib.size.p.format] = corr(R.Epoch2.b.size1,R.Epoch2.b.size2,'Type','Pearson');
[R.Inhib.size.r.pop,R.Inhib.size.p.pop] = corr(abs(R.Epoch2.b.size1),abs(R.Epoch2.b.size2),'Type','Pearson');

%Alignment (EV of Epoch in respective Epoch)
[R.Align.r.format,R.Align.p.format] = corr(R.Epoch1.b.EV1,R.Epoch2.b.EV2,'Type','Pearson');
[R.Align.r.pop,R.Align.p.pop] = corr(abs(R.Epoch1.b.EV1),abs(R.Epoch2.b.EV2),'Type','Pearson');

%WM (EV1 in both Epochs)
[R.WM.r.format,R.WM.p.format] = corr(R.Epoch1.b.EV1,R.Epoch2.b.EV1,'Type','Pearson');
[R.WM.r.pop,R.WM.p.pop] = corr(abs(R.Epoch1.b.EV1),abs(R.Epoch2.b.EV1),'Type','Pearson');

end

