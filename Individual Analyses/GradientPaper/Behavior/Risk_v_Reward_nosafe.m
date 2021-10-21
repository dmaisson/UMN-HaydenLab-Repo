function [BinsSm,BinsMed,BinsLar] = Risk_v_Reward_nosafe(data)
%Risk_v_Reward
%% Define working data set
for iL = 1:length(data) %cycle through the cell
    for iK = 1:length(data{iL}.vars) %cycle through each trial in the cell
        Tsafe{iL}.vars(iK,:)=data{iL}.vars(iK,:); %fill the Tsafe indexer
    end
end
Tsafe = Tsafe'; %flip axes
%% Remove trials with probability of 0 for either of the offers
for iL = 1:length(Tsafe)
    for iK = 1:length(Tsafe{iL}.vars)
        if Tsafe{iL}.vars(iK,1)==0 || Tsafe{iL}.vars(iK,4)==0 %if the prob is 0 (guaranteed loss)
            Tsafe{iL}.vars(iK,:)=NaN; %remove value
        end
    end
end

%% classify the trials
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
        elseif (Tsafe{iL}.vars(iK,2) == 1 && Tsafe{iL}.vars(iK,5) == 2) || (Tsafe{iL}.vars(iK,5) == 1 && Tsafe{iL}.vars(iK,2) == 2) %if one is sm and one is med
            Tsafe{iL}.vars(iK,12) = 1; %Flag as "SvM"
        elseif (Tsafe{iL}.vars(iK,2) == 2 && Tsafe{iL}.vars(iK,5) == 3) || (Tsafe{iL}.vars(iK,5) == 2 && Tsafe{iL}.vars(iK,2) == 3) %if one is med and one is lar
            Tsafe{iL}.vars(iK,12) = 2; %Flag as "MvL"
        elseif (Tsafe{iL}.vars(iK,2) == 1 && Tsafe{iL}.vars(iK,5) == 3) || (Tsafe{iL}.vars(iK,5) == 3 && Tsafe{iL}.vars(iK,2) == 1) %if one is med and one is lar
            Tsafe{iL}.vars(iK,12) = 3; %Flag as "SvL"
        end
    end
end

%% Likelihood of choosing risky option
% Per EV bin, what percent of the offers selected are risky?

% separate Trials
for iL = 1:length(Tsafe)
    for iK = 1:length(Tsafe{iL}.vars)
        Sm{iL}(iK,1:12) = NaN; %fill an empty array: actually SvM
        Med{iL}(iK,1:12) = NaN; %fill an empty array: actually MvL
        Lar{iL}(iK,1:12) = NaN; %fill an empty array: actually SvL
        if Tsafe{iL}.vars(iK,12) == 1
            Sm{iL}(iK,:) = Tsafe{iL}.vars(iK,:);
        elseif Tsafe{iL}.vars(iK,12) == 2
            Med{iL}(iK,:) = Tsafe{iL}.vars(iK,:);
        elseif Tsafe{iL}.vars(iK,12) == 3
            Lar{iL}(iK,:) = Tsafe{iL}.vars(iK,:);
        end
    end
end

Sm = Sm';
Med = Med'; %flip the axes
Lar = Lar'; %flip the axes

clear iK iL Tsafe;

%% pull out EVs 1 and 2, group, choice, and chosen EV
for iL = 1:length(Lar)
    Lar{iL,2}(:,1) = Lar{iL,1}(:,3); %EV1
    Lar{iL,2}(:,2) = Lar{iL,1}(:,6); %EV2
    Lar{iL,2}(:,3) = Lar{iL,1}(:,12); %group (SvM, MvL, SvL)
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
for iL = 1:length(Sm)
    Sm{iL,2}(:,1) = Sm{iL,1}(:,3);
    Sm{iL,2}(:,2) = Sm{iL,1}(:,6);
    Sm{iL,2}(:,3) = Sm{iL,1}(:,12);
    Sm{iL,2}(:,4) = Sm{iL,1}(:,9);
    Sm{iL,2}(:,5) = Sm{iL,1}(:,2);
    Sm{iL,2}(:,6) = Sm{iL,1}(:,5);
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

