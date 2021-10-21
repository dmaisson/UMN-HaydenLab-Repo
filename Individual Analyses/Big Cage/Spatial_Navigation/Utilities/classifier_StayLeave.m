function [accuracy,accuracy_shuffle] = classifier_StayLeave(svmData_stay,svmData_leave,sliding_window,start,epoch)
for iI = 1:(size(svmData_stay{1},2))/sliding_window
    try
        for iJ = 1:size(svmData_stay,1)
            stay_normed{iJ,1} = nanmean(Z_score(svmData_stay{iJ,1}(:,start:start+epoch)),2);
            leave_normed{iJ,1} = nanmean(Z_score(svmData_leave{iJ,1}(:,start:start+epoch)),2);
        end
        % clear stay leave
        for iJ = size(stay_normed,1):-1:1
            if isempty(stay_normed{iJ})
                stay_normed(iJ,:) = [];
                leave_normed(iJ,:) = [];
            end
        end
        for iJ = size(leave_normed,1):-1:1
            if isempty(leave_normed{iJ})
                stay_normed(iJ,:) = [];
                leave_normed(iJ,:) = [];
            end
        end
        for iJ = size(stay_normed,1):-1:1
            if sum(isnan(stay_normed{iJ}))>0
                stay_normed(iJ,:) = [];
                leave_normed(iJ,:) = [];
            end
        end
        for iJ = size(leave_normed,1):-1:1
            if sum(isnan(leave_normed{iJ}))>0
                stay_normed(iJ,:) = [];
                leave_normed(iJ,:) = [];
            end
        end
        stay = zeros(100,size(stay_normed,1));
        leave = zeros(100,size(stay_normed,1));
        shuffle1 = zeros(100,size(stay_normed,1));
        shuffle2 = zeros(100,size(stay_normed,1));
        for iJ = 1:size(stay,1)
            for iK = 1:size(stay,2)
                r = randi(size(stay_normed{iK},1));
                stay(iJ,iK) = stay_normed{iK}(r,1);
                
                r = randi(size(leave_normed{iK},1));
                leave(iJ,iK) = leave_normed{iK}(r,1);
                
                r1 = randi(2);
                if r1 == 1
                    r = randi(size(stay_normed{iK},1));
                    shuffle1(iJ,iK) = stay_normed{iK}(r,1);
                elseif r1 == 2
                    r = randi(size(leave_normed{iK},1));
                    shuffle1(iJ,iK) = leave_normed{iK}(r,1);
                end
                r1 = randi(2);
                if r1 == 1
                    r = randi(size(stay_normed{iK},1));
                    shuffle2(iJ,iK) = stay_normed{iK}(r,1);
                elseif r1 == 2
                    r = randi(size(leave_normed{iK},1));
                    shuffle2(iJ,iK) = leave_normed{iK}(r,1);
                end
            end
        end
        stay(:,end+1) = 1;
        leave(:,end+1) = 0;
        shuffle1(:,end+1) = randi(2);
        shuffle2(:,end+1) = randi(2);
        for iJ = 1:size(shuffle1,1)
            if shuffle1(iJ,end) == 2
                shuffle1(iJ,end) = 0;
            end
        end
        for iJ = 1:size(shuffle2,1)
            if shuffle2(iJ,end) == 2
                shuffle2(iJ,end) = 0;
            end
        end
        
        temp1 = stay(1:((size(stay,1))/2),:);
        temp2 = leave(1:((size(leave,1))/2),:);
        temp3 = cat(1,temp1,temp2);
        order = randperm(size(temp3,1));
        for iJ = 1:size(order,2)
            train(iJ,:) = temp3(order(iJ),:);
        end
        
        temp1 = stay(((size(stay,1))/2)+1:end,:);
        temp2 = leave(((size(leave,1))/2)+1:end,:);
        temp3 = cat(1,temp1,temp2);
        order = randperm(size(temp3,1));
        for iJ = 1:size(order,2)
            test(iJ,:) = temp3(order(iJ),:);
        end
        
        temp1 = shuffle1(1:((size(shuffle1,1))/2),:);
        temp2 = shuffle2(1:((size(shuffle2,1))/2),:);
        temp3 = cat(1,temp1,temp2);
        order = randperm(size(temp3,1));
        for iJ = 1:size(order,2)
            train_shuffle(iJ,:) = temp3(order(iJ),:);
        end
        
        temp1 = shuffle1(((size(shuffle1,1))/2)+1:end,:);
        temp2 = shuffle2(((size(shuffle2,1))/2)+1:end,:);
        temp3 = cat(1,temp1,temp2);
        order = randperm(size(temp3,1));
        for iJ = 1:size(order,2)
            test_shuffle(iJ,:) = temp3(order(iJ),:);
        end
        
        mdlAll = fitcsvm(train(:,1:end-1), train(:,end));
        predictAll = predict(mdlAll,test(:,1:(end-1)));
        predictAll(:,2) = test(:,end);
        accuracy(iI,1) = 0;
        for iJ = 1:size(predictAll,1)
            if predictAll(iJ,1) == predictAll(iJ,2)
                accuracy(iI,1) = accuracy(iI,1) + 1;
            end
        end
        accuracy(iI,1) = (accuracy(iI,1)/size(predictAll,1))*100;
        
        mdlshuffle = fitcsvm(train_shuffle(:,1:end-1), train_shuffle(:,end));
        predictshuffle = predict(mdlshuffle,test_shuffle(:,1:(end-1)));
        predictshuffle(:,2) = test(:,end);
        accuracy_shuffle(iI,1) = 0;
        for iJ = 1:size(predictshuffle,1)
            if predictshuffle(iJ,1) == predictshuffle(iJ,2)
                accuracy_shuffle(iI,1) = accuracy_shuffle(iI,1) + 1;
            end
        end
        accuracy_shuffle(iI,1) = (accuracy_shuffle(iI,1)/size(predictshuffle,1))*100;
        start = start+sliding_window;
        clearvars -except epoch start iI accuracy accuracy_shuffle svmData_leave svmData_stay sliding_window
    catch
%         warning('All out of bins.')
    end
end
end