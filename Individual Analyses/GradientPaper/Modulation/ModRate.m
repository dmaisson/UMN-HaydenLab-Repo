function [Results] = ModRate(input,token,col)
%% Resize
for iJ = 1:size(input,1)
    for iK = 1:size(input{iJ}.psth,1)
        if size(input{iJ}.psth,2) > 750 && size(input{iJ}.psth,2) < 1500
            data{iJ}.psth(iK,:) = FR_CollapseBins(input{iJ}.psth(iK,:),2);
        elseif size(input{iJ}.psth,2) == 1500
            temp{iJ}.psth(iK,:) = input{iJ}.psth(iK,201:1200);
            data{iJ}.psth(iK,:) = FR_CollapseBins(temp{iJ}.psth(iK,:),2);
        elseif size(input{iJ}.psth,2) == 750
            data{iJ}.psth(iK,:) = input{iJ}.psth(iK,101:600);
        end
    end
    data{iJ}.vars = input{iJ}.vars;
end
clear start temp input
data = data';

%% Recode
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,7) == 2 %right, old code
            data{iK}.vars(iL,7) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,8) == 2 %right, old code
            data{iK}.vars(iL,8) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,9) == 2 %second, old code
            data{iK}.vars(iL,9) = 0; %right, new coding
        end
    end
end
%% Rate of neurons modulated by offer over Trial
% Within each time bin, correlate FR with EV for each offer
    % For each cell, identify EV for each trial (EV1: column 3; EV2:
    % column 6
Results.modrate.EVs = PullEV(data);
    % For each cell, pull out FR for given epochs (6 seconds)
for iL = 1:length(data)
    Results.modrate.FR{iL} = data{iL}.psth(:,100:399);
end
Results.modrate.FR = Results.modrate.FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(data)
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
Results.modrate.Side = PullSide(data);
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
for iJ = 1:size(data,1)
    ChosenOffer{iJ}(:,1) = data{iJ}.vars(:,9);
    for iK = 1:size(data{iJ}.vars,1)
        if data{iJ}.vars(iK,9) == 1
            ChosenOffer{iJ}(iK,2) = data{iJ}.vars(iK,3);
            ChosenOffer{iJ}(iK,3) = data{iJ}.vars(iK,6);
        elseif data{iJ}.vars(iK,9) == 0
            ChosenOffer{iJ}(iK,2) = data{iJ}.vars(iK,6);
            ChosenOffer{iJ}(iK,3) = data{iJ}.vars(iK,3);
        end
    end
    ChosenOffer{iJ}(:,4) = data{iJ}.vars(:,8);%chosen side
    ChosenOffer{iJ}(:,5) = data{iJ}.vars(:,10);%outcome
end
% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.FRcol{iL},2)
        [Results.modrate.r.Choice(iL,iK),Results.modrate.p.Choice(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,1)); %Chosen Offer
        [Results.modrate.r.ChoiceVal(iL,iK),Results.modrate.p.ChoiceVal(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,2)); %Chosen Offer Value
        [Results.modrate.r.UnChoiceVal(iL,iK),Results.modrate.p.UnChoiceVal(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,3)); %Unchosen Offer Value
        [Results.modrate.r.ChoiceSide(iL,iK),Results.modrate.p.ChoiceSide(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,4)); %Chosen Offer side
        [Results.modrate.r.Outcome(iL,iK),Results.modrate.p.Outcome(iL,iK)] = corr(Results.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,5)); %Outcome
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.Choice,2)
    Results.modrate.rate.Choice(1,iL) = (sum(Results.modrate.p.Choice(:,iL)<.05)/length(Results.modrate.p.Choice))*100; %Chosen Offer
    Results.modrate.rate.ChoiceVal(1,iL) = (sum(Results.modrate.p.ChoiceVal(:,iL)<.05)/length(Results.modrate.p.ChoiceVal))*100; %Chosen Offer Value
    Results.modrate.rate.UnChoiceVal(1,iL) = (sum(Results.modrate.p.UnChoiceVal(:,iL)<.05)/length(Results.modrate.p.UnChoiceVal))*100; %Unchosen Offer Value
    Results.modrate.rate.ChoiceSide(1,iL) = (sum(Results.modrate.p.ChoiceSide(:,iL)<.05)/length(Results.modrate.p.ChoiceSide))*100; %Chosen Offer side
    Results.modrate.rate.Outcome(1,iL) = (sum(Results.modrate.p.Outcome(:,iL)<.05)/length(Results.modrate.p.Outcome))*100; %Outcome