for iK = 1:length(Sm)
    for iL = 1:length(Sm{iK,2})
        if Sm{iK,2}(iL,5) > Sm{iK,2}(iL,6) %if Rwd1 is the larger
            Sm{iK,2}(iL,7) = (Sm{iK,2}(iL,1) - Sm{iK,2}(iL,2)); %subtract EV2 from EV1
        elseif Sm{iK,2}(iL,6) > Sm{iK,2}(iL,5) %if Rwd21 is the larger
            Sm{iK,2}(iL,7) = (Sm{iK,2}(iL,2) - Sm{iK,2}(iL,1)); %subtract EV1 from EV2
        end
        if Sm{iK,2}(iL,4) == 1 %if choice was 1st offer
            Sm{iK,2}(iL,1) = Sm{iK,2}(iL,1); %EV of interest is 1st offer EV
        elseif Sm{iK,2}(iL,4) == 2 %if choice was 2nd offer
            Sm{iK,2}(iL,1) = Sm{iK,2}(iL,2); %EV of interest is 2nd offer EV
        end
    end
end
for iK = 1:length(Lar)
    for iL = 1:length(Lar{iK,2})
        if Lar{iK,2}(iL,5) > Lar{iK,2}(iL,6) %if Rwd1 is the larger
            Lar{iK,2}(iL,7) = (Lar{iK,2}(iL,1) - Lar{iK,2}(iL,2)); %subtract EV2 from EV1
        elseif Lar{iK,2}(iL,6) > Lar{iK,2}(iL,5) %if Rwd21 is the larger
            Lar{iK,2}(iL,7) = (Lar{iK,2}(iL,2) - Lar{iK,2}(iL,1)); %subtract EV1 from EV2
        end
        if Lar{iK,2}(iL,4) == 1 %if choice was 1st offer
            Lar{iK,2}(iL,1) = Lar{iK,2}(iL,1); %EV of interest is 1st offer EV
        elseif Lar{iK,2}(iL,4) == 2 %if choice was 2nd offer
            Lar{iK,2}(iL,1) = Lar{iK,2}(iL,2); %EV of interest is 2nd offer EV
        end
    end
end
for iK = 1:length(Med)
    for iL = 1:length(Med{iK,2})
        if Med{iK,2}(iL,5) > Med{iK,2}(iL,6) %if Rwd1 is the larger
            Med{iK,2}(iL,7) = (Med{iK,2}(iL,1) - Med{iK,2}(iL,2)); %subtract EV2 from EV1
        elseif Med{iK,2}(iL,6) > Med{iK,2}(iL,5) %if Rwd21 is the larger
            Med{iK,2}(iL,7) = (Med{iK,2}(iL,2) - Med{iK,2}(iL,1)); %subtract EV1 from EV2
        end
        if Med{iK,2}(iL,4) == 1 %if choice was 1st offer
            Med{iK,2}(iL,1) = Med{iK,2}(iL,1); %EV of interest is 1st offer EV
        elseif Med{iK,2}(iL,4) == 2 %if choice was 2nd offer
            Med{iK,2}(iL,1) = Med{iK,2}(iL,2); %EV of interest is 2nd offer EV
        end
    end
end

%%%%%%%
% OUTPUT from above
% Recoded EV column to be the "EV of interest" (i.e. the EV for the chosen offer)
%%%%%%%
%% Bin the EVs choices
% build a binning matrix
BinsSm=(-1:.25:2)';
BinsMed=(-2:.25:2)';
BinsLar=(-1:.25:3)';

for iL = 1:length(BinsLar)
    BinsLar(iL,2) = 0;
    BinsMed(iL,2) = 0;
    BinsLar(iL,3) = 0;
    BinsMed(iL,3) = 0;
    BinsSm(iL,2) = 0;
    BinsSm(iL,3) = 0;
end

