function [predictors] = Predictors_Amb(data)
%Pull out FR regression predictors: offer position

    for iL = 1:length(data)
        for iK = 1:length(data{iL}.vars)
            predictors{iL}(iK,1) = abs(data{iL}.vars(iK,3) - data{iL}.vars(iK,6));
        end
    end
    
end