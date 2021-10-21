function [predictors] = Predictors_Position(data,epoch)
%Pull out FR regression predictors: offer position

    for iL = 1: length(data)
        for iK = 1:length(data{iL}.vars)
            if epoch == 1
                poscol = data{iL}.vars(iK,7);
            elseif epoch == 2
                if data{iL}.vars(iK,7) == 1
                    poscol = 2;
                elseif data{iL}.vars(iK,7) == 2
                    poscol = 1;
                end
            elseif epoch == 3
                poscol = data{iL}.vars(iK,8);
            end
        predictors{iL}(iK,1) = poscol;
        end
    end
    
end