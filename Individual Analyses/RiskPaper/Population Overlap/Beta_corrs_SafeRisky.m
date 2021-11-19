function [R] = Beta_corrs_SafeRisky(data)
for iA = 1:size(data.safe.Ep1,1)
    safe{iA,1}.trial = data.safe.Ep1{iA,1}.psth;
    safe{iA,1}.pre_trial = data.safe.pre_trial{iA,1}.psth;
    med{iA,1}.vars = data.eqlow.Ep1{iA,1}.vars;
    med{iA,1}.psth = data.eqlow.Ep1{iA,1}.psth;
    high{iA,1}.psth = data.eqhigh.Ep1{iA,1}.psth;
    high{iA,1}.vars = data.eqhigh.Ep1{iA,1}.vars;
end

%% 
% average FR over time by collapsing across the bins
for iL = 1:size(safe,1)
    R.safe_mFR_trial{iL,1} = nanmean(safe{iL}.trial,2);
    R.safe_mFR_pretrial{iL,1} = nanmean(safe{iL}.pre_trial,2);
    R.med_mFR{iL,1} = nanmean(med{iL}.psth,2);
    R.high_mFR{iL,1} = nanmean(high{iL}.psth,2);
end

%% Safe FR - Regression time!! 
for iL = 1:size(safe,1)
    x = R.safe_mFR_trial{iL};
    y = R.safe_mFR_pretrial{iL};
    z = abs(x-y);
    safe_betas(iL,1) = nanmean(z);
    clear x y z
end
clear safe

%% Med FR - Regression time!!
for iL = 1:size(med,1)
    y = R.med_mFR{iL}; %Epoch1 average FR
    x(:,1) = med{iL}.vars(:,1); %Prob 1
    [z,~,~] = glmfit(x,y);
    med_betas(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
    clear x y z
end
clear med

%% High FR - Regression time!! 
for iL = 1:size(high,1)
    y = R.high_mFR{iL}; %Epoch1 average FR
    x(:,1) = high{iL}.vars(:,1); %Prob 1
    [z,~,~] = glmfit(x,y);
    high_betas(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
    clear x y z
end
clear high R iA iL

R.safe_betas = safe_betas;
R.med_betas = med_betas;
R.high_betas = high_betas;
%% Correlations
%Pearson Correlations
[R.safe_med.r,R.safe_med.p] = corr(abs(safe_betas),abs(med_betas),'Type','Pearson');
[R.safe_high.r,R.safe_high.p] = corr(abs(safe_betas),abs(high_betas),'Type','Pearson');

end

