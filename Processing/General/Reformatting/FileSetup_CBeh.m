%% Restructure the Data
% Create NaN arrays to fill
Calvin = data';
% for iL = 1:length(Calvin)
%     for iK = 1:length(Calvin{iL})
%         Calvin{iL}.vars(iK,1:10) = NaN;
%     end
% end

% 1.identify 1st offer prob (col3  where col5 is left, etc)
for iL = 1:length(Calvin)
    for iK = 1:length(Calvin{iL}.oldvars)
        if Calvin{iL}.oldvars(iK,5) == 1 %if side of first is left...
            Calvin{iL}.vars(iK,1) = Calvin{iL}.oldvars(iK,3); %prob1 is left offer prob
            Calvin{iL}.vars(iK,2) = Calvin{iL}.oldvars(iK,6); %rwd1 is left rwd
            if Calvin{iL}.vars(iK,2) == 2 %recode a rwd value of 2 (for large)
                Calvin{iL}.vars(iK,2) = 3; %to rwd value 2 (for large)
            elseif Calvin{iL}.vars(iK,2) == 1; %recode a rwd value of 1 (for medium)
                Calvin{iL}.vars(iK,2) = 2; %to rwd value 2 (for medium)
            elseif Calvin{iL}.vars(iK,2) == 0; %recode a rwd value of 0 (for small)
                Calvin{iL}.vars(iK,2) = 1; %to rwd value 1 (for small)
            end
            Calvin{iL}.vars(iK,3) = Calvin{iL}.vars(iK,1)*Calvin{iL}.vars(iK,2); %compute EV
            
            Calvin{iL}.vars(iK,4) = Calvin{iL}.oldvars(iK,4); %prob2 is right offer prob
            Calvin{iL}.vars(iK,5) = Calvin{iL}.oldvars(iK,7); %rwd2 is right rwd
            if Calvin{iL}.vars(iK,5) == 2 %same recode scheme as above
                Calvin{iL}.vars(iK,5) = 3;
            elseif Calvin{iL}.vars(iK,5) == 1;
                Calvin{iL}.vars(iK,5) = 2;
            elseif Calvin{iL}.vars(iK,5) == 0;
                Calvin{iL}.vars(iK,5) = 1;
            end
            Calvin{iL}.vars(iK,6) = Calvin{iL}.vars(iK,4)*Calvin{iL}.vars(iK,5); %compute EV

            Calvin{iL}.vars(iK,7) = Calvin{iL}.oldvars(iK,5); %direct for 1st offer side
            Calvin{iL}.vars(iK,8) = Calvin{iL}.oldvars(iK,8); %direct for chosen side
            
            %compare chosen side to the side of the first offer
            if Calvin{iL}.vars(iK,8) == Calvin{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                Calvin{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif Calvin{iL}.vars(iK,8) ~= Calvin{iL}.vars(iK,7)% if chosen side and 1st offer side are different
                Calvin{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
             
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if Calvin{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                Calvin{iL}.vars(iK,10) = 1; %code as 1
            elseif Calvin{iL}.oldvars(iK,9) == 1 %if it was a loss
                Calvin{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif Calvin{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if Calvin{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif Calvin{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            elseif safe == 0            
            if Calvin{iL}.oldvars(iK,9) == 1 %if it was a loss
                Calvin{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif Calvin{iL}.oldvars(iK,9) == 2 || Calvin{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if Calvin{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif Calvin{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            end

        elseif Calvin{iL}.oldvars(iK,5) == 2 %if side of first is right...
            Calvin{iL}.vars(iK,1) = Calvin{iL}.oldvars(iK,4); %vars1(prob1) is right offer prob
            Calvin{iL}.vars(iK,2) = Calvin{iL}.oldvars(iK,7); %vars2(rwd1) is right rwd
            if Calvin{iL}.vars(iK,2) == 2
                Calvin{iL}.vars(iK,2) = 3;
            elseif Calvin{iL}.vars(iK,2) == 1;
                Calvin{iL}.vars(iK,2) = 2;
            elseif Calvin{iL}.vars(iK,2) == 0;
                Calvin{iL}.vars(iK,2) = 1;
            end
            Calvin{iL}.vars(iK,3) = Calvin{iL}.vars(iK,1)*Calvin{iL}.vars(iK,2);
            
            Calvin{iL}.vars(iK,4) = Calvin{iL}.oldvars(iK,3); %vars4(prob2) is left offer prob
            Calvin{iL}.vars(iK,5) = Calvin{iL}.oldvars(iK,6); %vars5(rwd1) is left rwd
            if Calvin{iL}.vars(iK,5) == 2
                Calvin{iL}.vars(iK,5) = 3;
            elseif Calvin{iL}.vars(iK,5) == 1;
                Calvin{iL}.vars(iK,5) = 2;
            elseif Calvin{iL}.vars(iK,5) == 0;
                Calvin{iL}.vars(iK,5) = 1;
            end
            Calvin{iL}.vars(iK,6) = Calvin{iL}.vars(iK,4)*Calvin{iL}.vars(iK,5);

            Calvin{iL}.vars(iK,7) = Calvin{iL}.oldvars(iK,5);
            Calvin{iL}.vars(iK,8) = Calvin{iL}.oldvars(iK,8);
            
            %compare chosen side to the side of the first offer
            if Calvin{iL}.vars(iK,8) == Calvin{iL}.vars(iK,7) %if chosen and 1st offer sides are same
                Calvin{iL}.vars(iK,9) = 1; % chosen offer is 1st offer
            elseif Calvin{iL}.vars(iK,8) ~= Calvin{iL}.vars(iK,7) % if chosen side and 1st offer side are different
                Calvin{iL}.vars(iK,9) = 2; %chosen offer is 2nd offer
            end
              
%             %CHANGE FROM: Outcome (0 = safe/medium; 1:loss; 2:Win)
%             %CHANGE TO: Experienced reward (0 = none, 1 = safe, 2 = medium, 3 = large)
            if safe == 1
            if Calvin{iL}.oldvars(iK,9) == 0 %if it was the safe choice
                Calvin{iL}.vars(iK,10) = 1; %code as 1
            elseif Calvin{iL}.oldvars(iK,9) == 1 %if it was a loss
                Calvin{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif Calvin{iL}.oldvars(iK,9) == 2 %if they gambled and won...
                if Calvin{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif Calvin{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            elseif safe == 0            
            if Calvin{iL}.oldvars(iK,9) == 1 %if it was a loss
                Calvin{iL}.vars(iK,10) = 0; %no reward was experienced
            elseif Calvin{iL}.oldvars(iK,9) == 2 || Calvin{iL}.oldvars(iK,9) == 0 %if they gambled and won...
                if Calvin{iL}.vars(iK,9) == 1 %if chosen offer was 1st offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,2); %exp rwd was rwd 1
                elseif Calvin{iL}.vars(iK,9) == 2 %if chosen offer was 2nd offer
                    Calvin{iL}.vars(iK,10) = Calvin{iL}.vars(iK,5); %exp rwd was rwd 1
                end
            end
            end
             
        end
    end
end
