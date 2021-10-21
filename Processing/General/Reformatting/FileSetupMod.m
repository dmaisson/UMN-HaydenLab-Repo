OFC32_maya_switch = [];
%% Consolidate variables into a single struct
if isempty(OFC32_maya_switch)
    for iL = 1:length(data)
        x = data(iL);
        OFC32_maya_switch{iL}.psth = x.psth;
        OFC32_maya_switch{iL}.oldvars = x.vars;
%         OFC13_data32_Maya{iL}.names = x.names;
    end
elseif ~isempty(OFC32_maya_switch)
    c = length(OFC32_maya_switch);
    for iL = 1:length(data)
        x = data(iL);
        OFC32_maya_switch{iL+c}.psth = x.psth;
        OFC32_maya_switch{iL+c}.oldvars = x.vars;
%         OFC13_data32_Maya{iL+c}.names = x.names;
    end
    clear x;
end
%% Re-orient
OFC32_maya_switch = OFC32_maya_switch';

%% Restructure the Data
% Create NaN arrays to fill
for iL = 1:length(OFC32_maya_switch)
    for iK = 1:length(OFC32_maya_switch{iL}.oldvars)
        OFC32_maya_switch{iL}.vars(iK,1:10) = NaN;
        OFC32_maya_switch{iL}.psth(iK,:) = OFC32_maya_switch{iL}.oldpsth(iK,:);
    end
end

