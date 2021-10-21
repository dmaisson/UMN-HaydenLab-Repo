function [predictors] = Predictors_OfferValue(data)
%Pull out FR regression predictors: offer prob and offer size

for iL = 1: length(data)
for iK = 1:length(data{iL}.vars)

    offer1value = 3;
    offer2value = 6;

predictors{iL}(iK,1) = data{iL}.vars(iK,offer1value);
predictors{iL}(iK,2) = data{iL}.vars(iK,offer2value);

end
end
end

