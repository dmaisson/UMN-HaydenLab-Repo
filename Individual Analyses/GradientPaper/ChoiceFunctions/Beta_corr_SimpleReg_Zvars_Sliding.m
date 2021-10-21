function [R] = Wrapper_SimpleReg_Zvars_Sliding(data,epoch)
%% Epoch 1 FR - Regression time!!
if epoch == 1
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,1); %Prob 1
    z = glmfit(x,y);
    R.Epoch1.b.intercept1(iL,1) = z(1,1);
    R.Epoch1.b.prob1(iL,1) = z(2,1); %betas from Epoch1 FR on Prob1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,2); %Size 1
    z = glmfit(x,y);
    R.Epoch1.b.intercept2(iL,1) = z(1,1);
    R.Epoch1.b.size1(iL,1) = z(2,1); %betas from Epoch1 FR on Size1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,3); %EV1
    z = glmfit(x,y);
    R.Epoch1.b.intercept3(iL,1) = z(1,1);
    R.Epoch1.b.EV1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,7); %Side of First
    z = glmfit(x,y);
    R.Epoch1.b.intercept4(iL,1) = z(1,1);
    R.Epoch1.b.Side1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,9); %Choice
    z = glmfit(x,y);
    R.Epoch1.b.intercept5(iL,1) = z(1,1);
    R.Epoch1.b.Choice(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end

elseif epoch == 2
%% Epoch 2 FR - Regression time!!
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,1); %Prob 1
    z = glmfit(x,y);
    R.Epoch2.b.intercept1(iL,1) = z(1,1);
    R.Epoch2.b.prob1(iL,1) = z(2,1); %betas from Epoch2 FR on Prob1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,2); %Size 1
    z = glmfit(x,y);
    R.Epoch2.b.intercept2(iL,1) = z(1,1);
    R.Epoch2.b.size1(iL,1) = z(2,1); %betas from Epoch2 FR on Size1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,4); %Prob 2
    z = glmfit(x,y);
    R.Epoch2.b.intercept3(iL,1) = z(1,1);
    R.Epoch2.b.prob2(iL,1) = z(2,1); %betas from Epoch2 FR on Prob2
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,5); %Size 2
    z = glmfit(x,y);
    R.Epoch2.b.intercept4(iL,1) = z(1,1);
    R.Epoch2.b.size2(iL,1) = z(2,1); %betas from Epoch2 FR on Size2
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,3); %EV 1
    z = glmfit(x,y);
    R.Epoch2.b.intercept5(iL,1) = z(1,1);
    R.Epoch2.b.EV1(iL,1) = z(2,1); %betas from Epoch2 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,6); %EV 2
    z = glmfit(x,y);
    R.Epoch2.b.intercept6(iL,1) = z(1,1);
    R.Epoch2.b.EV2(iL,1) = z(2,1); %betas from Epoch2 FR on EV2
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,7); %Side of First
    z = glmfit(x,y);
    R.Epoch2.b.intercept7(iL,1) = z(1,1);
    R.Epoch2.b.Side1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,9); %Choice
    z = glmfit(x,y);
    R.Epoch2.b.intercept8(iL,1) = z(1,1);
    R.Epoch2.b.Choice(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
elseif epoch == 3
%% Epoch 2 FR - Regression time!!
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,3); %EV 1
    z = glmfit(x,y);
    R.Epoch2.b.intercept5(iL,1) = z(1,1);
    R.Epoch2.b.EV1(iL,1) = z(2,1); %betas from Epoch2 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch2 average FR
    x(:,1) = data{iL}.zvars(:,6); %EV 2
    z = glmfit(x,y);
    R.Epoch2.b.intercept6(iL,1) = z(1,1);
    R.Epoch2.b.EV2(iL,1) = z(2,1); %betas from Epoch2 FR on EV2
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,7); %Side of First
    z = glmfit(x,y);
    R.Epoch2.b.intercept7(iL,1) = z(1,1);
    R.Epoch2.b.Side1(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
for iL = 1:size(data,1)
    y = data{iL}.mFR; %Epoch1 average FR
    x(:,1) = data{iL}.zvars(:,9); %Choice
    z = glmfit(x,y);
    R.Epoch2.b.intercept8(iL,1) = z(1,1);
    R.Epoch2.b.Choice(iL,1) = z(2,1); %betas from Epoch1 FR on EV1
    clear x y z
end
end

end

