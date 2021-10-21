function [BinsMed,Bins] = Risk_v_Reward(data)
%Risk_v_Reward

% Grabs the StagOps trial data from trials that contain SAFE options

%% Isolate trials with risky value compared to safe value ONLY! or just take them all
for iL = 1:length(data) %cycle through the cell
    for iK = 1:length(data{iL}) %cycle through each trial in the cell
        if data{iL}(iK,2)==1 || data{iL}(iK,5)==1 %If either rwd size is small
            Tsafe{iL}.vars(iK,:)=data{iL}(iK,:); %fill the Tsafe indexer
        end
    end
end
Tsafe = Tsafe'; %flip axes

for iL = 1:length(Tsafe)
    for iK = 1:length(Tsafe{iL}.vars)
        if Tsafe{iL}.vars(iK,1)==0 || Tsafe{iL}.vars(iK,4)==0 %if the prob is 0 (guaranteed loss)
            Tsafe{iL}.vars(iK,:)=NaN; %remove value
        end
        if Tsafe{iL}.vars(iK,2)==1 && Tsafe{iL}.vars(iK,5)==1 %if prob is 1 for both options
            Tsafe{iL}.vars(iK,:)=NaN; %remove value
        end
    end
end

%% Did they choose the risky offer on that trial?; or 
% if chosen order (1 or 2) matches the order on which the offer did not
% have a reward probibility that was 1

% if column 1 was not 1, and choice was 1st
% or
% if column 2 was not 1, and choice was 2nd
% else = false
for iL = 1:length(Tsafe)
    for iK = 1:length(Tsafe{iL}.vars)
        if isnan(Tsafe{iL}.vars(iK,1))
            Tsafe{iL}.vars(iK,12) = NaN; %if it's empty, keep it empty
        elseif Tsafe{iL}.vars(iK,1) < 1 && Tsafe{iL}.vars(iK,9) == 1 %if it's not a guarantee, and chosen
            Tsafe{iL}.vars(iK,12) = 1; %Flag as "risky"
        elseif Tsafe{iL}.vars(iK,4) < 1 && (Tsafe{iL}.vars(iK,9) == 2 || Tsafe{iL}.vars(iK,9) == -1 || Tsafe{iL}.vars(iK,9) == 0)
            Tsafe{iL}.vars(iK,12) = 1; %same
        else
            Tsafe{iL}.vars(iK,12) = 0; %if either isn't true, flag it as "safe"
        end
    end
end

%% Likelihood of choosing risky option
% Per EV bin, what percent of the offers selected are risky?

% separate Trials
for iL = 1:length(Tsafe)
    for iK = 1:length(Tsafe{iL}.vars)
        Med{iL}(iK,1:12) = NaN; %fill an empty array
        Lar{iL}(iK,1:12) = NaN; %fill an empty array
        if (Tsafe{iL}.vars(iK,2) == 2 || Tsafe{iL}.vars(iK,5) == 2) %if either of the rwds are med
            Med{iL}(iK,:) = Tsafe{iL}.vars(iK,:); %stick it in the Med array
        elseif (Tsafe{iL}.vars(iK,2) == 3 || Tsafe{iL}.vars(iK,5) == 3) %if either of the rwds are lar
            Lar{iL}(iK,:) = Tsafe{iL}.vars(iK,:); %stick it in the Lar array
        end
    end
end

Med = Med'; %flip the axes
Lar = Lar'; %flip the axes

clear iK iL Tsafe;

%% pull out EVs 1 and 2, group, choice, and chosen EV
for iL = 1:length(Lar)
    Lar{iL,2}(:,1) = Lar{iL,1}(:,3); %EV1
    Lar{iL,2}(:,2) = Lar{iL,1}(:,6); %EV2
    Lar{iL,2}(:,3) = Lar{iL,1}(:,12); %group (safe or risky)
    Lar{iL,2}(:,4) = Lar{iL,1}(:,9); %choice (1st or 2nd)
    Lar{iL,2}(:,5) = Lar{iL,1}(:,2); %Size1
    Lar{iL,2}(:,6) = Lar{iL,1}(:,5); %Size2
