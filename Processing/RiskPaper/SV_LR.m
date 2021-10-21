function [sv,gof] = SV_LR(input)
%% set to trial data
for iJ = 1:length(input)
    start{iJ,1} = input{iJ}.vars;
end

data = delete_duplicate_days(start);

%% separate data into trials with low or high risky offers, and a safe offer
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

%% separate by epoch and clean up matrices
lowL(1:length(newlow),1:10) = NaN;
lowR(1:length(newlow),1:10) = NaN;
highL(1:length(newhigh),1:10) = NaN;
highR(1:length(newhigh),1:10) = NaN;
for iJ = 1:length(newlow)
    if newlow(iJ,2) == 2 && newlow(iJ,7) == 1 %if the first offer is risky, first offer is left
        lowL(iJ,:) = newlow(iJ,:); %risky offer is on left
    end
    if newlow(iJ,5) == 2 && newlow(iJ,7) == 1 %if the second offer is risky, second offer is right
        lowR(iJ,:) = newlow(iJ,:); %risky offer is on right
    end
    if newlow(iJ,2) == 2 && newlow(iJ,7) == 0 %if the first offer is risky, first offer is right
        lowR(iJ,:) = newlow(iJ,:); %risky offer is on right
    end
    if newlow(iJ,5) == 2 && newlow(iJ,7) == 0 %if the second offer is risky, second offer is left
        lowL(iJ,:) = newlow(iJ,:); %risky offer is on right
    end
end
for iJ = 1:length(newhigh)
    if newhigh(iJ,2) == 3 && newhigh(iJ,7) == 1 %if the first offer is risky, first offer is left
        highL(iJ,:) = newhigh(iJ,:); %risky offer is on left
    end
    if newhigh(iJ,5) == 3 && newhigh(iJ,7) == 1 %if the second offer is risky, second offer is right
        highR(iJ,:) = newhigh(iJ,:); %risky offer is on right
    end
    if newhigh(iJ,2) == 3 && newhigh(iJ,7) == 0 %if the first offer is risky, first offer is right
        highR(iJ,:) = newhigh(iJ,:); %risky offer is on right
    end
    if newhigh(iJ,5) == 3 && newhigh(iJ,7) == 0 %if the second offer is risky, second offer is left
        highL(iJ,:) = newhigh(iJ,:); %risky offer is on right
    end
end
clear newlow newhigh iJ;
for iJ = length(lowL):-1:1
    if isnan(lowL(iJ,1))
        lowL(iJ,:) = [];
    end
end
for iJ = length(lowR):-1:1
    if isnan(lowR(iJ,1))
        lowR(iJ,:) = [];
    end
end
for iJ = length(highL):-1:1
    if isnan(highL(iJ,1))
        highL(iJ,:) = [];
    end
end
for iJ = length(highR):-1:1
    if isnan(highR(iJ,1))
        highR(iJ,:) = [];
    end
end
clear iJ;

%% define choice by risky and safe choice tag

for iJ = 1:length(lowL)
    if lowL(iJ,8) == 1 %if choice was left (when left was risky)
        lowCL(iJ,1) = 0; %mark choice as risky
    else
        lowCL(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
for iJ = 1:length(lowL)
    if lowL(iJ,2) == 2
        lowRL(iJ,1) = lowL(iJ,1);
    else
        lowRL(iJ,1) = lowL(iJ,4);
    end
end
clear lowL iJ;
for iJ = 1:length(lowR)
    if lowR(iJ,8) == 0 %if choice was right (when right was risky)
        lowCR(iJ,1) = 0; %mark choice as risky
    else
        lowCR(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
for iJ = 1:length(lowR)
    if lowR(iJ,2) == 2
        lowRR(iJ,1) = lowR(iJ,1);
    else
        lowRR(iJ,1) = lowR(iJ,4);
    end
end
clear lowR iJ;

for iJ = 1:length(highL)
    if highL(iJ,8) == 1 %if choice was left (when left was risky)
        highCL(iJ,1) = 0; %mark choice as risky
    else
        highCL(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
for iJ = 1:length(highL)
    if highL(iJ,2) == 3
        highRL(iJ,1) = highL(iJ,1);
    else
        highRL(iJ,1) = highL(iJ,4);
    end
end
clear highL iJ;
for iJ = 1:length(highR)
    if highR(iJ,8) == 0 %if choice was right (when right was risky)
        highCR(iJ,1) = 0; %mark choice as risky
    else
        highCR(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
for iJ = 1:length(highR)
    if highR(iJ,2) == 3
        highRR(iJ,1) = highR(iJ,1);
    else
        highRR(iJ,1) = highR(iJ,4);
    end
end
clear highR iJ;

%% fit, extract, and plot
[fitresult,gof.lowL] = createFit_sv(lowRL,lowCL);
a = fitresult.a;
b = fitresult.b;
sv.lowL = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.lowR] = createFit_sv(lowRR,lowCR);
a = fitresult.a;
b = fitresult.b;
sv.lowR = (log((a/0.5)-b)+2)/b;

[fitresult,gof.highL] = createFit_sv(highRL,highCL);
a = fitresult.a;
b = fitresult.b;
sv.highL = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.highR] = createFit_sv(highRR,highCR);
a = fitresult.a;
b = fitresult.b;
sv.highR = (log((a/0.5)-b)+2)/b;

end
