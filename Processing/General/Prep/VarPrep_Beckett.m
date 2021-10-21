function [data] = VarPrep_Beckett(start)
%% resize set
for iJ = 1:size(start,1)
    for iK = 1:size(start{iJ}.psth,1)
        if size(start{iJ}.psth,2) < 1500
            data{iJ}.psth(iK,:) = start{iJ}.psth(iK,400:999);
        elseif size(start{iJ}.psth,2) >= 1500
            data{iJ}.psth(iK,:) = start{iJ}.psth(iK,200:799);
        end
    end
    data{iJ}.vars = start{iJ}.vars;
end
clear start temp
data = data';

%% recode the choice vars to 0 and 1
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

end