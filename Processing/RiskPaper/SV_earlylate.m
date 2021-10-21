function [sv,gof] = SV_earlylate(input)
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

%% early and late
x = round(length(newlow)/4);
newlowearly = newlow(1:x,:);
newlowlate = newlow((end-x)+1:end,:);

x = round(length(newhigh)/4);
newhighearly = newhigh(1:x,:);
newhighlate = newhigh((end-x)+1:end,:);
clear newlow newhigh x;

%% define choice by risky and safe choice tag

for iJ = 1:length(newlowearly)
    if newlowearly(iJ,2) == 1 && newlowearly(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
        choicelowearly(iJ,1) = 1; %choice was safe
    elseif newlowearly(iJ,5) == 1 && newlowearly(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
        choicelowearly(iJ,1) = 1; %choice was safe
    else %in all other cases
        choicelowearly(iJ,1) = 0; %choice was risky
    end
end
for iJ = 1:length(newlowearly)
    if newlowearly(iJ,2) == 2
        risklowearly(iJ,1) = newlowearly(iJ,1);
    elseif newlowearly(iJ,5) == 2
        risklowearly(iJ,1) = newlowearly(iJ,4);
    end
end
for iJ = 1:length(newlowlate)
    if newlowlate(iJ,2) == 1 && newlowlate(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
        choicelowlate(iJ,1) = 1; %choice was safe
    elseif newlowlate(iJ,5) == 1 && newlowlate(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
        choicelowlate(iJ,1) = 1; %choice was safe
    else %in all other cases
        choicelowlate(iJ,1) = 0; %choice was risky
    end
end
for iJ = 1:length(newlowlate)
    if newlowlate(iJ,2) == 2
        risklowlate(iJ,1) = newlowlate(iJ,1);
    elseif newlowlate(iJ,5) == 2
        risklowlate(iJ,1) = newlowlate(iJ,4);
    end
end

for iJ = 1:length(newhighearly)
    if newhighearly(iJ,2) == 1 && newhighearly(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
        choicehighearly(iJ,1) = 1; %choice was safe
    elseif newhighearly(iJ,5) == 1 && newhighearly(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
        choicehighearly(iJ,1) = 1; %choice was safe
    else %in all other cases
        choicehighearly(iJ,1) = 0; %choice was risky
    end
end
for iJ = 1:length(newhighearly)
    if newhighearly(iJ,2) == 3
        riskhighearly(iJ,1) = newhighearly(iJ,1);
    elseif newhighearly(iJ,5) == 3
        riskhighearly(iJ,1) = newhighearly(iJ,4);
    end
end
for iJ = 1:length(newhighlate)
    if newhighlate(iJ,2) == 1 && newhighlate(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
        choicehighlate(iJ,1) = 1; %choice was safe
    elseif newhighlate(iJ,5) == 1 && newhighlate(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
        choicehighlate(iJ,1) = 1; %choice was safe
    else %in all other cases
        choicehighlate(iJ,1) = 0; %choice was risky
    end
end
for iJ = 1:length(newhighlate)
    if newhighlate(iJ,2) == 3
        riskhighlate(iJ,1) = newhighlate(iJ,1);
    elseif newhighlate(iJ,5) == 3
        riskhighlate(iJ,1) = newhighlate(iJ,4);
    end
end
clear newhighearly newhighlate newlowearly newlowlate;

%% fit, extract, and plot
[fitresult,gof.lowearly] = createFit_sv(risklowearly,choicelowearly);
a = fitresult.a;
b = fitresult.b;
sv.lowearly = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.lowlate] = createFit_sv(risklowlate,choicelowlate);
a = fitresult.a;
b = fitresult.b;
sv.lowlate = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.highearly] = createFit_sv(riskhighearly,choicehighearly);
a = fitresult.a;
b = fitresult.b;
sv.highearly = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.highlate] = createFit_sv(riskhighlate,choicehighlate);
a = fitresult.a;
b = fitresult.b;
sv.highlate = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

end
