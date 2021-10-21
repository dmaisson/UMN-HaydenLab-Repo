function Bins = Behavior_1sess(data,min,max,binsize)
%%
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        diff{iJ,1}(iK,1) = data{iJ}(iK,3) - data{iJ}(iK,6);
    end
end

Bins=(min:binsize:max)';

for iJ = 1:length(data)
    for iL = 1:length(Bins)
        Bins(iL,2,iJ) = 0;
        Bins(iL,3,iJ) = 0;
        Bins(iL,4,iJ) = 0;
    end
end

% cycle binning matrix over dataset to count events within bin
for iJ = 1:size(Bins,3)
    for iL = 1:length(Bins)
        for iK = 1:length(diff)
                if data{iJ}(iK,7) == 1 
                    if diff{iJ}(iK) > Bins(iL,1) && diff{iJ}(iK) < Bins(iL+1,1)
                        Bins(iL,2,iJ) = Bins(iL,2,iJ) + 1;
                    end
                elseif data{iJ}(iK,7) == 2 
                    if diff{iJ}(iK) > Bins(iL,1) && diff{iJ}(iK) < Bins(iL+1,1) 
                        Bins(iL,3,iJ) = Bins(iL,3,iJ) + 1;
                    end
                end 
        end 
        Bins(iL,4)=((Bins(iL,2,iJ)/(Bins(iL,3,iJ) + Bins(iL,2,iJ))*100));
    end
end %finish looping


end