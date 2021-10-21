function [predictors] = Predictors_RwdProb(data,epoch)
%Pull out FR regression predictors: offer prob and offer size

for iL = 1: length(data)
for iK = 1:length(data{iL}.vars)

if epoch == 1
    probcol = 1;
    sizecol = 2;
elseif epoch == 2
    probcol = 4;
    sizecol = 5;
elseif epoch == 3
    choice = data{iL}.vars(iK,9);
    if choice == 1
        probcol = 1;
    elseif choice == 2
        probcol = 4;
    end
    sizecol = 10;
end

predictors{iL}(iK,1) = data{iL}.vars(iK,probcol);
predictors{iL}(iK,2) = data{iL}.vars(iK,sizecol);

end
end
end