for iL = 1:length(BinsSm)%for each bin value
   for iK = 1:length(Sm)% cycle through the cells
       for iJ = 1:length(Sm{iK,2}) %cycle through each trial for each cell
           if ((Sm{iK,2}(iJ,5) > Sm{iK,2}(iJ,6)) && Sm{iK,2}(iJ,4) == 1) || ((Sm{iK,2}(iJ,6) > Sm{iK,2}(iJ,5)) && Sm{iK,2}(iJ,4) == 2) %check if the chosen offer on that trial was the Larger (sz Med one)
              if (Sm{iK,2}(iJ,7) > BinsSm(iL)) && (Sm{iK,2}(iJ,7) < BinsSm(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsSm(iL,2) = BinsSm(iL,2) + 1; %increment the count of risky choices in that EV bin
              end
           elseif ((Sm{iK,2}(iJ,5) > Sm{iK,2}(iJ,6)) && Sm{iK,2}(iJ,4) == 2) || ((Sm{iK,2}(iJ,6) > Sm{iK,2}(iJ,5)) && Sm{iK,2}(iJ,4) == 1)
              if (Sm{iK,2}(iJ,7) > BinsSm(iL)) && (Sm{iK,2}(iJ,7) < BinsSm(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsSm(iL,3) = BinsSm(iL,3) + 1; %increment the count of risky choices in that EV bin
              end
           end
       end
   end
   BinsSm(iL,3)=((BinsSm(iL,2)/(BinsSm(iL,3) + BinsSm(iL,2))*100));
end
     
for iL = 1:length(BinsMed)%for each bin value
   for iK = 1:length(Med)% cycle through the cells
       for iJ = 1:length(Med{iK,2}) %cycle through each trial for each cell
           if ((Med{iK,2}(iJ,5) > Med{iK,2}(iJ,6)) && Med{iK,2}(iJ,4) == 1) || ((Med{iK,2}(iJ,6) > Med{iK,2}(iJ,5)) && Med{iK,2}(iJ,4) == 2) %check if the chosen offer on that trial was the Larger (sz Med one)
              if (Med{iK,2}(iJ,7) > BinsMed(iL)) && (Med{iK,2}(iJ,7) < BinsMed(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsMed(iL,2) = BinsMed(iL,2) + 1; %increment the count of risky choices in that EV bin
              end
           elseif ((Med{iK,2}(iJ,5) > Med{iK,2}(iJ,6)) && Med{iK,2}(iJ,4) == 2) || ((Med{iK,2}(iJ,6) > Med{iK,2}(iJ,5)) && Med{iK,2}(iJ,4) == 1)
              if (Med{iK,2}(iJ,7) > BinsMed(iL)) && (Med{iK,2}(iJ,7) < BinsMed(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsMed(iL,3) = BinsMed(iL,3) + 1; %increment the count of risky choices in that EV bin
              end
           end
       end
   end
   BinsMed(iL,3)=((BinsMed(iL,2)/(BinsMed(iL,3) + BinsMed(iL,2))*100));
end
     
for iL = 1:length(BinsLar)%for each bin value
   for iK = 1:length(Lar)% cycle through the cells
       for iJ = 1:length(Lar{iK,2}) %cycle through each trial for each cell
           if (Lar{iK,2}(iJ,5) > Lar{iK,2}(iJ,6)) && (Lar{iK,2}(iJ,4) == 1) || (Lar{iK,2}(iJ,6) > Lar{iK,2}(iJ,5)) && (Lar{iK,2}(iJ,4) == 2) %check if the chosen offer on that trial was the Larger (sz Med one)
              if (Lar{iK,2}(iJ,7) > BinsLar(iL)) && (Lar{iK,2}(iJ,7) < BinsLar(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsLar(iL,2) = BinsLar(iL,2) + 1; %increment the count of risky choices in that EV bin
              end
           elseif (Lar{iK,2}(iJ,5) > Lar{iK,2}(iJ,6)) && (Lar{iK,2}(iJ,4) == 2) || (Lar{iK,2}(iJ,6) > Lar{iK,2}(iJ,5)) && (Lar{iK,2}(iJ,4) == 1)
              if (Lar{iK,2}(iJ,7) > BinsLar(iL)) && (Lar{iK,2}(iJ,7) < BinsLar(iL+1)) %if the associated EV for that risky choice was between the value of the current bin and next
                   BinsLar(iL,3) = BinsLar(iL,3) + 1; %increment the count of risky choices in that EV bin
              end
           end
       end
   end
   BinsLar(iL,3)=((BinsLar(iL,2)/(BinsLar(iL,3) + BinsLar(iL,2))*100));
end

clear iJ iK iL;
end

