function [sv,gof] = SV_epoch(input)
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
lowep1(1:length(newlow),1:10) = NaN;
lowep2(1:length(newlow),1:10) = NaN;
highep1(1:length(newhigh),1:10) = NaN;
highep2(1:length(newhigh),1:10) = NaN;
for iJ = 1:length(newlow)
    if newlow(iJ,2) == 2
        lowep1(iJ,:) = newlow(iJ,:);
    end
    if newlow(iJ,2) == 1
        lowep2(iJ,:) = newlow(iJ,:);
    end
end
for iJ = 1:length(newhigh)
    if newhigh(iJ,2) == 3
        highep1(iJ,:) = newhigh(iJ,:);
    end
    if newhigh(iJ,2) == 1
        highep2(iJ,:) = newhigh(iJ,:);
    end
end
clear newlow newhigh iJ;
for iJ = length(lowep1):-1:1
    if isnan(lowep1(iJ,1))
        lowep1(iJ,:) = [];
    end
end
for iJ = length(lowep2):-1:1
    if isnan(lowep2(iJ,1))
        lowep2(iJ,:) = [];
    end
end
for iJ = length(highep1):-1:1
    if isnan(highep1(iJ,1))
        highep1(iJ,:) = [];
    end
end
for iJ = length(highep2):-1:1
    if isnan(highep2(iJ,1))
        highep2(iJ,:) = [];
    end
end
clear iJ;

%% define choice by risky and safe choice tag

for iJ = 1:length(lowep1)
    if lowep1(iJ,9) == 1 %if choice was offer 1 (when offer 1 was risky)
        lowCep1(iJ,1) = 0; %mark choice as risky
    else
        lowCep1(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
lowRep1 = lowep1(:,1);
clear lowep1 iJ;
for iJ = 1:length(lowep2)
    if lowep2(iJ,9) == 0 %if choice was offer 2 (when offer 2 was risky)
        lowCep2(iJ,1) = 0; %mark choice as risky
    else
        lowCep2(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
lowRep2 = lowep2(:,4);
clear lowep2 iJ;
    
for iJ = 1:length(highep1)
    if highep1(iJ,9) == 1 %if choice was offer 1 (when offer 1 was risky)
        highCep1(iJ,1) = 0; %mark choice as risky
    else
        highCep1(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
highRep1 = highep1(:,1);
clear highep1 iJ;
for iJ = 1:length(highep2)
    if highep2(iJ,9) == 0 %if choice was offer 2 (when offer 2 was risky)
        highCep2(iJ,1) = 0; %mark choice as risky
    else
        highCep2(iJ,1) = 1; %otherwise, mark choice as safe
    end
end
highRep2 = highep2(:,4);
clear highep2 iJ;

%% fit, extract, and plot
[fitresult,gof.lowep1] = createFit_sv(lowRep1,lowCep1);
a = fitresult.a;
b = fitresult.b;
sv.lowep1 = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.lowep2] = createFit_sv(lowRep2,lowCep2);
a = fitresult.a;
b = fitresult.b;
sv.lowep2 = (log((a/0.5)-b)+2)/b;

[fitresult,gof.highep1] = createFit_sv(highRep1,highCep1);
a = fitresult.a;
b = fitresult.b;
sv.highep1 = (log((a/0.5)-b)+2)/b;
clear fitresult a b;

[fitresult,gof.highep2] = createFit_sv(highRep2,highCep2);
a = fitresult.a;
b = fitresult.b;
sv.highep2 = (log((a/0.5)-b)+2)/b;

end
