function [accuracy1, accuracy2, accuracy3, accuracy4, accuracy5] = Classifier_down(input,token,label,sub)
% A function for using a Linear Classifier (binary-class SVM) to decode
% binary variable class from mean neural data (using pseudo-population of
% pseudo-samples). This is function is built to work with another that
% allows for stipulating the total number of iterations to run. That
% higher-order function, however, is not manditory.

% Input:
% "input" = the original data, in the format of cell{:}.psth(:)
% "token" = a flag for which of the two versions of StagOps was being used to
%       generate the data
%           standard stagops: token = 0;
%           token stagops: token = 1;
% "label" = which of the variables to decoded
%   label will determine which of the binary variable to use for the
%   classifier:
%       1 = choice 1 or 2;
%       2 = side of first;
%       3 = side of choice;
%       4 = EV1 size;
%       5 = EV2 size;
%       6 = EV difference;
%       7 = chosen value;
%       8 = choice on previous;
%       9 = chosen side on previous
% "sub" = the number of cells to down-sample your population to (for making
%   number of cells even across multiple brain areas)

% Output:
%   5 different accuracy scores (only separated here into 5 variables
%   because of how this script interacts with the iteration script and the
%   parallel-processing structure therein): reported in % format (% of
%   predicted classes that matched the known class in the cross-validation
%   test set).
%       accuracy1 = accuracy of decode in epoch1
%       accuracy2 = accuracy of decode in epoch2
%       accuracy3 = accuracy of decode in choice epoch
%       accuracy4 = accuracy of decode in reward epoch
%       accuracy5 = accuracy of decode for SHUFFLED data

%% Extract FR from mod rate and make pseudo-pop 
n = sub; 
r = randperm(length(input),n); %for down-sampling number of neurons to common amount.

for iJ = 1:n
start{iJ,1}.vars = input{r(iJ)}.vars;
    if token == 0
        start{iJ,1}.E1FR = input{r(iJ)}.psth(:,155:179);
        start{iJ,1}.E2FR = input{r(iJ)}.psth(:,205:229);
        start{iJ,1}.E3FR = input{r(iJ)}.psth(:,250:274);
        start{iJ,1}.E4FR = input{r(iJ)}.psth(:,265:289);
    elseif token == 1
        start{iJ,1}.E1FR = input{r(iJ)}.psth(:,155:179);
        start{iJ,1}.E2FR = input{r(iJ)}.psth(:,193:217);
        start{iJ,1}.E3FR = input{r(iJ)}.psth(:,225:249);
        start{iJ,1}.E4FR = input{r(iJ)}.psth(:,240:264);
    end
end

for iJ = 1:length(start)
    start{iJ}.FRcol(:,1) = FR_CollapseBins(start{iJ}.E1FR,25);
    start{iJ}.FRcol(:,2) = FR_CollapseBins(start{iJ}.E2FR,25);
    start{iJ}.FRcol(:,3) = FR_CollapseBins(start{iJ}.E3FR,25);
    start{iJ}.FRcol(:,4) = FR_CollapseBins(start{iJ}.E4FR,25);
end

%recode vars to appropriate logistic
for iJ = 1:length(start)
    for iK = 1:length(start{iJ}.vars)
        if start{iJ}.vars(iK,9) == 2
            start{iJ}.vars(iK,9) = 0;
        end
        if start{iJ}.vars(iK,7) == 2
            start{iJ}.vars(iK,7) = 0;
        end
        if start{iJ}.vars(iK,8) == 2
            start{iJ}.vars(iK,8) = 0;
        end
        if label == 5 || label == 6
            valdiff{iJ,1}(iK,1) = start{iJ}.vars(iK,6) - start{iJ}.vars(iK,3);
        end
    end
end

