function out = FlagSampleCells(input,token)
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

%%
EVs = PullEV(data);
    % For each cell, pull out FR for given epochs (6 seconds)
for iL = 1:length(data)
    if token == 0
        ep1 = EpochIsolation(data, 155, 20);
        ep2 = EpochIsolation(data, 205, 20);
    elseif token == 1
        ep1 = EpochIsolation(data, 155, 20);
        ep2 = EpochIsolation(data, 193, 20);
    end
end
    % collapse the FRs into given bin size (200ms?) for every trial
for iL = 1:length(data)
    ep1col{iL,1} = FR_CollapseBins(ep1{iL},25);
    ep2col{iL,1} = FR_CollapseBins(ep2{iL},25);
end
    % correlate EV
for iJ = 1:length(ep1)
    [~,mod(iJ,1)] = corr(ep1col{iJ},EVs{iJ}(:,1));
    [~,mod(iJ,2)] = corr(ep2col{iJ},EVs{iJ}(:,2));
end
    % find cells that are sig cor with both EVs in respective epoch
for iJ = 1:length(mod)
    if (mod(iJ,1) < 0.05) && (mod(iJ,2) < 0.05)
        mod(iJ,3) = 1;
    else
        mod(iJ,3) = 0;
    end
end
    % return indeces of cells that meet criteria
out = find(mod(:,3) == 1);

