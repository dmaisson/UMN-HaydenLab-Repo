function [R] = OmegaSq(data,epoch1,ms)
% Compute Omega^2 (W2)
% ESS = sum for all values (estimated y - average y)^2
% RSS = sum for all values (observed y - estimated y)^2
% MSE = mean RSS
% DF = num predictors - 1

% W2 = (ESS-(DF*MSE))/(MSE + (RSS+ESS)) for each predictor
%% Simple Regression
R = Wrapper_SimpleReg_Zvars(data,epoch1,ms);

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

%% Omega^2 calculation
% Epoch1
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.vars,1)
% EV1
EV1.est{iJ}(iK,1) = R.Epoch1.b.intercept3(iJ,1) + (R.Epoch1.b.EV1(iJ,1)*(data{iJ}.zvars(iK,3)));
ESS.EV1(iJ,1) = sum((EV1.est{iJ}(iK,1) - nanmean(R.E1_mFR{iJ}))^2);
RSS.EV1(iJ,1) = sum((R.E1_mFR{iJ}(iK,1) - EV1.est{iJ}(iK,1))^2);

% Side of First
Side1.est{iJ}(iK,1) = R.Epoch1.b.intercept4(iJ,1) + (R.Epoch1.b.Side1(iJ,1)*(data{iJ}.zvars(iK,7)));
ESS.Side1(iJ,1) = sum((Side1.est{iJ}(iK,1) - nanmean(R.E1_mFR{iJ}))^2);
RSS.Side1(iJ,1) = sum((R.E1_mFR{iJ}(iK,1) - Side1.est{iJ}(iK,1))^2);

% Choice
Choice.est{iJ}(iK,1) = R.Epoch1.b.intercept5(iJ,1) + (R.Epoch1.b.Choice(iJ,1)*(data{iJ}.zvars(iK,9)));
ESS.Choice(iJ,1) = sum((Choice.est{iJ}(iK,1) - nanmean(R.E1_mFR{iJ}))^2);
RSS.Choice(iJ,1) = sum((R.E1_mFR{iJ}(iK,1) - Choice.est{iJ}(iK,1))^2);

% Size 1
Size1.est{iJ}(iK,1) = R.Epoch1.b.intercept2(iJ,1) + (R.Epoch1.b.size1(iJ,1)*(data{iJ}.zvars(iK,2)));
ESS.Size1(iJ,1) = sum((Size1.est{iJ}(iK,1) - nanmean(R.E1_mFR{iJ}))^2);
RSS.Size1(iJ,1) = sum((R.E1_mFR{iJ}(iK,1) - Size1.est{iJ}(iK,1))^2);

% Prob 1
Prob1.est{iJ}(iK,1) = R.Epoch1.b.intercept1(iJ,1) + (R.Epoch1.b.prob1(iJ,1)*(data{iJ}.zvars(iK,1)));
ESS.Prob1(iJ,1) = sum((Prob1.est{iJ}(iK,1) - nanmean(R.E1_mFR{iJ}))^2);
RSS.Prob1(iJ,1) = sum((R.E1_mFR{iJ}(iK,1) - Prob1.est{iJ}(iK,1))^2);

    end
end

MSE.EV1 = nanmean(RSS.EV1);
MSE.Choice = nanmean(RSS.Choice);
MSE.Side1 = nanmean(RSS.Side1);
MSE.Size1 = nanmean(RSS.Size1);
MSE.Prob1 = nanmean(RSS.Prob1);

clear Choice Side1 Size1 EV1 Prob1

for iJ = 1:size(data,1)
EV1(iJ,1) = (ESS.EV1(iJ,1) - (MSE.EV1))/(MSE.EV1 + (ESS.EV1(iJ,1) + RSS.EV1(iJ,1)));
Side1(iJ,1) = (ESS.Side1(iJ,1) - (MSE.Side1))/(MSE.Side1 + (ESS.Side1(iJ,1) + RSS.Side1(iJ,1)));
Choice(iJ,1) = (ESS.Choice(iJ,1) - (MSE.Choice))/(MSE.Choice + (ESS.Choice(iJ,1) + RSS.Choice(iJ,1)));
Size1(iJ,1) = (ESS.Size1(iJ,1) - (MSE.Size1))/(MSE.Size1 + (ESS.Size1(iJ,1) + RSS.Size1(iJ,1)));
Prob1(iJ,1) = (ESS.Prob1(iJ,1) - (MSE.Prob1))/(MSE.Prob1 + (ESS.Prob1(iJ,1) + RSS.Prob1(iJ,1)));
end

clear MSE ESS RSS 

R.W2.E1EV1 = nanmean(EV1);
R.W2.E1Side1 = nanmean(Side1);
R.W2.E1Choice = nanmean(Choice);
R.W2.E1Size1 = nanmean(Size1);
R.W2.E1Prob1 = nanmean(Prob1);

clear Choice Side1 Size1 Prob1 EV1

