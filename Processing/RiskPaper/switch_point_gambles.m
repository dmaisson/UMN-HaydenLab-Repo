function [flip,y,z] = switch_point_gambles(input,min,max,binsize)
%%
% Finds the probabilities for the high-stakes offers
for iJ = 1:size(input,1)
    for iK = 1:size(input{iJ},1)
        if input{iJ}(iK,2) == 2
            x{iJ,1}(iK,1) = input{iJ}(iK,4);
        elseif input{iJ}(iK,2) ~= 2
            x{iJ,1}(iK,1) = input{iJ}(iK,1);
        end
    end
end

Bins=(min:binsize:max)';

for iL = 1:length(Bins)
    Bins(iL,2) = 0; %will be used to count low-stakes risk choice
    Bins(iL,3) = 0; %will be used to count high-stakes risk choice
end

% cycle binning matrix over dataset to count events within bin
for iL = 1:size(Bins,1)
    for iK = 1:size(x,1)
        for iJ = 1:size(x{iK},1)
            %if the chosen offer was the small-stakes offer
            if (input{iK}(iJ,2) == 2 && input{iK}(iJ,9) == 1)...
                    || (input{iK}(iJ,5) == 2 && input{iK}(iJ,9) == 0)
                %if the probability of the high-stakes offer is in range
                if x{iK}(iJ) > Bins(iL,1) && x{iK}(iJ) < Bins(iL+1,1)
                    Bins(iL,2) = Bins(iL,2) + 1; 
                end
            %if the chosen offer was NOT the small-stakes offer
            elseif (input{iK}(iJ,2) == 2 && input{iK}(iJ,9) == 0)...
                    || (input{iK}(iJ,5) == 2 && input{iK}(iJ,9) == 1)
                %if the probability of the high-stakes offer is in range 
                if x{iK}(iJ) > Bins(iL,1) && x{iK}(iJ) < Bins(iL+1,1) 
                    Bins(iL,3) = Bins(iL,3) + 1;
                end
            end
        end
    end
    y(iL,1)=((Bins(iL,2)/(Bins(iL,3) + Bins(iL,2))*100));
end

z = Bins(:,1);
temp = y(y>50);
if ~isempty(temp)
    flip = z(length(temp));
else
    flip = NaN;
end

end