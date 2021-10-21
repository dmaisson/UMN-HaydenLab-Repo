function [accuracy,accuracy_shuffle] = Classifier_TimeResolved(in,label)
% Labels
%   1) EV1 High/Low
%   2) EV2 High/Low
%   3) Choice
%   4) Chosen Side
%   5) Chosen EV
%   6) Unchosen EV

%% Starting variables
n = length(in);

for iJ = 1:n
    trialspikes{iJ,1} = in{iJ}.psth(:,150:299);
    trialvars{iJ,1}(:,1) = in{iJ}.vars(:,3); %EV1
    trialvars{iJ,1}(:,2) = in{iJ}.vars(:,6); %EV2
    trialvars{iJ,1}(:,3) = in{iJ}.vars(:,9); %Choice (1/2)
    trialvars{iJ,1}(:,4) = in{iJ}.vars(:,8); %ChoiseS (L/R)
    for iK = 1:size(in{iJ}.vars) %Chosen/Unchosen EV
        if in{iJ}.vars(iK,9) == 0 %if choice was second offer
            trialvars{iJ,1}(iK,5) = in{iJ}.vars(iK,6); %chosen EV
            trialvars{iJ,1}(iK,6) = in{iJ}.vars(iK,3); %unchosen EV
        elseif in{iJ}.vars(iK,9) == 1 %if choise was first offer
            trialvars{iJ,1}(iK,5) = in{iJ}.vars(iK,3);
            trialvars{iJ,1}(iK,6) = in{iJ}.vars(iK,6);
        end
    end
end
clear low high x probs in;

%% separate trials by label
for iJ = 1:n
    if label == 1
        meanEV1{iJ,1} = nanmean(trialvars{iJ}(:,1),1);
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,1) >= meanEV1{iJ}
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,1) <= meanEV1{iJ}
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    elseif label == 2
        meanEV2{iJ,1} = nanmean(trialvars{iJ}(:,2),1);
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,2) >= meanEV2{iJ}
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,2) <= meanEV2{iJ}
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    elseif label == 3
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,3) == 0 %if choice was first offer
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,3) == 1 %if choise was second offer
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    elseif label == 4
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,4) == 0 %if choiceS was Right
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,4) == 1 %if choiceS was Left
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    elseif label == 5
        meanEV_C{iJ,1} = nanmean(trialvars{iJ}(:,5),1); %average chosen EV
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,5) >= meanEV_C{iJ}
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,5) <= meanEV_C{iJ}
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    elseif label == 6
        meanEV_UC{iJ,1} = nanmean(trialvars{iJ}(:,6),1); %average Unchosen EV
        for iK = 1:length(trialvars{iJ})
            if trialvars{iJ}(iK,6) >= meanEV_UC{iJ}
                L1spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L2spikes{iJ,1}(iK,1:150) = NaN;
            elseif trialvars{iJ}(iK,6) <= meanEV_UC{iJ}
                L2spikes{iJ,1}(iK,:) = trialspikes{iJ,1}(iK,:);
                L1spikes{iJ,1}(iK,1:150) = NaN;
            end
        end
    end
end

clear trialspikes trialvars;

%% clear NaNs
for iJ = 1:n
    for iK = length(L1spikes{iJ}):-1:1
        if isnan(L1spikes{iJ}(iK,1))
            L1spikes{iJ}(iK,:) = [];
        end
    end
    for iK = length(L2spikes{iJ}):-1:1
        if isnan(L2spikes{iJ}(iK,1))
            L2spikes{iJ}(iK,:) = [];
        end
    end
end

