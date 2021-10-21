function out = pseudopop_choiceregress(input,Habiba)
%% Extract FR from mod rate and make pseudo-pop 
for iJ = 1:length(input)
start{iJ}.vars = input{iJ}.vars;
    if Habiba == 0
        start{iJ}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ}.E2FR = input{iJ}.psth(:,205:229);
        start{iJ}.E3FR = input{iJ}.psth(:,250:274);
    elseif Habiba == 1
        start{iJ}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ}.E2FR = input{iJ}.psth(:,193:217);
        start{iJ}.E3FR = input{iJ}.psth(:,225:249);
    end
end
start = start';

for iJ = 1:length(start)
    start{iJ}.FRcol(:,1) = FR_CollapseBins(start{iJ}.E1FR,25);
    start{iJ}.FRcol(:,2) = FR_CollapseBins(start{iJ}.E2FR,25);
    start{iJ}.FRcol(:,3) = FR_CollapseBins(start{iJ}.E3FR,25);

end

%recode vars to appropriate logistic
for iJ = 1:length(start)
    for iK = 1:length(start{iJ}.vars)
        if start{iJ}.vars(iK,9) == 2
            start{iJ}.vars(iK,9) = 0;
        end
    end
end
%% Make a single matrix of variables of interest
for iJ = 1:length(start)
    vars{iJ}(:,1) = start{iJ}.vars(:,9); %choice
    vars{iJ}(:,2) = start{iJ}.FRcol(:,1); %Epoch1 mFR
    vars{iJ}(:,3) = start{iJ}.FRcol(:,2); %Epoch2 mFR
    vars{iJ}(:,4) = start{iJ}.FRcol(:,3); %Epoch3 mFR
end
vars = vars';
clear start input iJ iK Habiba;

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
        elseif vars{iJ}(iK,1) == 0
            EV2(iK,1) = vars{iJ}(iK,1);
            EV1(iK,1) = NaN;
            EV2(iK,2) = vars{iJ}(iK,2);
            EV1(iK,2) = NaN;
            EV2(iK,3) = vars{iJ}(iK,3);
            EV1(iK,3) = NaN;
            EV2(iK,4) = vars{iJ}(iK,4);
            EV1(iK,4) = NaN;
        end
    end
    out1 = EV1(all(~isnan(EV1),2),:);
    out2 = EV2(all(~isnan(EV2),2),:);
    factors{iJ}.Choice1 = out1;
    factors{iJ}.Choice2 = out2;
    clear EV1 EV2 out1 out2 
end

factors = factors';
for iJ = 1:length(factors)
    rate(iJ,1) = length(factors{iJ}.Choice1)/(length(factors{iJ}.Choice1) + length(factors{iJ}.Choice2));
end
rate_C1 = mean(rate);
clear iJ iK vars clear rate;

%% Build matrix of pseudos
matrix_C1(1:500,1:length(factors)) = NaN;
matrix_C1(1:500,length(factors)+1) = 1;
matrix_C2(1:500,1:length(factors)) = NaN;
matrix_C2(1:500,length(factors)+1) = 0;

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
matrix_C1(1:500,1:length(factors)) = NaN;
matrix_C1(1:500,length(factors)+1) = 1;
matrix_C2(1:500,1:length(factors)) = NaN;
matrix_C2(1:500,length(factors)+1) = 0;

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
matrix_C1(1:500,1:length(factors)) = NaN;
matrix_C1(1:500,length(factors)+1) = 1;
matrix_C2(1:500,1:length(factors)) = NaN;
matrix_C2(1:500,length(factors)+1) = 0;

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

%% train model
mdl1 = fitcsvm(Epoch1_train(:,1:(end-1)),Epoch1_train(:,end));
% mdl1 = glmfit(Epoch1_train(:,1:(end-1)),Epoch1_train(:,end),'binomial','link','logit')';
% mdl2 = glmfit(Epoch2_train(:,1:(end-1)),Epoch2_train(:,end),'binomial','link','logit')';
% mdl3 = glmfit(Epoch3_train(:,1:(end-1)),Epoch3_train(:,end),'binomial','link','logit')';

%% test the model
predict1 = predict(mdl1,Epoch1_test(:,1:(end-1)));

%% check accuracy
predict1(:,2) = Epoch1_test(:,end);
for iJ = 1:length(predict1)
    if predict1(iJ,1) == predict1(iJ,2)
        predict1(iJ,3) = 1;
    else
        predict1(iJ,3) = 0;
    end
end
accuracy1 = sum(predict1(:,3))/length(predict1);
end
