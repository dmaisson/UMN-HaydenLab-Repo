function [accuracy1, accuracy2, accuracy3, accuracy4, accuracy5] = Classifier_SV_sigs(input)

%% Starting variables
safelowEp1 = input.safelow.Ep1;
safelowEp2 = input.safelow.Ep2;
safehighEp1 = input.safehigh.Ep1;
safehighEp2 = input.safehigh.Ep2;
lowEp1 = input.eqlowhalf.Ep1;
lowEp2 = input.eqlowhalf.Ep2;
highEp1 = input.eqhighhalf.Ep1;
highEp2 = input.eqhighhalf.Ep2;
n = length(safelowEp1);
clear low high x probs input;

%% Extract mFR
for iJ = 1:n
    mFRsafelow.Ep1{iJ,1} = nanmean(safelowEp1{iJ}.psth,2);
    mFRsafelow.Ep2{iJ,1} = nanmean(safelowEp2{iJ}.psth,2);
    mFRsafehigh.Ep1{iJ,1} = nanmean(safehighEp1{iJ}.psth,2);
    mFRsafehigh.Ep2{iJ,1} = nanmean(safehighEp2{iJ}.psth,2);
    mFRlow.Ep1{iJ,1} = nanmean(lowEp1{iJ}.psth,2);
    mFRlow.Ep2{iJ,1} = nanmean(lowEp2{iJ}.psth,2);
    mFRhigh.Ep1{iJ,1} = nanmean(highEp1{iJ}.psth,2);
    mFRhigh.Ep2{iJ,1} = nanmean(highEp2{iJ}.psth,2);
end
clear lowEp1 lowEp2 highEp1 highEp2 safeEp1 safeEp2;

%% clear NaNs from mFRs
for iJ = 1:n
    for iK = length(mFRsafelow.Ep1{iJ}):-1:1
        if isnan(mFRsafelow.Ep1{iJ}(iK,1))
            mFRsafelow.Ep1{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRsafelow.Ep2{iJ}):-1:1
        if isnan(mFRsafelow.Ep2{iJ}(iK,1))
            mFRsafelow.Ep2{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRsafehigh.Ep1{iJ}):-1:1
        if isnan(mFRsafehigh.Ep1{iJ}(iK,1))
            mFRsafehigh.Ep1{iJ}(iK,:) = [];
        end
    end
    for iK = length(mFRsafehigh.Ep2{iJ}):-1:1
        if isnan(mFRsafehigh.Ep2{iJ}(iK,1))
            mFRsafehigh.Ep2{iJ}(iK,:) = [];
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
matrix_C1(1:1000,1:n) = NaN;
matrix_C1(1:1000,n+1) = 1;
matrix_C2(1:1000,1:n) = NaN;
matrix_C2(1:1000,n+1) = 0;

