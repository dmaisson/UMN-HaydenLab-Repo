function accuracy = regress_SVM_pretrial(in,binsize)
%% setup starting matrix
if binsize == 20
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        data{iJ,1}(iK,:) = in{iJ}.psth(iK,125:149);
    end
end
elseif binsize == 40
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        data{iJ,1}(iK,:) = FR_CollapseBins(in{iJ}.psth(iK,125:149),2);
    end
end
elseif binsize == 60
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        data{iJ,1}(iK,:) = FR_CollapseBins(in{iJ}.psth(iK,125:149),3);
    end
end
elseif binsize == 80
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        data{iJ,1}(iK,:) = FR_CollapseBins(in{iJ}.psth(iK,125:149),4);
    end
end
elseif binsize == 100
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        data{iJ,1}(iK,:) = FR_CollapseBins(in{iJ}.psth(iK,125:149),5);
    end
end
end
clear in iJ iK;

%% create pseudopop
timelabel = (1:size(data{1},2))';
n = length(data);
matrix(1:length(timelabel),1:n) = NaN;
matrix(:,end+1) = (1:length(timelabel));
clear x k j i;
n1 = 1000/length(timelabel);

for iL = 1:n1
    if iL == 1
        for iJ = 1:size(matrix,1)%for the number of timelabels
            for iK = 1:length(data) %for the number of cells
                r = randi(size(data{iK},1)); %generate a random trial number from that cell
                matrix(iJ,iK) = data{iK}(r,iJ); %populate the matrix with the data from that cell, and that timelabel, with the randomly choice trial data
            end
        end
        matrix_C1 = matrix;
    else
        matrix_C1 = cat(1,matrix_C1,matrix);
    end
end

matrix_C1tr(1:(length(matrix_C1)/2),:) = matrix_C1(1:(length(matrix_C1)/2),:);
matrix_C1te(1:(length(matrix_C1)/2),:) = matrix_C1((length(matrix_C1)/2)+1:end,:);
clear matrix n1 iJ iK iL timelabel;
timelabel = (1:size(data{1},2))';
n = length(data);
clear x k j i;
n1 = 1000/length(timelabel);

%% shuffled
shuffle1(1:size(matrix_C1,1),1:size(matrix_C1,2)) = NaN;
for iJ = 1:size(matrix_C1,1) %for the number of pseudotrials
    for iK = 1:size(matrix_C1,2)-1 %for the number of cells
        r1 = randi(size(data,1)); %random cell number
        r2 = randi(size(data{r1},1)); %random trial number
        r3 = randi(size(data{r1},2)); %random time bin
        shuffle1(iJ,iK) = data{r1}(r2,r3);
    end
    shuffle1(iJ,end) = randi(size(data{r1},2));
end

shuffle_tr(1:(length(matrix_C1)/2),:) = shuffle1(1:(length(matrix_C1)/2),:);
shuffle_te(1:(length(matrix_C1)/2),:) = shuffle1((length(matrix_C1)/2)+1:end,:);
clear shuffle1 r1 r2 r3 iJ iK iL timelabel matrix_C1;

%% train and test
Mdl = fitrsvm(matrix_C1tr(:,1:n),matrix_C1tr(:,end));
yfit = predict(Mdl,matrix_C1te(:,1:n));
Mdl_shuffle = fitrsvm(shuffle_tr(:,1:n),shuffle_tr(:,end));
yfit_shuffle = predict(Mdl_shuffle,shuffle_te(:,1:n));

%% check accuracy
predictions(:,1) = round(yfit);
predictions(:,2) = matrix_C1te(:,end);
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
accuracy(1,2) = (sum(predict_shuff(:,3))/size(predict_shuff,1))*100;

end

