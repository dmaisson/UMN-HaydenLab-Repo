data = sgaccdata;

for iJ = 1:size(data,1)
    data{iJ}.oldvars = data{iJ}.vars;
    [EV1,EV2] = expectedValues(data{iJ});
    temp_EV{iJ}.vars(:,1) = EV1;
    temp_EV{iJ}.vars(:,2) = EV2;
    temp_EV{iJ}.vars(:,3) = outcomes(data{iJ}); %outcome on (trial in tokens)
    temp_EV{iJ}.vars(:,4) = data{iJ}.vars(:,14); %Jackpot?
    for iK = 1:size(data{iJ}.vars,1)
    temp_EV{iJ}.vars(iK,5) = data{iJ}.vars(iK,9)-temp_EV{iJ}.vars(iK,3); %tokens at END - outcome
    end
end
temp_EV = temp_EV';

%%
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.oldvars,1)
        data{iJ}.vars = [];
    end
end
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.oldvars,1)
        if data{iJ}.oldvars(iK,15) == 1 %if left is first
            if data{iJ}.oldvars(iK,5) > 0 %if top left size is "win"
                data{iJ}.vars(iK,1) = data{iJ}.oldvars(iK,12)./100; % top left prob 
                data{iJ}.vars(iK,2) = data{iJ}.oldvars(iK,5); % top left size
            elseif data{iJ}.oldvars(iK,5) < 0 %if top left size is "lose"
                data{iJ}.vars(iK,1) = 1-(data{iJ}.oldvars(iK,12)./100); % bottom left prob 
                data{iJ}.vars(iK,2) = data{iJ}.oldvars(iK,6); % bottom left size
            end
            if data{iJ}.oldvars(iK,7) > 0 %if top right size is "win"
                data{iJ}.vars(iK,4) = data{iJ}.oldvars(iK,13)./100; % top right prob 
                data{iJ}.vars(iK,5) = data{iJ}.oldvars(iK,7); % top right size
            elseif data{iJ}.oldvars(iK,7) < 0 %if top right size is "lose"
                data{iJ}.vars(iK,4) = 1-(data{iJ}.oldvars(iK,13)./100); % bottom right prob 
                data{iJ}.vars(iK,5) = data{iJ}.oldvars(iK,8); % bottom right size
            end
            data{iJ}.vars(iK,7) = data{iJ}.oldvars(iK,15);% side of first
            data{iJ}.vars(iK,8) = data{iJ}.oldvars(iK,16);% side of choice
            if data{iJ}.vars(iK,7) == data{iJ}.vars(iK,8)
                data{iJ}.vars(iK,9) = 1;% Choice 1 or 2
            else
                data{iJ}.vars(iK,9) = 2;% Choice 1 or 2
            end
            
        elseif data{iJ}.oldvars(iK,15) == 2
            if data{iJ}.oldvars(iK,7) > 0 %if top right size is "win"
                data{iJ}.vars(iK,1) = data{iJ}.oldvars(iK,13)./100; % top right prob 
                data{iJ}.vars(iK,2) = data{iJ}.oldvars(iK,7); % top right size
            elseif data{iJ}.oldvars(iK,7) < 0 %if top right size is "lose"
                data{iJ}.vars(iK,1) = 1-(data{iJ}.oldvars(iK,13)./100); % bottom right prob 
                data{iJ}.vars(iK,2) = data{iJ}.oldvars(iK,8); % bottom right size
            end
            if data{iJ}.oldvars(iK,5) > 0 %if top left size is "win"
                data{iJ}.vars(iK,4) = data{iJ}.oldvars(iK,12)./100; % top left prob 
                data{iJ}.vars(iK,5) = data{iJ}.oldvars(iK,5); % top left size
            elseif data{iJ}.oldvars(iK,5) < 0 %if top left size is "lose"
                data{iJ}.vars(iK,4) = 1-(data{iJ}.oldvars(iK,12)./100); % bottom left prob 
                data{iJ}.vars(iK,5) = data{iJ}.oldvars(iK,6); % bottom left size
            end
            data{iJ}.vars(iK,7) = data{iJ}.oldvars(iK,15);% side of first
            data{iJ}.vars(iK,8) = data{iJ}.oldvars(iK,16);% side of choice
            if data{iJ}.vars(iK,7) == data{iJ}.vars(iK,8)
                data{iJ}.vars(iK,9) = 1;% Choice 1 or 2
            else
                data{iJ}.vars(iK,9) = 2;% Choice 1 or 2
            end
        end
        data{iJ}.vars(iK,3) = temp_EV{iJ}.vars(iK,1); % EV1
        data{iJ}.vars(iK,6) = temp_EV{iJ}.vars(iK,2); % EV2
        data{iJ}.vars(iK,10) = temp_EV{iJ}.vars(iK,3); % outcome in tokens
        data{iJ}.vars(iK,11) = temp_EV{iJ}.vars(iK,4); % jackpot trial?
        data{iJ}.vars(iK,12) = temp_EV{iJ}.vars(iK,5); % tokens at start of trial
    end
end
