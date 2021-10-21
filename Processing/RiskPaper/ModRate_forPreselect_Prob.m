function [filtered] = ModRate_forPreselect_Prob(input,col)
%%
% Rate of neurons modulated by offer over Trial Time
% Within each time bin, correlate FR with EV for each offer
    % For each cell, identify EV for each trial (EV1: column 3; EV2:
    % column 6
probs = PullProb(input);
    % For each cell, pull out FR for given epochs (6 seconds) & collapse
for iL = 1:length(input)
    FR{iL,1} = FR_CollapseBins(input{iL}.psth(:,150:249),col);
end

% For every cell, for every trial, for every bin, correlate FR with EV
for iL = 1:length(FR) %for the number of cells
    for iK = 1:size(FR{iL},2)
        [~,p1(iL,iK)] = corr(FR{iL}(:,iK),probs{iL}(:,1)); %Prob1
        [~,p2(iL,iK)] = corr(FR{iL}(:,iK),probs{iL}(:,2)); %Prob2
    end
end

%% pull out the cells that are significantly modulated
for iJ = 1:size(p1,1)
    for iK = 1:size(p1,2)
        if p1(iJ,iK) < 0.05 || p2(iJ,iK) < 0.05
            filtered{iJ,1} = input{iJ};
        end
    end
end
filtered = filtered(~cellfun(@isempty, filtered));
