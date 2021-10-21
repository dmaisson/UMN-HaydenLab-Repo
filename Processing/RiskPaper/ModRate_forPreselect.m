function [filtered] = ModRate_forPreselect(input,col)
%%
% Rate of neurons modulated by offer over Trial Time
% Within each time bin, correlate FR with EV for each offer
    % For each cell, identify EV for each trial (EV1: column 3; EV2:
    % column 6
probs = PullProb(input);
    % For each cell, pull out FR for given epochs (6 seconds) & collapse
for iL = 1:length(input)
    FR{iL,1} = FR_CollapseBins(input{iL}.psth(:,100:399),col);
end

% Modulation by Chosen/Unchosen Value/Side and outcome
for iJ = 1:size(input,1)
    ChosenOffer{iJ}(:,1) = input{iJ}.vars(:,9);
    for iK = 1:size(input{iJ}.vars,1)
        if input{iJ}.vars(iK,9) == 1
            ChosenOffer{iJ}(iK,2) = input{iJ}.vars(iK,3);
            ChosenOffer{iJ}(iK,3) = input{iJ}.vars(iK,6);
        elseif input{iJ}.vars(iK,9) == 0
            ChosenOffer{iJ}(iK,2) = input{iJ}.vars(iK,6);
            ChosenOffer{iJ}(iK,3) = input{iJ}.vars(iK,3);
        end
    end
    ChosenOffer{iJ}(:,4) = input{iJ}.vars(:,8);%chosen side
    ChosenOffer{iJ}(:,5) = input{iJ}.vars(:,10);%outcome
end

% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(output.modrate.FRcol) %for the number of cells
    for iK = 1:size(output.modrate.FRcol{iL},2)
        [output.modrate.r.Choice(iL,iK),output.modrate.p.Choice(iL,iK)] = corr(output.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,1)); %Chosen Offer
        [output.modrate.r.ChoiceVal(iL,iK),output.modrate.p.ChoiceVal(iL,iK)] = corr(output.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,2)); %Chosen Offer Value
        [output.modrate.r.UnChoiceVal(iL,iK),output.modrate.p.UnChoiceVal(iL,iK)] = corr(output.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,3)); %Unchosen Offer Value
        [output.modrate.r.ChoiceSide(iL,iK),output.modrate.p.ChoiceSide(iL,iK)] = corr(output.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,4)); %Chosen Offer side
        [output.modrate.r.Outcome(iL,iK),output.modrate.p.Outcome(iL,iK)] = corr(output.modrate.FRcol{iL}(:,iK),ChosenOffer{iL}(:,5)); %Outcome
    end
end
% For each time bin (column), calculate the % of p-values that are < .05
for iL = 1:size(output.modrate.p.Choice,2)
    output.modrate.rate.Choice(1,iL) = (sum(output.modrate.p.Choice(:,iL)<.05)/length(output.modrate.p.Choice))*100; %Chosen Offer
    output.modrate.rate.ChoiceVal(1,iL) = (sum(output.modrate.p.ChoiceVal(:,iL)<.05)/length(output.modrate.p.ChoiceVal))*100; %Chosen Offer Value
    output.modrate.rate.UnChoiceVal(1,iL) = (sum(output.modrate.p.UnChoiceVal(:,iL)<.05)/length(output.modrate.p.UnChoiceVal))*100; %Unchosen Offer Value
    output.modrate.rate.ChoiceSide(1,iL) = (sum(output.modrate.p.ChoiceSide(:,iL)<.05)/length(output.modrate.p.ChoiceSide))*100; %Chosen Offer side
    output.modrate.rate.Outcome(1,iL) = (sum(output.modrate.p.Outcome(:,iL)<.05)/length(output.modrate.p.Outcome))*100; %Outcome
end

%% pull out the cells that are significantly modulated
for iJ = 1:length(input)
    if output.modrate.p.Choice(iJ,1) < .05
        filtered{iJ} = input{iJ};
    end
end
filtered = filtered(~cellfun(@isempty, filtered))';