%% Make a single matrix of variables of interest
for iJ = 1:length(start)
    if label == 1
        vars{iJ}(:,1) = start{iJ}.vars(:,9); %choice
    elseif label == 2
        vars{iJ}(:,1) = start{iJ}.vars(:,7); %side of first
    elseif label == 3
        vars{iJ}(:,1) = start{iJ}.vars(:,8); %side of choice
    elseif label == 4
        meanEV1{iJ,1} = nanmean(start{iJ}.vars(:,3),1);
        for iK = 1:length(start{iJ}.vars)
            if start{iJ}.vars(iK,3) > meanEV1{iJ}
                vars{iJ}(iK,1) = 1; %EV1 (larger/smaller than mean)
            elseif start{iJ}.vars(iK,3) <= meanEV1{iJ}
                vars{iJ}(iK,1) = 0; %EV1 (larger/smaller than mean)
            end
        end
    elseif label == 5
        meanEV2{iJ,1} = nanmean(start{iJ}.vars(:,6),1);
        for iK = 1:length(start{iJ}.vars)
            if start{iJ}.vars(iK,6) > meanEV2{iJ}
                vars{iJ}(iK,1) = 1; %EV2 (larger/smaller than mean)
            elseif start{iJ}.vars(iK,6) <= meanEV2{iJ}
                vars{iJ}(iK,1) = 0; %EV2 (larger/smaller than mean)
            end
        end
    elseif label == 6
        meanvaldiff{iJ,1} = nanmean(valdiff{iJ}(:,1),1);
        for iK = 1:length(start{iJ}.vars)
            if valdiff{iJ}(iK,1) > meanvaldiff{iJ}
                vars{iJ}(iK,1) = 1; %EVdiff (larger/smaller than mean)
            elseif valdiff{iJ}(iK,1) <= meanvaldiff{iJ}
                vars{iJ}(iK,1) = 0; %EVdiff (larger/smaller than mean)
            end
        end
    elseif label == 7 %chosen value
        for iK = 1:length(start{iJ}.vars)
            if start{iJ}.vars(iK,9) == 1
                EVchoice{iJ}(iK,1) = start{iJ}.vars(iK,3);
            elseif start{iJ}.vars(iK,9) == 0
                EVchoice{iJ}(iK,1) = start{iJ}.vars(iK,6);
            end
        end
        meanEVchoice{iJ,1} = nanmean(EVchoice{iJ}(:,1),1);
        for iK = 1:length(start{iJ}.vars)
            if start{iJ}.vars(iK,9) == 1
                if start{iJ}.vars(iK,3) > meanEVchoice{iJ}
                    vars{iJ}(iK,1) = 1; %EVchoice (larger/smaller than mean)
                elseif start{iJ}.vars(iK,3) <= meanEVchoice{iJ}
                    vars{iJ}(iK,1) = 0; %EVchoice (larger/smaller than mean)
                end
            elseif start{iJ}.vars(iK,9) == 0
                if start{iJ}.vars(iK,6) > meanEVchoice{iJ}
                    vars{iJ}(iK,1) = 1; %EVchoice (larger/smaller than mean)
                elseif start{iJ}.vars(iK,6) <= meanEVchoice{iJ}
                    vars{iJ}(iK,1) = 0; %EVchoice (larger/smaller than mean)
                end
            end
        end
    elseif label == 8 %choice on previous trial
        for iK = 1:length(start{iJ}.vars)
            if iK == 1
                vars{iJ}(iK,1) = start{iJ}.vars(iK,9);
            else
                vars{iJ}(iK,1) = start{iJ}.vars(iK-1,9);
            end
        end
    elseif label == 9 %chosen side on previous trial
        for iK = 1:length(start{iJ}.vars)
            if iK == 1
                vars{iJ}(iK,1) = start{iJ}.vars(iK,8);
            else
                vars{iJ}(iK,1) = start{iJ}.vars(iK-1,8);
            end
        end
    end
    vars{iJ}(:,2) = start{iJ}.FRcol(:,1); %Epoch1 mFR
    vars{iJ}(:,3) = start{iJ}.FRcol(:,2); %Epoch2 mFR
    vars{iJ}(:,4) = start{iJ}.FRcol(:,3); %Epoch3 mFR
    vars{iJ}(:,5) = start{iJ}.FRcol(:,4); %Epoch4 mFR
end
vars = vars';
clear start input iJ iK Habiba rand_label label meanEV1;

