function [Bins,sem] = Behavior_Multiple(data,min,max,binsize)
%%
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        diff{iJ,1}(iK,1) = data{iJ}(iK,3) - data{iJ}(iK,6);
    end
end
clear iK iJ;

for iJ = 1:length(data)
    Bins(:,1,iJ)=(min:binsize:max);
end
clear iK iJ min max binsize;

for iJ = 1:length(data)
    for iL = 1:length(Bins)
        Bins(iL,2,iJ) = 0;
        Bins(iL,3,iJ) = 0;
        Bins(iL,4,iJ) = 0;
    end
end
clear iL iJ;

% cycle binning matrix over dataset to count events within bin
for iJ = 1:size(Bins,3)%for each data set
    for iK = 1:size(Bins,1)%for each bin value
        for iL = 1:length(diff{iJ})% cycle through the trials
                if data{iJ}(iL,7) == 1 %check if the chosen offer on that trial was the first one
                    if diff{iJ}(iL) > Bins(iK,1,iJ) && diff{iJ}(iL) < Bins(iK+1,1,iJ) %if the associated EV for that risky choice was between the value of the current bin and next
                        Bins(iK,2,iJ) = Bins(iK,2,iJ) + 1; %increment the count of risky choices in that EV bin
                    end
                elseif data{iJ}(iL,7) == 2 %check if the chosen offer on that trial was the second one
                    if diff{iJ}(iL) > Bins(iK,1,iJ) && diff{iJ}(iL) < Bins(iK+1,1,iJ) %if the associated EV for that safe choice was between the value of the current bin and next
                        Bins(iK,3,iJ) = Bins(iK,3,iJ) + 1; %increment the count of safe choices in that EV bin
                    end
                end %then move to the next trial
        end %then move to the next EV bin
        Bins(iK,4,iJ)=((Bins(iK,2,iJ)/(Bins(iK,3,iJ) + Bins(iK,2,iJ))*100)); %add the total number of safe choices to the total number of risky choices, and calculate the risk rate
    end
end %finish looping

Bins(:,:,size(Bins,3)+1) = nanmean(Bins,3);
for iJ = 1:size(Bins,3)-1
    x(:,iJ) = Bins(:,4,iJ);
end
x = x';
sem = nanstd(x)';
sem = sem/sqrt(length(sem));

end