end

%% Epoch-specific
%     % For each cell, pull out FR for given epochs (6 seconds)
%     % OOORRR!!!
%     % just average the results from above based on contents of bins
% if Habiba == 0
%     Results.modrate.rate.E1EV1 = nanmean(Results.modrate.rate.EV1(:,11:15),2); % bin 11:15
%     Results.modrate.rate.E1Side1 = nanmean(Results.modrate.rate.Side1(:,11:15),2); % bin 11:15
%     Results.modrate.rate.E2EV1 = nanmean(Results.modrate.rate.EV1(:,21:25),2); % bin 21:25
%     Results.modrate.rate.E2EV2 = nanmean(Results.modrate.rate.EV2(:,21:25),2); % bin 21:25
%     Results.modrate.rate.E2Side = nanmean(Results.modrate.rate.Side1(:,21:25),2); % bin 21:25
%     Results.modrate.rate.E0Choice = nanmean(Results.modrate.rate.Choice(:,30:32),2); % bin 30:32
%     Results.modrate.rate.E0ChoiceVal = nanmean(Results.modrate.rate.ChoiceVal(:,30:32),2); % bin 30:32
%     Results.modrate.rate.E0UnChoiceVal = nanmean(Results.modrate.rate.UnChoiceVal(:,30:32),2); % bin 30:32
%     Results.modrate.rate.E0ChoiceSide = nanmean(Results.modrate.rate.ChoiceSide(:,30:32),2); % bin 30:32
%     Results.modrate.rate.E3Choice = nanmean(Results.modrate.rate.Choice(:,33:37),2); % bin 33:37
%     Results.modrate.rate.E3ChoiceVal = nanmean(Results.modrate.rate.ChoiceVal(:,33:37),2); % bin 33:37
%     Results.modrate.rate.E3UnChoiceVal = nanmean(Results.modrate.rate.UnChoiceVal(:,33:37),2); % bin 33:37
%     Results.modrate.rate.E3ChoiceSide = nanmean(Results.modrate.rate.ChoiceSide(:,33:37),2); % bin 33:37
%     Results.modrate.rate.Outcome = nanmean(Results.modrate.rate.Outcome(:,33:37),2); % bin 33:37
% elseif Habiba == 1
%     Results.modrate.rate.E1EV1 = nanmean(Results.modrate.rate.EV1(:,11:15),2); % bin 11:15
%     Results.modrate.rate.E1Side1 = nanmean(Results.modrate.rate.Side1(:,11:15),2); % bin 11:15
%     Results.modrate.rate.E2EV1 = nanmean(Results.modrate.rate.EV1(:,19:23),2); % bin 19:23
%     Results.modrate.rate.E2EV2 = nanmean(Results.modrate.rate.EV2(:,19:23),2); % bin 19:23
%     Results.modrate.rate.E2Side = nanmean(Results.modrate.rate.Side1(:,19:23),2); % bin 19:23
%     Results.modrate.rate.E0Choice = nanmean(Results.modrate.rate.Choice(:,25:27),2); % bin 25:27
%     Results.modrate.rate.E0ChoiceVal = nanmean(Results.modrate.rate.ChoiceVal(:,25:27),2); % bin 25:27
%     Results.modrate.rate.E0UnChoiceVal = nanmean(Results.modrate.rate.UnChoiceVal(:,25:27),2); % bin 25:27
%     Results.modrate.rate.E0ChoiceSide = nanmean(Results.modrate.rate.ChoiceSide(:,25:27),2); % bin 25:27
%     Results.modrate.rate.E3Choice = nanmean(Results.modrate.rate.Choice(:,28:32),2); % bin 28:32
%     Results.modrate.rate.E3ChoiceVal = nanmean(Results.modrate.rate.ChoiceVal(:,28:32),2); % bin 28:32
%     Results.modrate.rate.E3UnChoiceVal = nanmean(Results.modrate.rate.UnChoiceVal(:,28:32),2); % bin 28:32
%     Results.modrate.rate.E3ChoiceSide = nanmean(Results.modrate.rate.ChoiceSide(:,28:32),2); % bin 28:32
%     Results.modrate.rate.Outcome = nanmean(Results.modrate.rate.Outcome(:,28:32),2); % bin 28:32
% end
% x=6/length(Results.modrate.rate.EV1);
% Results.modrate.xticks = (-1:x:(5-x));