%% Separate choices for each cell
for iJ = 1:length(vars)
    for iK = 1:length(vars{iJ})
        if vars{iJ}(iK,1) == 1
            EV1(iK,1) = vars{iJ}(iK,1);
            EV2(iK,1) = NaN;
            EV1(iK,2) = vars{iJ}(iK,2);
            EV2(iK,2) = NaN;
            EV1(iK,3) = vars{iJ}(iK,3);
            EV2(iK,3) = NaN;
            EV1(iK,4) = vars{iJ}(iK,4);
            EV2(iK,4) = NaN;
            EV1(iK,5) = vars{iJ}(iK,5);
            EV2(iK,5) = NaN;
        elseif vars{iJ}(iK,1) == 0
            EV2(iK,1) = vars{iJ}(iK,1);
            EV1(iK,1) = NaN;
            EV2(iK,2) = vars{iJ}(iK,2);
            EV1(iK,2) = NaN;
            EV2(iK,3) = vars{iJ}(iK,3);
            EV1(iK,3) = NaN;
            EV2(iK,4) = vars{iJ}(iK,4);
            EV1(iK,4) = NaN;
            EV2(iK,5) = vars{iJ}(iK,5);
            EV1(iK,5) = NaN;
        end
    end
    out1 = EV1(all(~isnan(EV1),2),:);
    out2 = EV2(all(~isnan(EV2),2),:);
    factors{iJ}.Choice1 = out1;
    factors{iJ}.Choice2 = out2;
    clear EV1 EV2 out1 out2 
end
factors = factors';
clear vars iJ iK token;
%% DOWNSAMPLE - random withOUT replication
% n = 125;
% s = randperm(length(start),n);
% 
% for iJ = 1:n
%     factors{iJ,1} = start{s(iJ)};
% end
% clear s n start iJ;

%% Build matrix of pseudos
matrix_C1(1:1000,1:length(factors)) = NaN;
matrix_C1(1:1000,length(factors)+1) = 1;
matrix_C2(1:1000,1:length(factors)) = NaN;
matrix_C2(1:1000,length(factors)+1) = 0;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        pick = randi(length(factors{iK}.Choice1),1);
        matrix_C1(iJ,iK) = factors{iK}.Choice1(pick,2);
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        pick = randi(length(factors{iK}.Choice2),1);
        matrix_C2(iJ,iK) = factors{iK}.Choice2(pick,2);
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch1_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch1_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;
%%%%%%%%%
matrix_C1(1:1000,1:length(factors)) = NaN;
matrix_C1(1:1000,length(factors)+1) = 1;
matrix_C2(1:1000,1:length(factors)) = NaN;
matrix_C2(1:1000,length(factors)+1) = 0;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        pick = randi(length(factors{iK}.Choice1),1);
        matrix_C1(iJ,iK) = factors{iK}.Choice1(pick,3);
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        pick = randi(length(factors{iK}.Choice2),1);
        matrix_C2(iJ,iK) = factors{iK}.Choice2(pick,3);
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch2_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch2_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;
%%%%%%%%%
matrix_C1(1:1000,1:length(factors)) = NaN;
matrix_C1(1:1000,length(factors)+1) = 1;
matrix_C2(1:1000,1:length(factors)) = NaN;
matrix_C2(1:1000,length(factors)+1) = 0;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        pick = randi(length(factors{iK}.Choice1),1);
        matrix_C1(iJ,iK) = factors{iK}.Choice1(pick,4);
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        pick = randi(length(factors{iK}.Choice2),1);
        matrix_C2(iJ,iK) = factors{iK}.Choice2(pick,4);
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch3_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch3_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;
%%%%%%%%%
matrix_C1(1:1000,1:length(factors)) = NaN;
matrix_C1(1:1000,length(factors)+1) = 1;
matrix_C2(1:1000,1:length(factors)) = NaN;
matrix_C2(1:1000,length(factors)+1) = 0;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        pick = randi(length(factors{iK}.Choice1),1);
        matrix_C1(iJ,iK) = factors{iK}.Choice1(pick,5);
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        pick = randi(length(factors{iK}.Choice2),1);
        matrix_C2(iJ,iK) = factors{iK}.Choice2(pick,5);
    end
