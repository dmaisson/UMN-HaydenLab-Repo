maya = [];
%% Consolidate variables into a single struct
if isempty(maya)
    for iL = 1:length(data)
        x = data{iL};
        maya{iL}.psth = x.psth;
        maya{iL}.oldvars = x.vars;
%         OFC13_maya{iL}.names = x.names;
    end
elseif ~isempty(maya)
    c = length(maya);
    for iL = 1:length(data)
        x = data(iL);
        maya{iL+c}.psth = x.psth;
        maya{iL+c}.oldvars = x.vars;
%         OFC13_maya{iL+c}.names = x.names;
    end
end
%% Re-orient
maya = maya';
%% Restructure the Data
% Create NaN arrays to fill
for iL = 1:length(maya)
    for iK = 1:length(maya{iL}.oldvars)
        maya{iL}.vars(iK,1:10) = NaN;
    end
end

% 1.identify 1st offer prob (col3  where col5 is left, etc)
for iL = 1:length(maya)
    for iK = 1:length(maya{iL}.oldvars)
        if maya{iL}.oldvars(iK,5) == 1 %if side of first is left...
            maya{iL}.vars(iK,1) = maya{iL}.oldvars(iK,3); %prob1 is left offer prob
            maya{iL}.vars(iK,2) = maya{iL}.oldvars(iK,6); %rwd1 is left rwd
            if maya{iL}.vars(iK,2) == 2 %recode a rwd value of 2 (for large)
                maya{iL}.vars(iK,2) = 3; %to rwd value 2 (for large)
            elseif maya{iL}.vars(iK,2) == 1; %recode a rwd value of 1 (for medium)
                maya{iL}.vars(iK,2) = 2; %to rwd value 2 (for medium)
            elseif maya{iL}.vars(iK,2) == 0; %recode a rwd value of 0 (for small)
                maya{iL}.vars(iK,2) = 1; %to rwd value 1 (for small)
            end
            maya{iL}.vars(iK,3) = maya{iL}.vars(iK,1)*maya{iL}.vars(iK,2); %compute EV
            
            maya{iL}.vars(iK,4) = maya{iL}.oldvars(iK,4); %prob2 is right offer prob
            maya{iL}.vars(iK,5) = maya{iL}.oldvars(iK,7); %rwd2 is right rwd
            if maya{iL}.vars(iK,5) == 2 %same recode scheme as above
                maya{iL}.vars(iK,5) = 3;
            elseif maya{iL}.vars(iK,5) == 1;
                maya{iL}.vars(iK,5) = 2;
            elseif maya{iL}.vars(iK,5) == 0;
                maya{iL}.vars(iK,5) = 1;
            end
            maya{iL}.vars(iK,6) = maya{iL}.vars(iK,4)*maya{iL}.vars(iK,5); %compute EV

            maya{iL}.vars(iK,7) = maya{iL}.oldvars(iK,5); %direct for 1st offer side
            maya{iL}.vars(iK,8) = maya{iL}.oldvars(iK,8); %direct for chosen side
            
            %compare chosen side to the side of the first offer
            if maya{iL}.vars(iK,8) == maya{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                maya{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif maya{iL}.vars(iK,8) ~= maya{iL}.vars(iK,7)% if chosen side and 1st offer side are different
                maya{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
             
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if maya{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                maya{iL}.vars(iK,10) = 1; %code as 1
            elseif maya{iL}.oldvars(iK,9) == 1 %if it was a loss
                maya{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif maya{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if maya{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif maya{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            elseif safe == 0            
            if maya{iL}.oldvars(iK,9) == 1 %if it was a loss
                maya{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif maya{iL}.oldvars(iK,9) == 2 || maya{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if maya{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif maya{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            end

        elseif maya{iL}.oldvars(iK,5) == 2 %if side of first is right...
            maya{iL}.vars(iK,1) = maya{iL}.oldvars(iK,4); %vars1(prob1) is right offer prob
            maya{iL}.vars(iK,2) = maya{iL}.oldvars(iK,7); %vars2(rwd1) is right rwd
            if maya{iL}.vars(iK,2) == 2
                maya{iL}.vars(iK,2) = 3;
            elseif maya{iL}.vars(iK,2) == 1;
                maya{iL}.vars(iK,2) = 2;
            elseif maya{iL}.vars(iK,2) == 0;
                maya{iL}.vars(iK,2) = 1;
            end
            maya{iL}.vars(iK,3) = maya{iL}.vars(iK,1)*maya{iL}.vars(iK,2);
            
            maya{iL}.vars(iK,4) = maya{iL}.oldvars(iK,3); %vars4(prob2) is left offer prob
            maya{iL}.vars(iK,5) = maya{iL}.oldvars(iK,6); %vars5(rwd1) is left rwd
            if maya{iL}.vars(iK,5) == 2
                maya{iL}.vars(iK,5) = 3;
            elseif maya{iL}.vars(iK,5) == 1;
                maya{iL}.vars(iK,5) = 2;
            elseif maya{iL}.vars(iK,5) == 0;
                maya{iL}.vars(iK,5) = 1;
            end
            maya{iL}.vars(iK,6) = maya{iL}.vars(iK,4)*maya{iL}.vars(iK,5);

            maya{iL}.vars(iK,7) = maya{iL}.oldvars(iK,5);
            maya{iL}.vars(iK,8) = maya{iL}.oldvars(iK,8);
            
            %compare chosen side to the side of the first offer
            if maya{iL}.vars(iK,8) == maya{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                maya{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif maya{iL}.vars(iK,8) ~= maya{iL}.vars(iK,7) % if chosen side and 1st offer side are different
                maya{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
              
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if maya{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                maya{iL}.vars(iK,10) = 1; %code as 1
            elseif maya{iL}.oldvars(iK,9) == 1 %if it was a loss
                maya{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif maya{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if maya{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif maya{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            elseif safe == 0            
            if maya{iL}.oldvars(iK,9) == 1 %if it was a loss
                maya{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif maya{iL}.oldvars(iK,9) == 2 || maya{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if maya{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif maya{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    maya{iL}.vars(iK,10) = maya{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            end
             
        end
    end
end
