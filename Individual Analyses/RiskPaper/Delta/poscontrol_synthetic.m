function deltaSets_subset = poscontrol_synthetic(in,iterations)

separated_trials = in.separated_trials;

%% within offer delta

safe = separated_trials.safe.Ep1; %take the data from safe trials
n = length(safe); %find how many cells there are
S_range = (1:100)/100; %set the range for the size of S
eqlow = separated_trials.eqlow.Ep1; %take the data for cells from that prob bin
eqhigh = separated_trials.eqhigh.Ep1; %take the data for cells from that prob bin

first(1:n,1:iterations) = NaN;
second(1:n,1:iterations) = NaN;
for iJ = 1:iterations
    r = randi(3);
    if r == 1
        for iK = 1:n %for the number of cells in the total set
            x = safe{iK}.psth;
            r1 = randperm(size(x,1));
            set1_r = r1(1:size(r1,2)/2);
            set2_r = r1((size(r1,2)/2)+1:end);
            set1 = nanmean(x(set1_r(1:end),:),2);
            set2 = nanmean(x(set2_r(1:end),:),2);
            set1(iK,1) = nanmean(set1); %calculate the mFR across safe trials
            set2(iK,1) = nanmean(set2); %calculate the mFR across safe trials
        end
    elseif r == 2
        for iK = 1:n %for the number of cells in the total set
            x = eqlow{iK}.psth;
            r1 = randperm(size(x,1));
            set1_r = r1(1:size(r1,2)/2);
            set2_r = r1((size(r1,2)/2)+1:end);
            set1 = nanmean(x(set1_r(1:end),:),2);
            set2 = nanmean(x(set2_r(1:end),:),2);
            set1(iK,1) = nanmean(set1); %calculate the mFR across safe trials
            set2(iK,1) = nanmean(set2); %calculate the mFR across safe trials
        end
    elseif r == 3
        for iK = 1:n %for the number of cells in the total set
            x = eqhigh{iK}.psth;
            r1 = randperm(size(x,1));
            set1_r = r1(1:size(r1,2)/2);
            set2_r = r1((size(r1,2)/2)+1:end);
            set1 = nanmean(x(set1_r(1:end),:),2);
            set2 = nanmean(x(set2_r(1:end),:),2);
            set1(iK,1) = nanmean(set1); %calculate the mFR across safe trials
            set2(iK,1) = nanmean(set2); %calculate the mFR across safe trials
        end
    end
    first(:,iJ) = set1;
    second(:,iJ) = set2;
end
first = nanmean(first,2);
second = nanmean(second,2);

delta_sets = sort((abs(first - second)),1); %find the delta for set1 and 2
    
for iJ = 1:length(S_range) %for the total range of S sizes (from 1%-100%)
    %now pick the number of cells corresponding to the stipulated size of S
    S_current{iJ,1} = round(n*S_range(iJ));
    for iK = 1:S_current{iJ,1}
        deltaSets_subset{iJ,1}(iK,:) = delta_sets(iK,1);
    end
end

end