% Epoch2
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.vars,1)
% EV1
EV1.est{iJ}(iK,1) = R.Epoch2.b.intercept5(iJ,1) + (R.Epoch2.b.EV1(iJ,1)*(data{iJ}.zvars(iK,3)));
ESS.EV1(iJ,1) = sum((EV1.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.EV1(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - EV1.est{iJ}(iK,1))^2);

% EV2
EV2.est{iJ}(iK,1) = R.Epoch2.b.intercept6(iJ,1) + (R.Epoch2.b.EV2(iJ,1)*(data{iJ}.zvars(iK,6)));
ESS.EV2(iJ,1) = sum((EV2.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.EV2(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - EV2.est{iJ}(iK,1))^2);

% Side of First
Side1.est{iJ}(iK,1) = R.Epoch2.b.intercept7(iJ,1) + (R.Epoch2.b.Side1(iJ,1)*(data{iJ}.zvars(iK,7)));
ESS.Side1(iJ,1) = sum((Side1.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Side1(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Side1.est{iJ}(iK,1))^2);

% Choice
Choice.est{iJ}(iK,1) = R.Epoch2.b.intercept8(iJ,1) + (R.Epoch2.b.Choice(iJ,1)*(data{iJ}.zvars(iK,9)));
ESS.Choice(iJ,1) = sum((Choice.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Choice(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Choice.est{iJ}(iK,1))^2);

% Size 1
Size1.est{iJ}(iK,1) = R.Epoch2.b.intercept2(iJ,1) + (R.Epoch2.b.size1(iJ,1)*(data{iJ}.zvars(iK,2)));
ESS.Size1(iJ,1) = sum((Size1.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Size1(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Size1.est{iJ}(iK,1))^2);

% Size 2
Size2.est{iJ}(iK,1) = R.Epoch2.b.intercept4(iJ,1) + (R.Epoch2.b.size2(iJ,1)*(data{iJ}.zvars(iK,5)));
ESS.Size2(iJ,1) = sum((Size2.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Size2(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Size2.est{iJ}(iK,1))^2);

% Prob 1
Prob1.est{iJ}(iK,1) = R.Epoch2.b.intercept1(iJ,1) + (R.Epoch2.b.prob1(iJ,1)*(data{iJ}.zvars(iK,1)));
ESS.Prob1(iJ,1) = sum((Prob1.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Prob1(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Prob1.est{iJ}(iK,1))^2);

% Prob 2
Prob2.est{iJ}(iK,1) = R.Epoch2.b.intercept3(iJ,1) + (R.Epoch2.b.prob2(iJ,1)*(data{iJ}.zvars(iK,4)));
ESS.Prob2(iJ,1) = sum((Prob2.est{iJ}(iK,1) - nanmean(R.E2_mFR{iJ}))^2);
RSS.Prob2(iJ,1) = sum((R.E2_mFR{iJ}(iK,1) - Prob2.est{iJ}(iK,1))^2);

    end
end
MSE.EV1 = nanmean(RSS.EV1);
MSE.EV2 = nanmean(RSS.EV2);
MSE.Choice = nanmean(RSS.Choice);
MSE.Side1 = nanmean(RSS.Side1);
MSE.Size1 = nanmean(RSS.Size1);
MSE.Size2 = nanmean(RSS.Size2);
MSE.Prob1 = nanmean(RSS.Prob1);
MSE.Prob2 = nanmean(RSS.Prob2);

clear Choice Side1 Size1 Size2 EV1 EV2 Prob1 Prob2

for iJ = 1:size(data,1)
EV1(iJ,1) = (ESS.EV1(iJ,1) - (MSE.EV1))/(MSE.EV1 + (ESS.EV1(iJ,1) + RSS.EV1(iJ,1)));
EV2(iJ,1) = (ESS.EV2(iJ,1) - (MSE.EV2))/(MSE.EV2 + (ESS.EV2(iJ,1) + RSS.EV2(iJ,1)));
Side1(iJ,1) = (ESS.Side1(iJ,1) - (MSE.Side1))/(MSE.Side1 + (ESS.Side1(iJ,1) + RSS.Side1(iJ,1)));
Choice(iJ,1) = (ESS.Choice(iJ,1) - (MSE.Choice))/(MSE.Choice + (ESS.Choice(iJ,1) + RSS.Choice(iJ,1)));
Size1(iJ,1) = (ESS.Size1(iJ,1) - (MSE.Size1))/(MSE.Size1 + (ESS.Size1(iJ,1) + RSS.Size1(iJ,1)));
Size2(iJ,1) = (ESS.Size2(iJ,1) - (MSE.Size2))/(MSE.Size2 + (ESS.Size2(iJ,1) + RSS.Size2(iJ,1)));
Prob1(iJ,1) = (ESS.Prob1(iJ,1) - (MSE.Prob1))/(MSE.Prob1 + (ESS.Prob1(iJ,1) + RSS.Prob1(iJ,1)));
Prob2(iJ,1) = (ESS.Prob2(iJ,1) - (MSE.Prob2))/(MSE.Prob2 + (ESS.Prob2(iJ,1) + RSS.Prob2(iJ,1)));
end

clear MSE ESS RSS

R.W2.E2EV1 = nanmean(EV1);
R.W2.E2EV2 = nanmean(EV2);
R.W2.E2Side1 = nanmean(Side1);
R.W2.E2Choice = nanmean(Choice);
R.W2.E2Size1 = nanmean(Size1);
R.W2.E2Size2 = nanmean(Size2);
R.W2.E2Prob1 = nanmean(Prob1);
R.W2.E2Prob2 = nanmean(Prob2);

clear Choice Side1 Size1 Size2 EV1 EV2 Prob1 Prob2
end