%% Epoch1
for iL = 1:length(data)
    Results.modrate.E1FR{iL} = data{iL}.psth(:,155:180);
end
Results.modrate.E1FR = Results.modrate.E1FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(data)
    Results.modrate.E1FRcol{iL} = FR_CollapseBins(Results.modrate.E1FR{iL},col*5);
end
Results.modrate.E1FRcol = Results.modrate.E1FRcol';

% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.E1FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.E1FRcol{iL},2)
        [Results.modrate.r.E1EV1(iL,iK),Results.modrate.p.E1EV1(iL,iK)] = corr(Results.modrate.E1FRcol{iL}(:,iK),Results.modrate.EVs{iL}(:,1)); %EV1
        [Results.modrate.r.E1Side1(iL,iK),Results.modrate.p.E1Side1(iL,iK)] = corr(Results.modrate.E1FRcol{iL}(:,iK),Results.modrate.Side{iL}(:,1)); %Side of First
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.E1EV1,2)
    Results.modrate.rate.E1EV1(1,iL) = (sum(Results.modrate.p.E1EV1(:,iL)<.05)/length(Results.modrate.p.E1EV1))*100; %EV1
    Results.modrate.rate.E1Side1(1,iL) = (sum(Results.modrate.p.E1Side1(:,iL)<.05)/length(Results.modrate.p.E1Side1))*100; %Side of first
end

%% Epoch2
if token == 1 
    for iL = 1:length(data)
        Results.modrate.E2FR{iL} = data{iL}.psth(:,193:217);% ALL but Habiba: 205:230
    end
elseif token == 0
    for iL = 1:length(data)
        Results.modrate.E2FR{iL} = data{iL}.psth(:,205:230);% ALL but Habiba: 205:230
    end
end
Results.modrate.E2FR = Results.modrate.E2FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(data)
    Results.modrate.E2FRcol{iL} = FR_CollapseBins(Results.modrate.E2FR{iL},col*5);
end
Results.modrate.E2FRcol = Results.modrate.E2FRcol';

%Get side of 2nd Offer
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.vars,1)
        if data{iJ}.vars(iK,7) == 1 %if side of first was "left"
            E2Side{iJ}(iK,1) = 0; %side of second is "right"
        elseif data{iJ}.vars(iK,7) == 0 %if side of first was "right"
            E2Side{iJ}(iK,1) = 1; %side of second was "left"
        end
    end