for iJ = 1:size(matrix_C1,1) %for each of 1000 "trials"
    for iK = 1:size(matrix_C1,2)-1 %for each neuron
        try
            pick = randi(length(mFRsafelow.Ep1{iK}),1);
            matrix_C1(iJ,iK) = mFRsafelow.Ep1{iK}(pick,1);
        catch
            matrix_C1(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        try
            pick = randi(length(mFRlow.Ep1{iK}),1);
            matrix_C2(iJ,iK) = mFRlow.Ep1{iK}(pick,1);
        catch
            matrix_C2(iJ,iK) = NaN;
        end
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch1_safelow_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch1_safelow_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;

%% Safe Vs. Eq Low - EPOCH 2
matrix_C1(1:1000,1:n) = NaN;
matrix_C1(1:1000,n+1) = 1;
matrix_C2(1:1000,1:n) = NaN;
matrix_C2(1:1000,n+1) = 0;

for iJ = 1:size(matrix_C1,1) %for each of 1000 "trials"
    for iK = 1:size(matrix_C1,2)-1 %for each neuron
        try
            pick = randi(length(mFRsafelow.Ep2{iK}),1);
            matrix_C1(iJ,iK) = mFRsafelow.Ep2{iK}(pick,1);
        catch
            matrix_C1(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        try
            pick = randi(length(mFRlow.Ep2{iK}),1);
            matrix_C2(iJ,iK) = mFRlow.Ep2{iK}(pick,1);
        catch
            matrix_C2(iJ,iK) = NaN;
        end
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch2_safelow_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch2_safelow_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;

%% Safe Vs. Eq High - EPOCH 1
matrix_C1(1:1000,1:n) = NaN;
matrix_C1(1:1000,n+1) = 1;
matrix_C2(1:1000,1:n) = NaN;
matrix_C2(1:1000,n+1) = 0;

for iJ = 1:size(matrix_C1,1) %for each of 1000 "trials"
    for iK = 1:size(matrix_C1,2)-1 %for each neuron
        try
            pick = randi(length(mFRsafehigh.Ep1{iK}),1);
            matrix_C1(iJ,iK) = mFRsafehigh.Ep1{iK}(pick,1);
        catch
            matrix_C1(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        try
            pick = randi(length(mFRhigh.Ep1{iK}),1);
            matrix_C2(iJ,iK) = mFRhigh.Ep1{iK}(pick,1);
        catch
            matrix_C2(iJ,iK) = NaN;
        end
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch1_safehigh_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch1_safehigh_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;

%% Safe Vs. Eq Low - EPOCH 2
matrix_C1(1:1000,1:n) = NaN;
matrix_C1(1:1000,n+1) = 1;
matrix_C2(1:1000,1:n) = NaN;
matrix_C2(1:1000,n+1) = 0;

for iJ = 1:size(matrix_C1,1) %for each of 1000 "trials"
    for iK = 1:size(matrix_C1,2)-1 %for each neuron
        try
            pick = randi(length(mFRsafehigh.Ep2{iK}),1);
            matrix_C1(iJ,iK) = mFRsafehigh.Ep2{iK}(pick,1);
        catch
            matrix_C1(iJ,iK) = NaN;
        end
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        try
            pick = randi(length(mFRhigh.Ep2{iK}),1);
            matrix_C2(iJ,iK) = mFRhigh.Ep2{iK}(pick,1);
        catch
            matrix_C2(iJ,iK) = NaN;
        end
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch2_safehigh_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch2_safehigh_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;

%% Shuffled matrices
matrix_C1(1:1000,1:n+1) = NaN;
matrix_C2(1:1000,1:n+1) = NaN;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        x = randi(3); %randomly pick between safe, low, high
        if x == 1 %if randi is 1, use safe
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRsafelow.Ep1{iK}),1);
                    matrix_C1(iJ,iK) = mFRsafelow.Ep1{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRsafelow.Ep2{iK}),1);
                    matrix_C1(iJ,iK) = mFRsafelow.Ep2{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            end
        elseif x == 2 %if randi is 2, use low
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRlow.Ep1{iK}),1);
                    matrix_C1(iJ,iK) = mFRlow.Ep1{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRlow.Ep2{iK}),1);
                    matrix_C1(iJ,iK) = mFRlow.Ep2{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            end
        elseif x == 3 %if randi is 3, use high
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRhigh.Ep1{iK}),1);
                    matrix_C1(iJ,iK) = mFRhigh.Ep1{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRhigh.Ep2{iK}),1);
                    matrix_C1(iJ,iK) = mFRhigh.Ep2{iK}(pick,1);
                catch
                    matrix_C1(iJ,iK) = NaN;
                end
            end
        end
    end
    matrix_C1(iJ,end) = randi(2);
    if matrix_C1(iJ,end) == 2
        matrix_C1(iJ,end) = 0;
    end
end