end
for iL = 1:length(Med)
    Med{iL,2}(:,1) = Med{iL,1}(:,3);
    Med{iL,2}(:,2) = Med{iL,1}(:,6);
    Med{iL,2}(:,3) = Med{iL,1}(:,12);
    Med{iL,2}(:,4) = Med{iL,1}(:,9);
    Med{iL,2}(:,5) = Med{iL,1}(:,2);
    Med{iL,2}(:,6) = Med{iL,1}(:,5);
end

%%%%%%%
% VAR CODING for above output:
% EV1
% EV2
% Category (SvM, MvS, SvL)
% Choice (first or second)
% Size of first
% Size of Second
%%%%%%%

for iK = 1:length(Lar)
    for iL = 1:length(Lar{iK,2})
        if Lar{iK,2}(iL,1) == 1
            Lar{iK,2}(iL,1) = Lar{iK,2}(iL,2);
        end
    end
end
for iK = 1:length(Med)
    for iL = 1:length(Med{iK,2})
        if Med{iK,2}(iL,1) == 1
            Med{iK,2}(iL,1) = Med{iK,2}(iL,2);
        end
    end
end

%%%%%%%
% OUTPUT from above
% Recoded EV column to be the "EV of interest" (i.e. the EV for the chosen offer)
%%%%%%%
%% Bin the EVs choices
% build a binning matrix
BinsMed=(0:.25:4)';
Bins=(0:.25:4)';

for iL = 1:length(Bins)
    Bins(iL,2) = 0;
    BinsMed(iL,2) = 0;
    Bins(iL,3) = 0;
    BinsMed(iL,3) = 0;
end

% cycle binning matrix over dataset to count events within bin
for iL = 1:length(Bins)%for each bin value
    for iK = 1:length(Lar)% cycle through the cells
        for iJ = 1:length(Lar{iK,2}) %cycle through each trial for each cell
            if Lar{iK,2}(iJ,3) == 1 %check if the chosen offer on that trial was the risky one
                if Lar{iK,2}(iJ,1) > Bins(iL,1) && Lar{iK,2}(iJ,1) < Bins(iL+1,1) %if the associated EV for that risky choice was between the value of the current bin and next
                    Bins(iL,2) = Bins(iL,2) + 1; %increment the count of risky choices in that EV bin
                end
            elseif Lar{iK,2}(iJ,3) == 0 %check if the safe offer on that trial was chosen
                if Lar{iK,2}(iJ,1) > Bins(iL,1) && Lar{iK,2}(iJ,1) < Bins(iL+1,1) %if the associated EV for that safe choice was between the value of the current bin and next
                    Bins(iL,3) = Bins(iL,3) + 1; %increment the count of safe choices in that EV bin
                end
            end %then move to the next trial
        end %then move to the next cell
    end %then move to the next EV bin
     Bins(iL,3)=((Bins(iL,2)/(Bins(iL,3) + Bins(iL,2))*100)); %add the total number of safe choices to the total number of risky choices, and calculate the risk rate
end %finish looping

for iL = 1:length(BinsMed)%for each bin value
    for iK = 1:length(Med)% cycle through the cells
        for iJ = 1:length(Med{iK,2}) %cycle through each trial for each cell
            if Med{iK,2}(iJ,3) == 1 %check if the chosen offer on that trial was the risky one
                if Med{iK,2}(iJ,1) > BinsMed(iL,1) && Med{iK,2}(iJ,1) < BinsMed(iL+1,1) %if the associated EV for that risky choice was between the value of the current bin and next
                    BinsMed(iL,2) = BinsMed(iL,2) + 1; %increment the count of risky choices in that EV bin
                end
            elseif Med{iK,2}(iJ,3) == 0 %check if the safe offer on that trial was chosen
                if Med{iK,2}(iJ,1) > BinsMed(iL,1) && Med{iK,2}(iJ,1) < BinsMed(iL+1,1) %if the associated EV for that safe choice was between the value of the current bin and next
                    BinsMed(iL,3) = BinsMed(iL,3) + 1; %increment the count of safe choices in that EV bin
                end
            end %then move to the next trial
        end %then move to the next cell
    end %then move to the next EV bin
    BinsMed(iL,3)=((BinsMed(iL,2)/(BinsMed(iL,3) + BinsMed(iL,2))*100)); %add the total number of safe choices to the total number of risky choices, and calculate the risk rate
end %finish loopin

clear iJ iK iL;
end

