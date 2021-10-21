function [vars] = vars_Tyler(trial1)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
vars(:,1) = trial1.offer1prob';
vars(:,2) = trial1.offer1val';
vars(:,4) = trial1.offer2prob';
vars(:,5) = trial1.offer2val';
vars(:,9) = trial1.chosenOffer';
vars(:,10) = trial1.outcome';

for iL = 1:size(vars,1)
    if vars(iL,10) == 2
        vars(iL,10) = 3;
    elseif vars(iL,10) == 1
        vars(iL,10) = 2;
    elseif vars(iL,10) == 0
        vars(iL,10) = 1;
    end
end

for iL = 1:size(vars,1)
    if trial1.LOfferFirst(1,iL) == 1
        vars(iL,7) = 1;
    elseif trial1.LOfferFirst(1,iL) == 0
        vars(iL,7) = 2;
    end
end

for iL = 1:size(vars,1)
    if vars(iL,7) == 1 && vars(iL,9) == 1
        vars(iL,8) = 1;
    elseif vars(iL,7) == 1 && vars(iL,9) == 2
        vars(iL,8) = 2;
    elseif vars(iL,7) == 2 && vars(iL,9) == 1
        vars(iL,8) = 2;
    elseif vars(iL,7) == 2 && vars(iL,9) == 2
        vars(iL,8) = 1;
    end
end

%recode offer size to 1,2,3 categorical
for iL = 1:size(vars,1)
    %Offer 1
    if vars(iL,2) == 0.2510 || vars(iL,2) == 2
        vars(iL,2) = 3;
    elseif vars(iL,2) == 0.1850 || vars(iL,2) == 1
        vars(iL,2) = 2;
    elseif vars(iL,2) == 0.1100 || vars(iL,2) == 0
        vars(iL,2) = 1;
    end
    %Offer 2
    if vars(iL,5) == 0.2510 || vars(iL,5) == 2
        vars(iL,5) = 3;
    elseif vars(iL,5) == 0.1850 || vars(iL,5) == 1
        vars(iL,5) = 2;
    elseif vars(iL,5) == 0.1100 || vars(iL,5) == 0
        vars(iL,5) = 1;
    end
    %Calculate EV1
    vars(iL,3) = vars(iL,1)*vars(iL,2);
    vars(iL,6) = vars(iL,4)*vars(iL,5);
end

end