end
matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
matrix_C2tr(1:(length(matrix_C2)/2),:) = matrix_C2(1:(length(matrix_C2)/2),:);
matrix_C2te(1:(length(matrix_C2)/2),:) = matrix_C2((length(matrix_C2)/2)+1:end,:);
Epoch4_train = cat(1,matrix_C1tr,matrix_C2tr);
Epoch4_test = cat(1,matrix_C1te,matrix_C2te);
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te;
%%%%%%%%%
matrix_C1(1:1000,1:length(factors)+1) = NaN;
matrix_C2(1:1000,1:length(factors)+1) = NaN;

for iJ = 1:size(matrix_C1,1)
    for iK = 1:size(matrix_C1,2)-1
        pick1 = randi(length(factors{iK}.Choice1),1);
        pick2 = randi([2 5]);
        matrix_C1(iJ,iK) = factors{iK}.Choice1(pick1,pick2);
    end
    matrix_C1(iJ,end) = randi(2);
    if matrix_C1(iJ,end) == 2
        matrix_C1(iJ,end) = 0;
    end
end
for iJ = 1:size(matrix_C2,1)
    for iK = 1:size(matrix_C2,2)-1
        pick1 = randi(length(factors{iK}.Choice2),1);
        pick2 = randi([2 5]);
        matrix_C2(iJ,iK) = factors{iK}.Choice2(pick1,pick2);
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
clear matrix_C1 matrix_C2 pick iJ iK matrix_C1tr matrix_C1te matrix_C2tr matrix_C2te factors pick1 pick2;

%% train model
mdl1 = fitcsvm(Epoch1_train(:,1:(end-1)),Epoch1_train(:,end));
mdl2 = fitcsvm(Epoch2_train(:,1:(end-1)),Epoch2_train(:,end));
mdl3 = fitcsvm(Epoch3_train(:,1:(end-1)),Epoch3_train(:,end));
mdl4 = fitcsvm(Epoch4_train(:,1:(end-1)),Epoch4_train(:,end));
mdl_shuffle = fitcsvm(shuffle_train(:,1:(end-1)),shuffle_train(:,end));
clear Epoch1_train Epoch2_train Epoch3_train shuffle_train;

%% test the model
predict1 = predict(mdl1,Epoch1_test(:,1:(end-1)));
predict2 = predict(mdl2,Epoch2_test(:,1:(end-1)));
predict3 = predict(mdl3,Epoch3_test(:,1:(end-1)));
predict4 = predict(mdl4,Epoch4_test(:,1:(end-1)));
shuffle = predict(mdl_shuffle,shuffle_test(:,1:(end-1)));
clear mdl1 mdl2 mdl3 mdl_shuffle;

%% check accuracy
predict1(:,2) = Epoch1_test(:,end);
for iJ = 1:length(predict1)
    if predict1(iJ,1) == predict1(iJ,2)
        predict1(iJ,3) = 1;
    else
        predict1(iJ,3) = 0;
    end
end
%%%%%%%%
predict2(:,2) = Epoch2_test(:,end);
for iJ = 1:length(predict2)
    if predict2(iJ,1) == predict2(iJ,2)
        predict2(iJ,3) = 1;
    else
        predict2(iJ,3) = 0;
    end
end
%%%%%%%%
predict3(:,2) = Epoch3_test(:,end);
for iJ = 1:length(predict3)
    if predict3(iJ,1) == predict3(iJ,2)
        predict3(iJ,3) = 1;
    else
        predict3(iJ,3) = 0;
    end
end
%%%%%%%%
predict4(:,2) = Epoch4_test(:,end);
for iJ = 1:length(predict4)
    if predict4(iJ,1) == predict4(iJ,2)
        predict4(iJ,3) = 1;
    else
        predict4(iJ,3) = 0;
    end
end
%%%%%%%%
shuffle(:,2) = Epoch3_test(:,end);
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

clear predict1 predict2 predict3 iJ Epoch1_test Epoch2_test Epoch3_test shuffle shuffle_test;

end
