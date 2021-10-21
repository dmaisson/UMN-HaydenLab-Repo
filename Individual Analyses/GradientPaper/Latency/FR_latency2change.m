function [output] = FR_latency2change(input,token)
% Extract FR from mod rate and make pseudo-pop
for iJ = 1:length(input)
    if token == 0
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,205:229);
        start{iJ,1}.vars = input{iJ}.vars;
    elseif token == 1
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,193:217);
        start{iJ,1}.vars = input{iJ}.vars;
    end
end
%clear trials with NaN FRs
for iJ = 1:length(start)
    for iK = length(start{iJ}.E1FR):-1:1
        if isnan(start{iJ}.E1FR(iK,1))
            start{iJ}.E1FR(iK,:) = [];
            start{iJ}.E2FR(iK,:) = [];
            start{iJ}.vars(iK,:) = [];
        end
    end
    for iK = length(start{iJ}.E2FR):-1:1
        if isnan(start{iJ}.E2FR(iK,1))
            start{iJ}.E1FR(iK,:) = [];
            start{iJ}.E2FR(iK,:) = [];
            start{iJ}.vars(iK,:) = [];
        end
    end
end

%% find mean FR for each neuron across trials
for iJ = 1:length(start)
    x = start{iJ}.E1FR;
    E1FR(iJ,:) = nanmean(x,1)*50; clear x;
    x = start{iJ}.E2FR;
    E2FR(iJ,:) = nanmean(x,1)*50; clear x;
end

%% 
% calculate mean and SD for each neuron
E1mean = nanmean(E1FR,2);
E1sd = nanstd(E1FR,0,2);
E1mean(:,2) = E1mean(:,1) - (E1sd*2);
E1mean(:,3) = E1mean(:,1) + (E1sd*2);

E2mean = nanmean(E2FR,2);
E2sd = nanstd(E2FR,0,2);
E2mean(:,2) = E2mean(:,1) - (E2sd*2);
E2mean(:,3) = E2mean(:,1) + (E2sd*2);

% calculate change in FR from mean
for iJ = 1:size(E1FR,2)
    E1FR_change(:,iJ) = abs(E1FR(:,iJ) - E1mean(:,1));
    E2FR_change(:,iJ) = abs(E2FR(:,iJ) - E2mean(:,1));
end

% find index of greatest change from mean
for iJ = 1:length(start)
    x = find(E1FR_change(iJ,:) == max(E1FR_change(iJ,:)));
    peak_change(iJ,1) = (x(1) * 50); clear x;
    x = find(E2FR_change(iJ,:) == max(E2FR_change(iJ,:)));
    peak_change(iJ,2) = (x(1) * 50); clear x;
end

% Calculate time in ms to go from first change to peak change
for iJ = 1:length(start)
    x = find(E1FR(iJ,:) < (E1mean(iJ,2)));
    y = find(E1FR(iJ,:) > (E1mean(iJ,3)));
    z = cat(2,x,y);
    if ~isempty(z)
        first_change(iJ,1) = (min(z) * 50); clear x y z;
    else
        first_change(iJ,1) = NaN;
    end
    x = find(E2FR(iJ,:) < (E2mean(iJ,2)));
    y = find(E2FR(iJ,:) > (E2mean(iJ,3)));
    z = cat(2,x,y);
    if ~isempty(z)
        first_change(iJ,2) = (min(z) * 50); clear x y z;
    else
        first_change(iJ,2) = NaN;
    end
end

output.S2T(:,1) = nanmean(first_change(:,1),1);
output.S2T(:,2) = (nanstd(first_change(:,1),1))/sqrt(length(first_change(:,1)));
output.S2T(:,3) = nanmean(first_change(:,2),1);
output.S2T(:,4) = (nanstd(first_change(:,2),1))/sqrt(length(first_change(:,2)));

output.S2Pk(:,1) = nanmean(peak_change(:,1),1);
output.S2Pk(:,2) = (nanstd(peak_change(:,1),1))/sqrt(length(peak_change(:,1)));
output.S2Pk(:,3) = nanmean(peak_change(:,2),1);
output.S2Pk(:,4) = (nanstd(peak_change(:,2),1))/sqrt(length(peak_change(:,2)));

clear input iJ Habiba E1FR E2FR;

end