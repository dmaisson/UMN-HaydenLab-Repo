function [R] = Beta_corrs_SafeRisky(data)
for iA = 1:size(data.safe.Ep1,1)
    safe{iA,1}.psth = data.safe.Ep1{iA,1}.psth;
    med{iA,1}.psth = data.eqlow.Ep1{iA,1}.psth;
    high{iA,1}.psth = data.eqhigh.Ep1{iA,1}.psth;
    safe{iA,1}.vars = data.safe.Ep1{iA,1}.vars;
    med{iA,1}.vars = data.eqlow.Ep1{iA,1}.vars;
    high{iA,1}.vars = data.eqhigh.Ep1{iA,1}.vars;
end

%% 
% average FR over time by collapsing across the bins
for iL = 1:size(safe,1)
    R.safe_mFR{iL,1} = mean(safe{iL}.psth,2);
    R.med_mFR{iL,1} = mean(med{iL}.psth,2);
    R.high_mFR{iL,1} = mean(high{iL}.psth,2);
end

%% Safe FR - Regression time!! 
for iL = 1:size(safe,1)
    y = R.safe_mFR{iL}; %Epoch1 average FR
    x = safe{iL}.vars(:,4); %Prob 1
%     x(:,2) = safe{iL}.vars(:,2); %Size 1
    [z,~,~] = glmfit(x,y);
    R.safe.b.choice(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
%     R.safe.b.size1(iL,1) = z(3,1); %betas from Epoch1 FR on Size1
    clear x y z
end
% for iL = 1:size(safe,1)
%     y = R.safe_mFR{iL}; %Epoch1 average FR
%     x(:,1) = safe{iL}.vars(:,3); %EV 1
%     [z,~,~] = glmfit(x,y);
%     R.safe.b.EV1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
%     clear x y z stats dev
% end

%% Med FR - Regression time!!
for iL = 1:size(med,1)
    y = R.med_mFR{iL}; %Epoch1 average FR
    x(:,1) = med{iL}.vars(:,4); %Prob 1
%     x(:,2) = med{iL}.vars(:,2); %Size 1
    [z,~,~] = glmfit(x,y);
    R.med.b.choice(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
%     R.med.b.size1(iL,1) = z(3,1); %betas from Epoch1 FR on Size1
    clear x y z
end
% for iL = 1:size(med,1)
%     y = R.med_mFR{iL}; %Epoch1 average FR
%     x(:,1) = med{iL}.vars(:,3); %EV 1
%     [z,~,~] = glmfit(x,y);
%     R.med.b.EV1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
%     clear x y z stats dev
% end

%% High FR - Regression time!! 
for iL = 1:size(high,1)
    y = R.high_mFR{iL}; %Epoch1 average FR
    x(:,1) = high{iL}.vars(:,4); %Prob 1
%     x(:,2) = high{iL}.vars(:,2); %Size 1
    [z,~,~] = glmfit(x,y);
    R.high.b.choice(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
%     R.high.b.size1(iL,1) = z(3,1); %betas from Epoch1 FR on Size1
    clear x y z
end
% for iL = 1:size(high,1)
%     y = R.high_mFR{iL}; %Epoch1 average FR
%     x(:,1) = high{iL}.vars(:,3); %EV 1
%     [z,~,~] = glmfit(x,y);
%     R.high.b.EV1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
%     clear x y z stats dev
% end

%% Correlations
%Pearson Correlations
[R.safe_med.pop.r,R.safe_med.pop.p] = corr(abs(R.safe.b.choice),abs(R.med.b.choice),'Type','Pearson');
% [R.safe_med.pop.r,R.safe_med.pop.p] = corr(abs(R.safe.b.EV1),abs(R.med.b.EV1),'Type','Pearson');

end