%% 1.identify 1st offer prob (col3  where col5 is left, etc)
for iL = 1:length(OFC32_maya_switch)
    for iK = 1:length(OFC32_maya_switch{iL}.oldvars)
        if OFC32_maya_switch{iL}.oldvars(iK,5) == 1 %if Left First
            OFC32_maya_switch{iL}.vars(iK,1) = OFC32_maya_switch{iL}.oldvars(iK,3); %prob1 is left offer prob
            OFC32_maya_switch{iL}.vars(iK,2) = OFC32_maya_switch{iL}.oldvars(iK,6); %rwd1 is left rwd
            if OFC32_maya_switch{iL}.vars(iK,2) == 2 %recode a rwd value of 2 (for large)
                OFC32_maya_switch{iL}.vars(iK,2) = 3; %to rwd value 2 (for large)
            elseif OFC32_maya_switch{iL}.vars(iK,2) == 1 %recode a rwd value of 1 (for medium)
                OFC32_maya_switch{iL}.vars(iK,2) = 2; %to rwd value 2 (for medium)
            elseif OFC32_maya_switch{iL}.vars(iK,2) == 0 %recode a rwd value of 0 (for small)
                OFC32_maya_switch{iL}.vars(iK,2) = 1; %to rwd value 1 (for small)
            end
            OFC32_maya_switch{iL}.vars(iK,3) = OFC32_maya_switch{iL}.vars(iK,1)*OFC32_maya_switch{iL}.vars(iK,2); %compute EV
            
            OFC32_maya_switch{iL}.vars(iK,4) = OFC32_maya_switch{iL}.oldvars(iK,4); %prob2 is right offer prob
            OFC32_maya_switch{iL}.vars(iK,5) = OFC32_maya_switch{iL}.oldvars(iK,7); %rwd2 is right rwd
            if OFC32_maya_switch{iL}.vars(iK,5) == 2 %same recode scheme as above
                OFC32_maya_switch{iL}.vars(iK,5) = 3;
            elseif OFC32_maya_switch{iL}.vars(iK,5) == 1
                OFC32_maya_switch{iL}.vars(iK,5) = 2;
            elseif OFC32_maya_switch{iL}.vars(iK,5) == 0
                OFC32_maya_switch{iL}.vars(iK,5) = 1;
            end
            OFC32_maya_switch{iL}.vars(iK,6) = OFC32_maya_switch{iL}.vars(iK,4)*OFC32_maya_switch{iL}.vars(iK,5); %compute EV

            OFC32_maya_switch{iL}.vars(iK,7) = OFC32_maya_switch{iL}.oldvars(iK,5); %direct for 1st offer side
            OFC32_maya_switch{iL}.vars(iK,8) = OFC32_maya_switch{iL}.oldvars(iK,8); %direct for chosen side
            
            %compare chosen side to the side of the first offer
            if OFC32_maya_switch{iL}.vars(iK,8) == OFC32_maya_switch{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                OFC32_maya_switch{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif OFC32_maya_switch{iL}.vars(iK,8) ~= OFC32_maya_switch{iL}.vars(iK,7)% if chosen side and 1st offer side are different
                OFC32_maya_switch{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
             
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if OFC32_maya_switch{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                OFC32_maya_switch{iL}.vars(iK,10) = 1; %code as 1
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 1 %if it was a loss
                OFC32_maya_switch{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if OFC32_maya_switch{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif OFC32_maya_switch{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,5); %exp rwd was rwd 2
                end
            end
            elseif safe == 0            
            if OFC32_maya_switch{iL}.oldvars(iK,9) == 1 %if it was a loss
                OFC32_maya_switch{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 2 || OFC32_maya_switch{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if OFC32_maya_switch{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif OFC32_maya_switch{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,5); %exp rwd was rwd 2
                end
            end
            end

        elseif OFC32_maya_switch{iL}.oldvars(iK,5) == 2 %if side of first is right...
            OFC32_maya_switch{iL}.vars(iK,1) = OFC32_maya_switch{iL}.oldvars(iK,4); %vars1(prob1) is right offer prob
            OFC32_maya_switch{iL}.vars(iK,2) = OFC32_maya_switch{iL}.oldvars(iK,7); %vars2(rwd1) is right rwd
            if OFC32_maya_switch{iL}.vars(iK,2) == 2
                OFC32_maya_switch{iL}.vars(iK,2) = 3;
            elseif OFC32_maya_switch{iL}.vars(iK,2) == 1
                OFC32_maya_switch{iL}.vars(iK,2) = 2;
            elseif OFC32_maya_switch{iL}.vars(iK,2) == 0
                OFC32_maya_switch{iL}.vars(iK,2) = 1;
            end
            OFC32_maya_switch{iL}.vars(iK,3) = OFC32_maya_switch{iL}.vars(iK,1)*OFC32_maya_switch{iL}.vars(iK,2);
            
            OFC32_maya_switch{iL}.vars(iK,4) = OFC32_maya_switch{iL}.oldvars(iK,3); %vars4(prob2) is left offer prob
            OFC32_maya_switch{iL}.vars(iK,5) = OFC32_maya_switch{iL}.oldvars(iK,6); %vars5(rwd2) is left rwd
            if OFC32_maya_switch{iL}.vars(iK,5) == 2
                OFC32_maya_switch{iL}.vars(iK,5) = 3;
            elseif OFC32_maya_switch{iL}.vars(iK,5) == 1
                OFC32_maya_switch{iL}.vars(iK,5) = 2;
            elseif OFC32_maya_switch{iL}.vars(iK,5) == 0
                OFC32_maya_switch{iL}.vars(iK,5) = 1;
            end
            OFC32_maya_switch{iL}.vars(iK,6) = OFC32_maya_switch{iL}.vars(iK,4)*OFC32_maya_switch{iL}.vars(iK,5);

            OFC32_maya_switch{iL}.vars(iK,7) = OFC32_maya_switch{iL}.oldvars(iK,5);
            OFC32_maya_switch{iL}.vars(iK,8) = OFC32_maya_switch{iL}.oldvars(iK,8);
            
            %compare chosen side to the side of the first offer
            if OFC32_maya_switch{iL}.vars(iK,8) == OFC32_maya_switch{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                OFC32_maya_switch{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif OFC32_maya_switch{iL}.vars(iK,8) ~= OFC32_maya_switch{iL}.vars(iK,7) % if chosen side and 1st offer side are different
                OFC32_maya_switch{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
              
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if OFC32_maya_switch{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                OFC32_maya_switch{iL}.vars(iK,10) = 1; %code as 1
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 1 %if it was a loss
                OFC32_maya_switch{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if OFC32_maya_switch{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif OFC32_maya_switch{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            elseif safe == 0            
            if OFC32_maya_switch{iL}.oldvars(iK,9) == 1 %if it was a loss
                OFC32_maya_switch{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif OFC32_maya_switch{iL}.oldvars(iK,9) == 2 || OFC32_maya_switch{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if OFC32_maya_switch{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif OFC32_maya_switch{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    OFC32_maya_switch{iL}.vars(iK,10) = OFC32_maya_switch{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            end
             
        end
    end
end
