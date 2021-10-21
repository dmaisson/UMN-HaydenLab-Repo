function [out] = ModRate_shuffle(input,col)
%%
% Rate of neurons modulated by offer over Trial Time
% Within each time bin, correlate FR with EV for each offer
    % For each cell, identify EV for each trial (EV1: column 3; EV2:
    % column 6
Results.modrate.EVs = PullEV_shuffle(input);
    % For each cell, pull out FR for given epochs (6 seconds)
for iL = 1:length(input)
    Results.modrate.FR{iL} = input{iL}.psth(:,100:399);
end
Results.modrate.FR = Results.modrate.FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(input)
    Results.modrate.FRcol{iL} = FR_CollapseBins(Results.modrate.FR{iL},col);
end
Results.modrate.FRcol = Results.modrate.FRcol';

% Modulation by EV
    % For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.FRcol{iL},2)
        [Results.modrate.r.EV1(iL,iK),Results.modrate.p.EV1(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),Results.modrate.EVs{iL}(:,1)); %EV1
        [Results.modrate.r.EV2(iL,iK),Results.modrate.p.EV2(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),Results.modrate.EVs{iL}(:,2)); %EV2
    end
end

% For each time bin (column), calculate the % of p-values that are < .05

for iL = 1:size(Results.modrate.p.EV1,2)
    Results.modrate.rate.EV1(1,iL) = (sum(Results.modrate.p.EV1(:,iL)<.05)/length(Results.modrate.p.EV1))*100; %EV1
    Results.modrate.rate.EV2(1,iL) = (sum(Results.modrate.p.EV2(:,iL)<.05)/length(Results.modrate.p.EV2))*100; %EV2
end

% Modulation by Side
Results.modrate.Side = PullSide_shuffle(input);
    % For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.FRcol{iL},2)
        [Results.modrate.r.Side1(iL,iK),Results.modrate.p.Side1(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),Results.modrate.Side{iL}(:,1)); %Side of First
        [Results.modrate.r.SideC(iL,iK),Results.modrate.p.SideC(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),Results.modrate.Side{iL}(:,2)); %Chosen Side
    end
end

% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.EV1,2)
    Results.modrate.rate.Side1(1,iL) = (sum(Results.modrate.p.Side1(:,iL)<.05)/length(Results.modrate.p.Side1))*100; %Side of first
    Results.modrate.rate.SideC(1,iL) = (sum(Results.modrate.p.SideC(:,iL)<.05)/length(Results.modrate.p.SideC))*100; %Side of chosen
end

% Modulation by Chosen/Unchosen Value/Side and outcome
for iJ = 1:size(input,1)
    ChosenOffer{iJ}(:,1) = input{iJ}.zvars(:,9);
    for iK = 1:size(input{iJ}.zvars,1)
        x = randi(9);
        ChosenOffer{iJ}(iK,2) = input{iJ}.zvars(iK,x);
        ChosenOffer{iJ}(iK,3) = input{iJ}.zvars(iK,x);
    end
    ChosenOffer{iJ}(:,4) = input{iJ}.zvars(:,8);%chosen side
end
% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.FRcol{iL},2)
        [Results.modrate.r.Choice(iL,iK),Results.modrate.p.Choice(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,1)); %Chosen Offer
        [Results.modrate.r.ChoiceVal(iL,iK),Results.modrate.p.ChoiceVal(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,2)); %Chosen Offer Value
        [Results.modrate.r.UnChoiceVal(iL,iK),Results.modrate.p.UnChoiceVal(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,3)); %Unchosen Offer Value
        [Results.modrate.r.ChoiceSide(iL,iK),Results.modrate.p.ChoiceSide(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,4)); %Chosen Offer side
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.Choice,2)
    out.Choice(1,iL) = (sum(Results.modrate.p.Choice(:,iL)<.05)/length(Results.modrate.p.Choice))*100; %Chosen Offer
    out.ChoiceVal(1,iL) = (sum(Results.modrate.p.ChoiceVal(:,iL)<.05)/length(Results.modrate.p.ChoiceVal))*100; %Chosen Offer Value
    out.UnChoiceVal(1,iL) = (sum(Results.modrate.p.UnChoiceVal(:,iL)<.05)/length(Results.modrate.p.UnChoiceVal))*100; %Unchosen Offer Value
    out.ChoiceSide(1,iL) = (sum(Results.modrate.p.ChoiceSide(:,iL)<.05)/length(Results.modrate.p.ChoiceSide))*100; %Chosen Offer side
end

%% Epoch-specific
%     % For each cell, pull out FR for given epochs (6 seconds)
%     % OOORRR!!!
%     % just average the results from above based on contents of bins
% if Habiba == 0
%     out.E1EV1 = nanmean(Results.modrate.rate.EV1(:,11:15),2); % bin 11:15
%     out.E1Side1 = nanmean(Results.modrate.rate.Side1(:,11:15),2); % bin 11:15
%     out.E2EV1 = nanmean(Results.modrate.rate.EV1(:,21:25),2); % bin 21:25
%     out.E2EV2 = nanmean(Results.modrate.rate.EV2(:,21:25),2); % bin 21:25
%     out.E2Side = nanmean(Results.modrate.rate.Side1(:,21:25),2); % bin 21:25
%     out.E0Choice = nanmean(out.Choice(:,30:32),2); % bin 30:32
%     out.E0ChoiceVal = nanmean(out.ChoiceVal(:,30:32),2); % bin 30:32
%     out.E0UnChoiceVal = nanmean(out.UnChoiceVal(:,30:32),2); % bin 30:32
%     out.E0ChoiceSide = nanmean(out.ChoiceSide(:,30:32),2); % bin 30:32
%     out.E3Choice = nanmean(out.Choice(:,33:37),2); % bin 33:37
%     out.E3ChoiceVal = nanmean(out.ChoiceVal(:,33:37),2); % bin 33:37
%     out.E3UnChoiceVal = nanmean(out.UnChoiceVal(:,33:37),2); % bin 33:37
%     out.E3ChoiceSide = nanmean(out.ChoiceSide(:,33:37),2); % bin 33:37
% elseif Habiba == 1
%     out.E1EV1 = nanmean(Results.modrate.rate.EV1(:,11:15),2); % bin 11:15
%     out.E1Side1 = nanmean(Results.modrate.rate.Side1(:,11:15),2); % bin 11:15
%     out.E2EV1 = nanmean(Results.modrate.rate.EV1(:,19:23),2); % bin 19:23
%     out.E2EV2 = nanmean(Results.modrate.rate.EV2(:,19:23),2); % bin 19:23
%     out.E2Side = nanmean(Results.modrate.rate.Side1(:,19:23),2); % bin 19:23
%     out.E0Choice = nanmean(out.Choice(:,25:27),2); % bin 25:27
%     out.E0ChoiceVal = nanmean(out.ChoiceVal(:,25:27),2); % bin 25:27
%     out.E0UnChoiceVal = nanmean(out.UnChoiceVal(:,25:27),2); % bin 25:27
%     out.E0ChoiceSide = nanmean(out.ChoiceSide(:,25:27),2); % bin 25:27
%     out.E3Choice = nanmean(out.Choice(:,28:32),2); % bin 28:32
%     out.E3ChoiceVal = nanmean(out.ChoiceVal(:,28:32),2); % bin 28:32
%     out.E3UnChoiceVal = nanmean(out.UnChoiceVal(:,28:32),2); % bin 28:32
%     out.E3ChoiceSide = nanmean(out.ChoiceSide(:,28:32),2); % bin 28:32
% end

end