end
E2Side=E2Side';
% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.E2FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.E2FRcol{iL},2)
        [Results.modrate.r.E2EV1(iL,iK),Results.modrate.p.E2EV1(iL,iK)] = corr(Results.modrate.E2FRcol{iL}(:,iK),Results.modrate.EVs{iL}(:,1)); %EV1
        [Results.modrate.r.E2EV1(iL,iK),Results.modrate.p.E2EV2(iL,iK)] = corr(Results.modrate.E2FRcol{iL}(:,iK),Results.modrate.EVs{iL}(:,2)); %EV2
        [Results.modrate.r.E2Side(iL,iK),Results.modrate.p.E2Side(iL,iK)] = corr(Results.modrate.E2FRcol{iL}(:,iK),E2Side{iL}(:,1)); %Offer2 side
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.E2EV1,2)
    Results.modrate.rate.E2EV1(1,iL) = (sum(Results.modrate.p.E2EV1(:,iL)<.05)/length(Results.modrate.p.E2EV1))*100; %EV1
    Results.modrate.rate.E2EV2(1,iL) = (sum(Results.modrate.p.E2EV2(:,iL)<.05)/length(Results.modrate.p.E2EV2))*100; %EV2
    Results.modrate.rate.E2Side(1,iL) = (sum(Results.modrate.p.E2Side(:,iL)<.05)/length(Results.modrate.p.E2Side))*100; %Offer2 side
end

%% Epoch3 - postchoice
if token == 1
    for iL = 1:length(data)
        Results.modrate.E3FR{iL} = data{iL}.psth(:,240:265); % ALL but Habiba: 265:290
    end
elseif token == 0
    for iL = 1:length(data)
        Results.modrate.E3FR{iL} = data{iL}.psth(:,265:290); % ALL but Habiba: 265:290
    end
end
Results.modrate.E3FR = Results.modrate.E3FR';

% collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(data)
    Results.modrate.E3FRcol{iL} = FR_CollapseBins(Results.modrate.E3FR{iL},col*5);
end
Results.modrate.E3FRcol = Results.modrate.E3FRcol';

for iJ = 1:size(data,1)
    ChosenOffer{iJ}(:,1) = data{iJ}.vars(:,9);
    for iK = 1:size(data{iJ}.vars,1)
        if data{iJ}.vars(iK,9) == 1
            ChosenOffer{iJ}(iK,2) = data{iJ}.vars(iK,3);
            ChosenOffer{iJ}(iK,3) = data{iJ}.vars(iK,6);
        elseif data{iJ}.vars(iK,9) == 0
            ChosenOffer{iJ}(iK,2) = data{iJ}.vars(iK,6);
            ChosenOffer{iJ}(iK,3) = data{iJ}.vars(iK,3);
        end
    end
    ChosenOffer{iJ}(:,4) = data{iJ}.vars(:,8);%chosen side
    ChosenOffer{iJ}(:,5) = data{iJ}.vars(:,10);%outcome
end

% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(Results.modrate.E3FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.E3FRcol{iL},2)
        [Results.modrate.r.E3Choice(iL,iK),Results.modrate.p.E3Choice(iL,iK)] = corr(Results.modrate.E3FRcol{iL}(:,iK),ChosenOffer{iL}(:,1)); %Chosen Offer
        [Results.modrate.r.E3ChoiceVal(iL,iK),Results.modrate.p.E3ChoiceVal(iL,iK)] = corr(Results.modrate.E3FRcol{iL}(:,iK),ChosenOffer{iL}(:,2)); %Chosen Offer Value
        [Results.modrate.r.E3UnChoiceVal(iL,iK),Results.modrate.p.E3UnChoiceVal(iL,iK)] = corr(Results.modrate.E3FRcol{iL}(:,iK),ChosenOffer{iL}(:,3)); %Unchosen Offer Value
        [Results.modrate.r.E3ChoiceSide(iL,iK),Results.modrate.p.E3ChoiceSide(iL,iK)] = corr(Results.modrate.E3FRcol{iL}(:,iK),ChosenOffer{iL}(:,4)); %Chosen Offer side
        [Results.modrate.r.Out(iL,iK),Results.modrate.p.Out(iL,iK)] = corr(Results.modrate.E3FRcol{iL}(:,iK),ChosenOffer{iL}(:,5)); %Outcome
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.E3Choice,2)
    Results.modrate.rate.E3Choice(1,iL) = (sum(Results.modrate.p.E3Choice(:,iL)<.05)/length(Results.modrate.p.E3Choice))*100; %Chosen Offer
    Results.modrate.rate.E3ChoiceVal(1,iL) = (sum(Results.modrate.p.E3ChoiceVal(:,iL)<.05)/length(Results.modrate.p.E3ChoiceVal))*100; %Chosen Offer Value
    Results.modrate.rate.E3UnChoiceVal(1,iL) = (sum(Results.modrate.p.E3UnChoiceVal(:,iL)<.05)/length(Results.modrate.p.E3UnChoiceVal))*100; %Unchosen Offer Value
    Results.modrate.rate.E3ChoiceSide(1,iL) = (sum(Results.modrate.p.E3ChoiceSide(:,iL)<.05)/length(Results.modrate.p.E3ChoiceSide))*100; %Chosen Offer side
    Results.modrate.rate.Out(1,iL) = (sum(Results.modrate.p.Out(:,iL)<.05)/length(Results.modrate.p.Outcome))*100; %Outcome
