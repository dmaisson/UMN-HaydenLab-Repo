function [mi_avgEp1safe_low,mi_avgEp1safe_high,mi_avgEp2safe_low,mi_avgEp2safe_high,mi_avg_shuffle] = Mutual_Information_pseudo(input)

%% Starting variables
safeEp1 = input.safe.Ep1;
safeEp2 = input.safe.Ep2;
lowEp1 = input.eqlow.Ep1;
lowEp2 = input.eqlow.Ep1;
highEp1 = input.eqhigh.Ep1;
highEp2 = input.eqhigh.Ep2;
n = length(safeEp1);
clear low high x probs input;

%% Extract mFR
for iJ = 1:n
    mFRsafe.Ep1{iJ,1} = nanmean(safeEp1{iJ}.psth,2);
    mFRsafe.Ep2{iJ,1} = nanmean(safeEp2{iJ}.psth,2);
    mFRlow.Ep1{iJ,1} = nanmean(lowEp1{iJ}.psth,2);
    mFRlow.Ep2{iJ,1} = nanmean(lowEp2{iJ}.psth,2);
    mFRhigh.Ep1{iJ,1} = nanmean(highEp1{iJ}.psth,2);
    mFRhigh.Ep2{iJ,1} = nanmean(highEp2{iJ}.psth,2);
end
clear lowEp1 lowEp2 highEp1 highEp2 safeEp1 safeEp2;

%% clear NaNs from mFRs
for iJ = 1:n
    for iK = length(mFRsafe.Ep1{iJ}):-1:1
        if isnan(mFRsafe.Ep1{iJ}(iK,1))
            mFRsafe.Ep1{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRsafe.Ep2{iJ}):-1:1
        if isnan(mFRsafe.Ep2{iJ}(iK,1))
            mFRsafe.Ep2{iJ}(iK,:) = [];
        end
    end
    
    for iK = length(mFRlow.Ep1{iJ}):-1:1
        if isnan(mFRlow.Ep1{iJ}(iK,1))
            mFRlow.Ep1{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRlow.Ep2{iJ}):-1:1
        if isnan(mFRlow.Ep2{iJ}(iK,1))
            mFRlow.Ep2{iJ}(iK,:) = [];
        end
    end
    
    for iK = length(mFRhigh.Ep1{iJ}):-1:1
        if isnan(mFRhigh.Ep1{iJ}(iK,1))
            mFRhigh.Ep1{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRhigh.Ep2{iJ}):-1:1
        if isnan(mFRhigh.Ep2{iJ}(iK,1))
            mFRhigh.Ep2{iJ}(iK,:) = [];
        end
    end
end

%% Build matrix of pseudos
% Safe Vs. Eq Low - EPOCH 1
Ep1safe(1:1000,1:n) = NaN;
Ep1low(1:1000,1:n) = NaN;
Ep1high(1:1000,1:n) = NaN;

