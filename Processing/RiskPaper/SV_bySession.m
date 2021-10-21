function [sv] = SV_bySession(input)
%% set to trial data
for iJ = 1:length(input)
    data{iJ,1} = input{iJ}.vars;
end

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
%% define choice by risky and safe choice tag
for iI = 1:size(low,1)
    for iJ = 1:size(low{iI},1)
        if low{iI}(iJ,2) == 1 && low{iI}(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
            choicelow{iI,1}(iJ,1) = 1; %choice was safe
        elseif low{iI}(iJ,5) == 1 && low{iI}(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
            choicelow{iI,1}(iJ,1) = 1; %choice was safe
        else %in all other cases
            choicelow{iI,1}(iJ,1) = 0; %choice was risky
        end
    end
    for iJ = 1:size(low{iI},1)
        if low{iI}(iJ,2) == 2
            risklow{iI,1}(iJ,1) = low{iI}(iJ,1);
        elseif low{iI}(iJ,5) == 2
            risklow{iI,1}(iJ,1) = low{iI}(iJ,4);
        end
    end
    for iJ = 1:size(high{iI},1)
        if high{iI}(iJ,2) == 1 && high{iI}(iJ,9) == 1 %if offer 1 was safe and choice was offer 1
            choicehigh{iI,1}(iJ,1) = 1; %choice was safe
        elseif high{iI}(iJ,5) == 1 && high{iI}(iJ,9) == 0 % if offer 2 was safe and choice was offer 2
            choicehigh{iI,1}(iJ,1) = 1; %choice was safe
        else %in all other cases
            choicehigh{iI,1}(iJ,1) = 0; %choice was risky
        end
    end
    for iJ = 1:size(high{iI},1)
        if high{iI}(iJ,2) == 3
            riskhigh{iI,1}(iJ,1) = high{iI}(iJ,1);
        elseif high{iI}(iJ,5) == 3
            riskhigh{iI,1}(iJ,1) = high{iI}(iJ,4);
        end
    end
end

%% fit, extract, and plot
for iI = 1:length(low)
    [fitresult,gof{iI,1}.low] = createFit_sv(risklow{iI},choicelow{iI});
    a = fitresult.a;
    b = fitresult.b;
    sv.low{iI,1} = abs((log((a/0.5)-b)+2)/b);
    if sv.low{iI} > 1
        sv.low{iI,1} = 0;
    end
    clear fitresult a b;

    [fitresult,gof{iI,1}.high] = createFit_sv(riskhigh{iI},choicehigh{iI});
    a = fitresult.a;
    b = fitresult.b;
    sv.high{iI,1} = abs((log((a/0.5)-b)+2)/b);
    clear fitresult a b;
    if sv.high{iI} > 1
        sv.high{iI,1} = 0;
    end
end