for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        x = randi(3); %randomly pick between safe, low, high
        if x == 1 %if randi is 1, use safe
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRsafelow.Ep1{iK}),1);
                    matrix_C2(iJ,iK) = mFRsafelow.Ep1{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRsafelow.Ep2{iK}),1);
                    matrix_C2(iJ,iK) = mFRsafelow.Ep2{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            end
        elseif x == 2 %if randi is 2, use low
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRlow.Ep1{iK}),1);
                    matrix_C2(iJ,iK) = mFRlow.Ep1{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRlow.Ep2{iK}),1);
                    matrix_C2(iJ,iK) = mFRlow.Ep2{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            end
        elseif x == 3 %if randi is 3, use high
            y = randi(2); %randomly pick between Ep1 and Ep2
            if y == 1
                try
                    pick = randi(length(mFRhigh.Ep1{iK}),1);
                    matrix_C2(iJ,iK) = mFRhigh.Ep1{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            elseif y == 2
                try
                    pick = randi(length(mFRhigh.Ep2{iK}),1);
                    matrix_C2(iJ,iK) = mFRhigh.Ep2{iK}(pick,1);
                catch
                    matrix_C2(iJ,iK) = NaN;
                end
            end
        end
    end
    matrix_C2(iJ,end) = randi(2);
    if matrix_C2(iJ,end) == 2
        matrix_C2(iJ,end) = 0;
    end
end

matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
shuffle_train = cat(1,matrix_C1tr,matrix_C2tr);
shuffle_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te mFRsafe mFRlow mFRhigh x y n ans pick;

%% Clear NaNs
for iK = size(Epoch1_safelow_train,1):-1:1
    for iJ = size(Epoch1_safelow_train,2):-1:1
        if isnan(Epoch1_safelow_train(iK,iJ))
            Epoch1_safelow_train(:,iJ) = [];
            Epoch1_safehigh_train(:,iJ) = [];
            Epoch1_safelow_test(:,iJ) = [];
            Epoch1_safehigh_test(:,iJ) = [];
            Epoch2_safelow_train(:,iJ) = [];
            Epoch2_safehigh_train(:,iJ) = [];
            Epoch2_safelow_test(:,iJ) = [];
            Epoch2_safehigh_test(:,iJ) = [];
            shuffle_train(:,iJ) = [];
            shuffle_test(:,iJ) = [];
        end

        if isnan(Epoch2_safelow_train(iK,iJ))
            Epoch1_safelow_train(:,iJ) = [];
            Epoch1_safehigh_train(:,iJ) = [];
            Epoch1_safelow_test(:,iJ) = [];
            Epoch1_safehigh_test(:,iJ) = [];
            Epoch2_safelow_train(:,iJ) = [];
            Epoch2_safehigh_train(:,iJ) = [];
            Epoch2_safelow_test(:,iJ) = [];
            Epoch2_safehigh_test(:,iJ) = [];
            shuffle_train(:,iJ) = [];
            shuffle_test(:,iJ) = [];
        end
        
        if isnan(Epoch1_safehigh_train(iK,iJ))
            Epoch1_safelow_train(:,iJ) = [];
            Epoch1_safehigh_train(:,iJ) = [];
            Epoch1_safelow_test(:,iJ) = [];
            Epoch1_safehigh_test(:,iJ) = [];
            Epoch2_safelow_train(:,iJ) = [];
            Epoch2_safehigh_train(:,iJ) = [];
            Epoch2_safelow_test(:,iJ) = [];
            Epoch2_safehigh_test(:,iJ) = [];
            shuffle_train(:,iJ) = [];
            shuffle_test(:,iJ) = [];
        end

        if isnan(Epoch2_safehigh_train(iK,iJ))
            Epoch1_safelow_train(:,iJ) = [];
            Epoch1_safehigh_train(:,iJ) = [];
            Epoch1_safelow_test(:,iJ) = [];
            Epoch1_safehigh_test(:,iJ) = [];
            Epoch2_safelow_train(:,iJ) = [];
            Epoch2_safehigh_train(:,iJ) = [];
            Epoch2_safelow_test(:,iJ) = [];
            Epoch2_safehigh_test(:,iJ) = [];
            shuffle_train(:,iJ) = [];
            shuffle_test(:,iJ) = [];
        end
    end
end

%% train model
mdl1 = fitcsvm(Epoch1_safelow_train(:,1:(end-1)),Epoch1_safelow_train(:,end));
mdl2 = fitcsvm(Epoch2_safelow_train(:,1:(end-1)),Epoch2_safelow_train(:,end));
mdl3 = fitcsvm(Epoch1_safehigh_train(:,1:(end-1)),Epoch1_safehigh_train(:,end));
mdl4 = fitcsvm(Epoch2_safehigh_train(:,1:(end-1)),Epoch2_safehigh_train(:,end));
mdl_shuffle = fitcsvm(shuffle_train(:,1:(end-1)),shuffle_train(:,end));
clear Epoch1_safelow_train Epoch2_safelow_train Epoch1_safehigh_train Epoch2_safehigh_train shuffle_train;

%% test the model
predict1 = predict(mdl1,Epoch1_safelow_test(:,1:(end-1)));
predict2 = predict(mdl2,Epoch2_safelow_test(:,1:(end-1)));
predict3 = predict(mdl3,Epoch1_safehigh_test(:,1:(end-1)));
predict4 = predict(mdl4,Epoch2_safehigh_test(:,1:(end-1)));
shuffle = predict(mdl_shuffle,shuffle_test(:,1:(end-1)));
clear mdl1 mdl2 mdl3 mdl4 mdl_shuffle;

%% check accuracy
predict1(:,2) = Epoch1_safelow_test(:,end);
for iJ = 1:length(predict1)
    if predict1(iJ,1) == predict1(iJ,2)
        predict1(iJ,3) = 1;
    else
        predict1(iJ,3) = 0;
    end
end
%%%%%%%%
predict2(:,2) = Epoch2_safelow_test(:,end);
for iJ = 1:length(predict2)
    if predict2(iJ,1) == predict2(iJ,2)
        predict2(iJ,3) = 1;
    else
        predict2(iJ,3) = 0;
    end
end
%%%%%%%%
predict3(:,2) = Epoch1_safehigh_test(:,end);
for iJ = 1:length(predict3)
    if predict3(iJ,1) == predict3(iJ,2)
        predict3(iJ,3) = 1;
    else
        predict3(iJ,3) = 0;
    end
end
%%%%%%%%
predict4(:,2) = Epoch2_safehigh_test(:,end);
for iJ = 1:length(predict4)
    if predict4(iJ,1) == predict4(iJ,2)
        predict4(iJ,3) = 1;
    else
        predict4(iJ,3) = 0;
    end
end
%%%%%%%%
shuffle(:,2) = shuffle_test(:,end);
for iJ = 1:length(shuffle)
    if shuffle(iJ,1) == shuffle(iJ,2)
        shuffle(iJ,3) = 1;
    else
        shuffle(iJ,3) = 0;
    end
end

accuracy1 = sum(predict1(:,3))/length(predict1);
accuracy2 = sum(predict2(:,3))/length(predict2);
accuracy3 = sum(predict3(:,3))/length(predict3);
accuracy4 = sum(predict4(:,3))/length(predict4);
accuracy5 = sum(shuffle(:,3))/length(shuffle);

clear predict1 predict2 predict3 predict4 iJ Epoch1_test Epoch2_test Epoch3_test shuffle shuffle_test;

end