for iJ = 1:size(Ep1safe,1) %for each of 1000 "trials"
    for iK = 1:size(Ep1safe,2) %for each neuron
        try
            pick = randi(length(mFRsafe.Ep1{iK}),1);
            Ep1safe(iJ,iK) = mFRsafe.Ep1{iK}(pick,1);
        catch
            Ep1safe(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(Ep1low,1)
    for iK = 1:size(Ep1low,2)
        try
            pick = randi(length(mFRlow.Ep1{iK}),1);
            Ep1low(iJ,iK) = mFRlow.Ep1{iK}(pick,1);
        catch
            Ep1low(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(Ep1high,1)
    for iK = 1:size(Ep1high,2)
        try
            pick = randi(length(mFRhigh.Ep1{iK}),1);
            Ep1high(iJ,iK) = mFRhigh.Ep1{iK}(pick,1);
        catch
            Ep1high(iJ,iK) = NaN;
        end
    end
end

%% Safe Vs. Eq Low - EPOCH 2
Ep2safe(1:1000,1:n) = NaN;
Ep2low(1:1000,1:n) = NaN;
Ep2high(1:1000,1:n) = NaN;

for iJ = 1:size(Ep2safe,1) %for each of 1000 "trials"
    for iK = 1:size(Ep2safe,2) %for each neuron
        try
            pick = randi(length(mFRsafe.Ep2{iK}),1);
            Ep2safe(iJ,iK) = mFRsafe.Ep2{iK}(pick,1);
        catch
            Ep2safe(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(Ep2low,1)
    for iK = 1:size(Ep2low,2)
        try
            pick = randi(length(mFRlow.Ep2{iK}),1);
            Ep2low(iJ,iK) = mFRlow.Ep2{iK}(pick,1);
        catch
            Ep2low(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(Ep2high,1)
    for iK = 1:size(Ep2high,2)
        try
            pick = randi(length(mFRhigh.Ep2{iK}),1);
            Ep2high(iJ,iK) = mFRhigh.Ep2{iK}(pick,1);
        catch
            Ep2high(iJ,iK) = NaN;
        end
    end
end

%% Shuffled matrices
shuffle(1:1000,1:n+1) = NaN;

for iJ = 1:size(shuffle,1)
    for iK = 1:size(shuffle,2)
        x = randi(3); %randomly pick between safe, low, high
        if x == 1 %if randi is 1, use safe
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRsafe.Ep1{iK}),1);
                    shuffle(iJ,iK) = mFRsafe.Ep1{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRsafe.Ep2{iK}),1);
                    shuffle(iJ,iK) = mFRsafe.Ep2{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            end
        elseif x == 2 %if randi is 2, use low
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRlow.Ep1{iK}),1);
                    shuffle(iJ,iK) = mFRlow.Ep1{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRlow.Ep2{iK}),1);
                    shuffle(iJ,iK) = mFRlow.Ep2{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            end
        elseif x == 3 %if randi is 3, use high
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRhigh.Ep1{iK}),1);
                    shuffle(iJ,iK) = mFRhigh.Ep1{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRhigh.Ep2{iK}),1);
                    shuffle(iJ,iK) = mFRhigh.Ep2{iK}(pick,1);
                catch
                    shuffle(iJ,iK) = NaN;
                end
            end
        end
    end
end

clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te mFRsafe mFRlow mFRhigh x y n ans pick;

%% Clear NaNs
for iK = size(Ep1safe,1):-1:1
    for iJ = size(Ep1safe,2):-1:1
        if isnan(Ep1safe(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(Ep2safe(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(Ep1low(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(Ep2low(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(Ep1high(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(Ep2high(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
        
        if isnan(shuffle(iK,iJ))
            Ep1safe(:,iJ) = [];
            Ep2safe(:,iJ) = [];
            Ep1low(:,iJ) = [];
            Ep2low(:,iJ) = [];
            Ep1high(:,iJ) = [];
            Ep2high(:,iJ) = [];
            shuffle(:,iJ) = [];
        end
    end
end

%% Mutual information

safe_low_mi = zeros(size(Ep1safe,1));
safe_high_mi = zeros(size(Ep1safe,1));
shuffle_mi = zeros(size(Ep1safe,1));
for iJ = 1:size(safe_low_mi,2)
    for iK = 1:size(safe_low_mi,2)
        x = Ep1low(:,iJ);
        y = Ep1safe(:,iK);
        safe_low_mi(iJ,iK) = MutualInformation(x,y);
        clear x y;
        x = Ep1high(:,iJ);
        y = Ep1safe(:,iK);
        safe_high_mi(iJ,iK) = MutualInformation(x,y);
        clear x y;
        x = shuffle(:,iJ);
        y = shuffle(:,iK);
        safe_high_mi(iJ,iK) = MutualInformation(x,y);
        clear x y;
    end
end
x = nanmean(safe_low_mi);
mi_avgEp1safe_low = nanmean(x);
x = nanmean(safe_high_mi);
mi_avgEp1safe_high = nanmean(x);
x = nanmean(shuffle_mi);
mi_avg_shuffle = nanmean(x);
clear safe_high_mi safe_low_mi;

safe_low_mi = zeros(size(Ep2safe,1));
safe_high_mi = zeros(size(Ep2safe,1));
for iJ = 1:size(safe_low_mi,2)
    for iK = 1:size(safe_low_mi,2)
        x = Ep2low(:,iJ);
        y = Ep2safe(:,iK);
        safe_low_mi(iJ,iK) = MutualInformation(x,y);
        clear x y;
        x = Ep2high(:,iJ);
        y = Ep2safe(:,iK);
        safe_high_mi(iJ,iK) = MutualInformation(x,y);
        clear x y;
    end
end
x = nanmean(safe_low_mi);
mi_avgEp2safe_low = nanmean(x);
x = nanmean(safe_high_mi);
mi_avgEp2safe_high = nanmean(x);

end
