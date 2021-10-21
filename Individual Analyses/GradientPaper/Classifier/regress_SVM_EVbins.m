function accuracy = regress_SVM_EVbins(in,token)
%% setup starting matrix
x = 0.01:0.01:3;
bins = 6;
binsize = length(x)/bins;
for iJ = 1:bins
    if iJ == 1
        EVbin(iJ,:) = x(:,1:binsize);
    else
        EVbin(iJ,:) = x(:,(binsize*(iJ-1))+1:binsize*iJ);
    end
end
clear iJ;

if token == 0
    for iJ = 1:length(in)
        for iK = 1:length(in{iJ}.vars)
            for iL = 1:bins
                if in{iJ}.vars(iK,3) >= EVbin(iL,1) && in{iJ}.vars(iK,3) <= EVbin(iL,end)
                    data{iJ,1}.EV1bin{iL,1}.vars(iK,:) = in{iJ}.vars(iK,:);
                    data{iJ,1}.EV1bin{iL,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                else
                    data{iJ,1}.EV1bin{iL,1}.vars(iK,1:size(in{iJ}.vars,2)) = NaN;
                    data{iJ,1}.EV1bin{iL,1}.psth(iK,1:25) = NaN;
                end
                if in{iJ}.vars(iK,6) >= EVbin(iL,1) && in{iJ}.vars(iK,6) <= EVbin(iL,end)
                    data{iJ,1}.EV2bin{iL,1}.vars(iK,:) = in{iJ}.vars(iK,:);
                    data{iJ,1}.EV2bin{iL,1}.psth(iK,:) = in{iJ}.psth(iK,205:229);
                else
                    data{iJ,1}.EV2bin{iL,1}.vars(iK,1:size(in{iJ}.vars,2)) = NaN;
                    data{iJ,1}.EV2bin{iL,1}.psth(iK,1:25) = NaN;
                end
            end
        end
    end
elseif token == 1
    for iJ = 1:length(in)
        for iK = 1:length(in{iJ}.vars)
            for iL = 1:bins
                if in{iJ}.vars(iK,3) >= EVbin(iL,1) && in{iJ}.vars(iK,3) <= EVbin(iL,end)
                    data{iJ,1}.EV1bin{iL,1}.vars(iK,:) = in{iJ}.vars(iK,:);
                    data{iJ,1}.EV1bin{iL,1}.psth(iK,:) = in{iJ}.psth(iK,155:179);
                else
                    data{iJ,1}.EV1bin{iL,1}.vars(iK,1:size(in{iJ}.vars,2)) = NaN;
                    data{iJ,1}.EV1bin{iL,1}.psth(iK,1:25) = NaN;
                end
                if in{iJ}.vars(iK,6) >= EVbin(iL,1) && in{iJ}.vars(iK,6) <= EVbin(iL,end)
                    data{iJ,1}.EV2bin{iL,1}.vars(iK,:) = in{iJ}.vars(iK,:);
                    data{iJ,1}.EV2bin{iL,1}.psth(iK,:) = in{iJ}.psth(iK,193:217);
                else
                    data{iJ,1}.EV2bin{iL,1}.vars(iK,1:size(in{iJ}.vars,2)) = NaN;
                    data{iJ,1}.EV2bin{iL,1}.psth(iK,1:25) = NaN;
                end
            end
        end
    end
end

for iJ = 1:length(data)
    for iK = 1:length(data{iJ}.EV1bin)
        for iL = size(data{iJ}.EV1bin{iK}.vars,1):-1:1
            if isnan(data{iJ}.EV1bin{iK}.vars(iL,1))
                data{iJ}.EV1bin{iK}.vars(iL,:) = [];
                data{iJ}.EV1bin{iK}.psth(iL,:) = [];
            end
        end
        for iL = size(data{iJ}.EV2bin{iK}.vars,1):-1:1
            if isnan(data{iJ}.EV2bin{iK}.vars(iL,1))
                data{iJ}.EV2bin{iK}.vars(iL,:) = [];
                data{iJ}.EV2bin{iK}.psth(iL,:) = [];
            end
        end
    end
end

for iJ = 1:length(data)
    for iK = 1:length(data{iJ}.EV1bin)
        for iL = size(data{iJ}.EV1bin{iK}.psth,1):-1:1
            if isnan(data{iJ}.EV1bin{iK}.psth(iL,1))
                data{iJ}.EV1bin{iK}.vars(iL,:) = [];
                data{iJ}.EV1bin{iK}.psth(iL,:) = [];
            end
        end
        for iL = size(data{iJ}.EV2bin{iK}.psth,1):-1:1
            if isnan(data{iJ}.EV2bin{iK}.psth(iL,1))
                data{iJ}.EV2bin{iK}.vars(iL,:) = [];
                data{iJ}.EV2bin{iK}.psth(iL,:) = [];
            end
        end
    end
end

clearvars -except data;

%% create pseudopop
label = 1:length(data{1}.EV1bin);
n = length(data);
matrix(1:length(label),1:n) = NaN;
matrix(:,end+1) = (1:length(label));
n1 = 1200/length(label);

for iJ = 1:n1 %for each label grouping
    for iK = 1:n %for each cell
        for iL = 1:length(label) %for each bin
            r = randi(size(data{iK}.EV1bin{iL}.vars,1)); % randomly select a trial
            matrix(iL,iK) = nanmean(data{iK}.EV1bin{iL}.psth(r,:),2); %populate the matrix with that trial data
        end
    end
    if iJ == 1
        matrix_C1 = matrix;
    else
        matrix_C1 = cat(1,matrix_C1,matrix);
    end
end

EV1_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
EV1_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
clear matrix matrix_C1 iJ iK iL r x ans iJ iL iK;

%% create pseudopop
label = 1:length(data{1}.EV2bin);
n = length(data);
matrix(1:length(label),1:n) = NaN;
matrix(:,end+1) = (1:length(label));
n1 = 1200/length(label);

for iJ = 1:n1 %for each label grouping
    for iK = 1:n %for each cell
        for iL = 1:length(label) %for each bin
            r = randi(size(data{iK}.EV2bin{iL}.vars,1)); % randomly select a trial
            matrix(iL,iK) = nanmean(data{iK}.EV2bin{iL}.psth(r,:),2); %populate the matrix with that trial data
        end
    end
    if iJ == 1
        matrix_C1 = matrix;
    else
        matrix_C1 = cat(1,matrix_C1,matrix);
    end
end

EV2_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
EV2_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
clear matrix iJ iK iL r x ans iJ iL iK;

%% shuffled
shuffle1(1:size(matrix_C1,1),1:size(matrix_C1,2)) = NaN;
for iJ = 1:size(matrix_C1,1) %for the number of pseudotrials
    for iK = 1:size(matrix_C1,2)-1 %for the number of cells
        r1 = randi(size(data,1)); %random cell number
        r2 = randi(size(data{r1},1)); %random trial number
        r3 = randi(2);
        r4 = randi(length(label));
        if r3 == 1
            shuffle1(iJ,iK) = nanmean(data{r1}.EV1bin{r4}.psth(r2,:));
        elseif r3 == 2
            shuffle1(iJ,iK) = nanmean(data{r1}.EV2bin{r4}.psth(r2,:));
        end
    end
    shuffle1(iJ,end) = randi(length(label));
end

shuffle_tr(1:(length(matrix_C1)/2),:) = shuffle1(1:(length(matrix_C1)/2),:);
shuffle_te(1:(length(matrix_C1)/2),:) = shuffle1((length(matrix_C1)/2)+1:end,:);
clear shuffle1 r1 r2 r3 iJ iK iL label matrix_C1;

%% train and test
Mdl1 = fitrsvm(EV1_C1tr(:,1:n),EV1_C1tr(:,end));
yfit1 = predict(Mdl1,EV1_C1te(:,1:n));
Mdl2 = fitrsvm(EV2_C1tr(:,1:n),EV2_C1tr(:,end));
yfit2 = predict(Mdl2,EV2_C1te(:,1:n));
Mdl_shuffle = fitrsvm(shuffle_tr(:,1:n),shuffle_tr(:,end));
yfit_shuffle = predict(Mdl_shuffle,shuffle_te(:,1:n));

%% check accuracy
predictions(:,1) = round(yfit1);
predictions(:,2) = EV1_C1te(:,end);
for iJ = 1:length(predictions)
%     if binsize == 20
%         if predictions(iJ,1) >= predictions(iJ,2)-1 && predictions(iJ,1) <= predictions(iJ,2)+1
%             predictions(iJ,3) = 1;
%         else
%             predictions(iJ,3) = 0;
%         end
%     else
        if predictions(iJ,1) == predictions(iJ,2)
            predictions(iJ,3) = 1;
        else
            predictions(iJ,3) = 0;
        end
%     end
end
accuracy(1,1) = (sum(predictions(:,3))/size(predictions,1))*100;
clear predictions;

predictions(:,1) = round(yfit2);
predictions(:,2) = EV2_C1te(:,end);
for iJ = 1:length(predictions)
%     if binsize == 20
%         if predictions(iJ,1) >= predictions(iJ,2)-1 && predictions(iJ,1) <= predictions(iJ,2)+1
%             predictions(iJ,3) = 1;
%         else
%             predictions(iJ,3) = 0;
%         end
%     else
        if predictions(iJ,1) == predictions(iJ,2)
            predictions(iJ,3) = 1;
        else
            predictions(iJ,3) = 0;
        end
%     end
end
accuracy(1,2) = (sum(predictions(:,3))/size(predictions,1))*100;

predict_shuff(:,1) = round(yfit_shuffle);
predict_shuff(:,2) = shuffle_te(:,end);
for iJ = 1:length(predict_shuff)
%     if binsize == 20
%         if predictions(iJ,1) >= predictions(iJ,2)-1 && predictions(iJ,1) <= predictions(iJ,2)+1
%             predictions(iJ,3) = 1;
%         else
%             predictions(iJ,3) = 0;
%         end
%     else
        if predict_shuff(iJ,1) == predict_shuff(iJ,2)
            predict_shuff(iJ,3) = 1;
        else
            predict_shuff(iJ,3) = 0;
        end
%     end
end
accuracy(1,3) = (sum(predict_shuff(:,3))/size(predict_shuff,1))*100;

end

