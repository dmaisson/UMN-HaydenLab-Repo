function [sv,gof] = SV(input)
%% set to trial data
for iJ = 1:length(input)
    start{iJ,1} = input{iJ}.vars;
end

data = delete_duplicate_days(start);

%%
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        if data{iJ}(iK,2) == 1 && data{iJ}(iK,5) == 2
            low{iJ,1}(iK,:) = data{iJ}(iK,1:10);
        elseif data{iJ}(iK,2) == 2 && data{iJ}(iK,5) == 1
            low{iJ,1}(iK,:) = data{iJ}(iK,1:10);
        end
    end
end
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        if data{iJ}(iK,2) == 1 && data{iJ}(iK,5) == 3
            high{iJ,1}(iK,:) = data{iJ}(iK,1:10);
        elseif data{iJ}(iK,2) == 3 && data{iJ}(iK,5) == 1
            high{iJ,1}(iK,:) = data{iJ}(iK,1:10);
        end
    end
end

for iJ = length(low):-1:1
    for iK = length(low{iJ}):-1:1
        if low{iJ}(iK,2) == 0
            low{iJ}(iK,:) = [];
        end
    end
end
for iJ = length(high):-1:1
    for iK = length(high{iJ}):-1:1
        if high{iJ}(iK,2) == 0
            high{iJ}(iK,:) = [];
        end
    end
end

%% Stick all trial data into a single matrix
for iJ = 1:length(low)
    if iJ == 1
        newlow = low{iJ};
        newhigh = high{iJ};
    else
        temp = low{iJ};
        newlow = cat(1,newlow,temp);
        clear temp;
        temp = high{iJ};
        newhigh = cat(1,newhigh,temp);
    end
end
clear low high iJ iK temp;

%% define choice by risky and safe choice tag

    for iJ = 1:length(newlow)
        if newlow(iJ,2) == 1 && newlow(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
            choicelow(iJ,1) = 1; %choice was safe
        elseif newlow(iJ,5) == 1 && newlow(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
            choicelow(iJ,1) = 1; %choice was safe
        else %in all other cases
            choicelow(iJ,1) = 0; %choice was risky
        end
    end
    for iJ = 1:length(newlow)
        if newlow(iJ,2) == 2
            risklow(iJ,1) = newlow(iJ,1);
        elseif newlow(iJ,5) == 2
            risklow(iJ,1) = newlow(iJ,4);
        end
    end
    for iJ = 1:length(newhigh)
        if newhigh(iJ,2) == 1 && newhigh(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
            choicehigh(iJ,1) = 1; %choice was safe
        elseif newhigh(iJ,5) == 1 && newhigh(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
            choicehigh(iJ,1) = 1; %choice was safe
        else %in all other cases
            choicehigh(iJ,1) = 0; %choice was risky
        end
    end
    for iJ = 1:length(newhigh)
        if newhigh(iJ,2) == 3
            riskhigh(iJ,1) = newhigh(iJ,1);
        elseif newhigh(iJ,5) == 3
            riskhigh(iJ,1) = newhigh(iJ,4);
        end
    end
    clear newlow newhigh iJ;

%% fit, extract, and plot
[fitresult,gof.low] = createFit_sv(risklow,choicelow);
a = fitresult.a;
b = fitresult.b;
sv.low = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.high] = createFit_sv(riskhigh,choicehigh);
a = fitresult.a;
b = fitresult.b;
sv.high = (log((a/0.5)-b)+2)/b;

end