end

%% Epoch Prechoice
if token == 1
    for iL = 1:length(data)
        Results.modrate.E0FR{iL} = data{iL}.psth(:,225:240); % ALL but Habiba: 250:265
    end
elseif token == 0
    for iL = 1:length(data)
        Results.modrate.E0FR{iL} = data{iL}.psth(:,250:265); % ALL but Habiba: 250:265
    end
end
Results.modrate.E0FR = Results.modrate.E0FR';

    % collapse the FR into given bin (200ms?) for every trial
for iL = 1:length(data)
    Results.modrate.E0FRcol{iL} = FR_CollapseBins(Results.modrate.E0FR{iL},col*3);
end
Results.modrate.E0FRcol = Results.modrate.E0FRcol';

for iL = 1:length(Results.modrate.E0FRcol) %for the number of cells
    for iK = 1:size(Results.modrate.E0FRcol{iL},2)
        [Results.modrate.r.E0Choice(iL,iK),Results.modrate.p.E0Choice(iL,iK)] = corr(Results.modrate.E0FRcol{iL}(:,iK),ChosenOffer{iL}(:,1)); %Chosen Offer
        [Results.modrate.r.E0ChoiceVal(iL,iK),Results.modrate.p.E0ChoiceVal(iL,iK)] = corr(Results.modrate.E0FRcol{iL}(:,iK),ChosenOffer{iL}(:,2)); %Chosen Offer Val
        [Results.modrate.r.E0UnChoiceVal(iL,iK),Results.modrate.p.E0UnChoiceVal(iL,iK)] = corr(Results.modrate.E0FRcol{iL}(:,iK),ChosenOffer{iL}(:,3)); %Unchosen Offer Val
        [Results.modrate.r.E0ChoiceSide(iL,iK),Results.modrate.p.E0ChoiceSide(iL,iK)] = corr(Results.modrate.E0FRcol{iL}(:,iK),ChosenOffer{iL}(:,4)); %Chosen Offer side
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(Results.modrate.p.E0Choice,2)
    Results.modrate.rate.E0Choice(1,iL) = (sum(Results.modrate.p.E0Choice(:,iL)<.05)/length(Results.modrate.p.E0Choice))*100; %Chosen Offer
    Results.modrate.rate.E0ChoiceVal(1,iL) = (sum(Results.modrate.p.E0ChoiceVal(:,iL)<.05)/length(Results.modrate.p.E0ChoiceVal))*100; %Chosen Offer Val
    Results.modrate.rate.E0UnChoiceVal(1,iL) = (sum(Results.modrate.p.E0UnChoiceVal(:,iL)<.05)/length(Results.modrate.p.E0UnChoiceVal))*100; %Unchosen Offer Val
    Results.modrate.rate.E0ChoiceSide(1,iL) = (sum(Results.modrate.p.E0ChoiceSide(:,iL)<.05)/length(Results.modrate.p.E0ChoiceSide))*100; %Unchosen Offer side
end
clear ChosenOffer data iJ iK iL E2Side;

end