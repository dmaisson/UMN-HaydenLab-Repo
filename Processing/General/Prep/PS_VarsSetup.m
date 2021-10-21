function [trial,spikes] = PS_VarsSetup(input,tokentask)

vars = input.vars;
psth = input.psth;
trial(1:size(vars,1),1:23) = NaN;

for iK = 1:size(vars,1)
    trial(iK,1) = vars(iK,3); %EV1
    trial(iK,2) = vars(iK,6); %EV2
    if vars(iK,2) >= vars(iK,5)
        trial(iK,10) = vars(iK,2); %larger size
        trial(iK,11) = vars(iK,5); %smaller size
    elseif vars(iK,2) <= vars(iK,5)
        trial(iK,10) = vars(iK,5); %larger size
        trial(iK,11) = vars(iK,2); %smaller size
    end
    if vars(iK,9) == 1 %if choice was the first offer
        trial(iK,3) = vars(iK,3); %chosen EV
        trial(iK,4) = vars(iK,6); %unchosen EV
        trial(iK,8) = vars(iK,3); %Chosen EV1 (0 if EV2 was chosen)
        trial(iK,9) = 0; %Chosen EV2 (0 if EV1 was chosen)
        trial(iK,12) = vars(iK,2); %chosen Size
        trial(iK,13) = vars(iK,5); %unchosen Size
    elseif vars(iK,9) == 0 %if choice was the second offer
        trial(iK,3) = vars(iK,6); %chosen EV
        trial(iK,4) = vars(iK,3); %unchosen EV
        trial(iK,8) = 0; %Chosen EV1 (0 if EV2 was chosen)
        trial(iK,9) = vars(iK,6); %Chosen EV2 (0 if EV1 was chosen)
        trial(iK,12) = vars(iK,5); %chosen Size
        trial(iK,13) = vars(iK,2); %unchosen Size
    end
    trial(iK,5) = (trial(iK,3)) + (trial(iK,4)); %Total value (sum)
    trial(iK,6) = (trial(iK,3)) - (trial(iK,4)); %value difference (chosen - unchosen)
    trial(iK,7) = (trial(iK,4)) / (trial(iK,3)); %ratio, unchosen/chosen
    trial(iK,14) = (trial(iK,12)) + (trial(iK,13)); %Size sum
    trial(iK,15) = (trial(iK,12)) / (trial(iK,13)); %ratio, unchosen/chosen size
    trial(iK,16) = (trial(iK,12)) - (trial(iK,13)); %size difference (chosen - unchosen)
    trial(iK,17) = (trial(iK,11)) / (trial(iK,10)); %ratio, smaller/larger size
    trial(iK,18) = (trial(iK,10)) - (trial(iK,11)); %size difference (max-min)
    if vars(iK,7) == 1 %if first was left
        trial(iK,19) = vars(iK,3); %EVleft
        trial(iK,20) = vars(iK,6); % EVright
    elseif vars(iK,7) == 0 %if first was right
        trial(iK,19) = vars(iK,6); %EVleft
        trial(iK,20) = vars(iK,3); % EVright
    end
    if vars(iK,8) == 1 %if choice was left
        trial(iK,21) = trial(iK,19); %EVleft chosen
        trial(iK,22) = 0; %EVright chosen
    elseif vars(iK,8) == 0 %if choice was right
        trial(iK,21) = 0; %EVleft chosen
        trial(iK,22) = trial(iK,20); %EVright chosen
    end
    trial(iK,23) = vars(iK,8); %choice
end

spikes(1:size(input.psth,1),1:6) = 0;

for iK = 1:size(spikes,1)
    if tokentask == 1
%         spikes(iK,1) = FR_CollapseBins(psth(iK,125:149),25);%.5s before until start (500ms)
        spikes(iK,1) = FR_CollapseBins(psth(iK,150:174),25);%start until .5s after (500ms)
        spikes(iK,2) = FR_CollapseBins(psth(iK,176:187),12);%.25s before offer1 until offer2 (250ms)
        spikes(iK,3) = FR_CollapseBins(psth(iK,188:212),25);% offer2 until .5s after offer2 (500ms)
        spikes(iK,4) = FR_CollapseBins(psth(iK,213:224),12);%.25s before choice until choice (250ms)
        spikes(iK,5) = FR_CollapseBins(psth(iK,225:249),25);%choice until .5s after (500ms)
        spikes(iK,6) = FR_CollapseBins(psth(iK,250:274),25);%.5s after choice until 1s after(500ms)
    elseif tokentask == 0
%         spikes(iK,1) = FR_CollapseBins(psth(iK,125:149),25);%.5s before until start (500ms)
        spikes(iK,1) = FR_CollapseBins(psth(iK,150:174),25);%start until .5s after (500ms)
        spikes(iK,2) = FR_CollapseBins(psth(iK,188:199),12);%.25s before offer1 until offer2 (250ms)
        spikes(iK,3) = FR_CollapseBins(psth(iK,200:224),25);% offer2 until .5s after offer2 (500ms)
        spikes(iK,4) = FR_CollapseBins(psth(iK,238:249),12);%.25s before choice until choice (250ms)
        spikes(iK,5) = FR_CollapseBins(psth(iK,250:274),25);%choice until .5s after (500ms)
        spikes(iK,6) = FR_CollapseBins(psth(iK,275:299),25);%.5s after choice until 1s after(500ms)
    end
end

% Exclude trials with a safe offer
for iL = 1:size(trial,1) %cycle through the cell
    for iK = 1:size(trial,2) %cycle through each trial in the cell
        if isinf(trial(iL,iK)) || isnan(trial(iL,iK))
            trial(iL,:)=NaN; %remove value
            spikes(iL,:)=NaN; %remove value
        end
    end
end

end
