function [ChoiceMatrix] = Regressions_Filtered(filtered)

    % For each cell, pull out FR for given epochs (6 seconds)
for iL = 1:length(filtered)
    data.modrate.FR{iL} = filtered{iL}.psth(:,100:399);
end
data.modrate.FR = data.modrate.FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(filtered)
    data.modrate.FRcol{iL} = FR_CollapseBins(data.modrate.FR{iL},5);
end
FRcol = data.modrate.FRcol';

for iJ = 1:size(filtered,1)
    ChosenOffer{iJ}(:,1) = filtered{iJ}.zvars(:,9);
    for iK = 1:size(filtered{iJ}.zvars,1)
        if filtered{iJ}.vars(iK,9) == 1
            ChosenOffer{iJ}(iK,2) = filtered{iJ}.zvars(iK,3);
            ChosenOffer{iJ}(iK,3) = filtered{iJ}.zvars(iK,6);
        elseif filtered{iJ}.vars(iK,9) == 0
            ChosenOffer{iJ}(iK,2) = filtered{iJ}.zvars(iK,6);
            ChosenOffer{iJ}(iK,3) = filtered{iJ}.zvars(iK,3);
        end
    end
end
ChosenOffer = ChosenOffer';

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,1:10),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,1) = z(2,1); %betas
    clear x y z;
end

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,11:20),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,2) = z(2,1); %betas
    clear x y z;
end

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,21:30),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,3) = z(2,1); %betas
    clear x y z;
end

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,31:40),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,4) = z(2,1); %betas
    clear x y z;
end

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,41:50),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,5) = z(2,1); %betas
    clear x y z;
end

for iL = 1:size(FRcol,1)
    y = mean(FRcol{iL}(:,51:60),2); %Pretrial average FR
    x(:,1) = ChosenOffer{iL}(:,2); %Choice
    z = glmfit(x,y);
    R.choice(iL,6) = z(2,1); %betas
    clear x y z;
end

ChoiceMatrix = mean(R.choice,1);

end