%% Start Grand Loop
for iJ = 1:140
    % windows are 200ms, sliding by 20ms
    for iK = 1:n
        for iL = 1:size(L1spikes{iK},1)
            mFR_L1{iK,1}(iL,1) = nanmean(L1spikes{iK,1}(iL,iJ:iJ+9),2);
        end
        for iL = 1:size(L2spikes{iK},1)
            mFR_L2{iK,1}(iL,1) = nanmean(L2spikes{iK,1}(iL,iJ:iJ+9),2);
        end
    end
    
    %Build a matrix
    matrix_L1(1:1000,1:n) = NaN;
    matrix_L1(1:1000,n+1) = 0;
    matrix_L2(1:1000,1:n) = NaN;
    matrix_L2(1:1000,n+1) = 1;
    
    for iK = 1:size(matrix_L1,1) %for each of 1000 "trials"
        for iL = 1:n %for each neuron
            m = size(mFR_L1{iL},1);
            pick = randi(m,1);
            matrix_L1(iK,iL) = mFR_L1{iL}(pick,1);
        end
    end
    for iK = 1:size(matrix_L2,1) %for each of 1000 "trials"
        for iL = 1:n %for each neuron
            m = size(mFR_L2{iL},1);
            pick = randi(m,1);
            matrix_L2(iK,iL) = mFR_L2{iL}(pick,1);
        end
    end
    
    matrix_L1tr(1:(length(matrix_L1)/2),:) = matrix_L1(1:(length(matrix_L1)/2),:);
    matrix_L1te(1:(length(matrix_L1)/2),:) = matrix_L1((length(matrix_L1)/2)+1:end,:);
    matrix_L2tr(1:(length(matrix_L2)/2),:) = matrix_L2(1:(length(matrix_L2)/2),:);
    matrix_L2te(1:(length(matrix_L2)/2),:) = matrix_L2((length(matrix_L2)/2)+1:end,:);
    train = cat(1,matrix_L1tr,matrix_L2tr);
    test = cat(1,matrix_L1te,matrix_L2te);
    clear matrix_L1 matrix_L2 pick iK iL matrix_L1tr matrix_L1te matrix_L2tr matrix_L2te;


%% Shuffled matrices
    matrix_L1(1:1000,1:n+1) = NaN;
    matrix_L2(1:1000,1:n+1) = NaN;

    for iK = 1:size(matrix_L1,1)
        for iL = 1:size(matrix_L1,2)-1
            x = randi(2);
            if x == 1
                pick = randi(length(mFR_L1{iL}),1);
                matrix_L1(iK,iL) = mFR_L1{iL}(pick,1);
            elseif x == 2
                pick = randi(length(mFR_L2{iL}),1);
                matrix_L1(iK,iL) = mFR_L2{iL}(pick,1);
            end
        end
        x = randi(2);
        if x == 1
            matrix_L1(iK,end) = 0;
        elseif x == 2
            matrix_L1(iK,end) = 1;
        end
    end

    for iK = 1:size(matrix_L2,1)
        for iL = 1:size(matrix_L2,2)-1
            x = randi(2);
            if x == 1
                pick = randi(length(mFR_L1{iL}),1);
                matrix_L2(iK,iL) = mFR_L1{iL}(pick,1);
            elseif x == 2
                pick = randi(length(mFR_L2{iL}),1);
                matrix_L2(iK,iL) = mFR_L2{iL}(pick,1);
            end
        end
        x = randi(2);
        if x == 1
            matrix_L2(iK,end) = 0;
        elseif x == 2
            matrix_L2(iK,end) = 1;
        end
    end
    
    matrix_L1tr(1:(length(matrix_L1)/2),:) = matrix_L1(1:(length(matrix_L1)/2),:);
    matrix_L1te(1:(length(matrix_L1)/2),:) = matrix_L1((length(matrix_L1)/2)+1:end,:);
    matrix_L2tr(1:(length(matrix_L2)/2),:) = matrix_L2(1:(length(matrix_L2)/2),:);
    matrix_L2te(1:(length(matrix_L2)/2),:) = matrix_L2((length(matrix_L2)/2)+1:end,:);
    shuffle_train = cat(1,matrix_L1tr,matrix_L2tr);
    shuffle_test = cat(1,matrix_L1te,matrix_L2te);
    clear matrix_L1 matrix_L2 pick iK iL matrix_L1tr matrix_L1te matrix_L2tr matrix_L2te x pick;

%% train model
    mdl = fitcsvm(train(:,1:(end-1)),train(:,end));
    mdl_shuffle = fitcsvm(shuffle_train(:,1:(end-1)),shuffle_train(:,end));
    clear train shuffle_train;

%% test the model
    predict1 = predict(mdl,test(:,1:(end-1)));
    shuffle = predict(mdl_shuffle,shuffle_test(:,1:(end-1)));
    clear mdl mdl_shuffle;

%% check accuracy
    predict1(:,2) = test(:,end);
    for iK = 1:length(predict1)
        if predict1(iK,1) == predict1(iK,2)
            predict1(iK,3) = 1;
        else
            predict1(iK,3) = 0;
        end
    end
    %%%%%%%%
    shuffle(:,2) = shuffle_test(:,end);
    for iK = 1:length(shuffle)
        if shuffle(iK,1) == shuffle(iK,2)
            shuffle(iK,3) = 1;
        else
            shuffle(iK,3) = 0;
        end
    end

    accuracy(:,iJ) = sum(predict1(:,3))/length(predict1);
    accuracy_shuffle(:,iJ) = sum(shuffle(:,3))/length(shuffle);

    clear predict1 iK iL shuffle shuffle_test;

end

end
