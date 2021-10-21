function R = Behavior(data,min,max,binsize)
%%
for iJ = 1:length(data)
    for iK = 1:length(data{iJ}.vars)
        x{iJ}(iK,1) = data{iJ}.vars(iK,3) - data{iJ}.vars(iK,6);
    end
end
x = x';

R.Bins=(min:binsize:max)';

for iL = 1:length(R.Bins)
    R.Bins(iL,2) = 0;
    R.Bins(iL,3) = 0;
end

% cycle binning matrix over dataset to count events within bin
for iL = 1:length(R.Bins)%for each bin value
    for iK = 1:length(x)% cycle through the cells
        for iJ = 1:length(x{iK}) %cycle through each trial for each cell
            if data{iK}.vars(iJ,9) == 1 %check if the chosen offer on that trial was the first one
                if x{iK}(iJ) > R.Bins(iL,1) && x{iK}(iJ) < R.Bins(iL+1,1) %if the associated EV for that risky choice was between the value of the current bin and next
                    R.Bins(iL,2) = R.Bins(iL,2) + 1; %increment the count of risky choices in that EV bin
                end
            elseif data{iK}.vars(iJ,9) == 0 %check if the safe offer on that trial was chosen
                if x{iK}(iJ) > R.Bins(iL,1) && x{iK}(iJ) < R.Bins(iL+1,1) %if the associated EV for that safe choice was between the value of the current bin and next
                    R.Bins(iL,3) = R.Bins(iL,3) + 1; %increment the count of safe choices in that EV bin
                end
            end %then move to the next trial
        end %then move to the next cell
    end %then move to the next EV bin
    R.Bins(iL,3)=((R.Bins(iL,2)/(R.Bins(iL,3) + R.Bins(iL,2))*100)); %add the total number of safe choices to the total number of risky choices, and calculate the risk rate
end %finish looping
end