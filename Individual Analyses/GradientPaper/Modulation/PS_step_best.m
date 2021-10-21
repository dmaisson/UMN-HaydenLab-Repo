function [Results] = PS_step_best(in,tokentask)
%% Stepwise - Identify the best Overall explainer, then remove
% the responses IN ALL TIME BINS explained by that explainer. Run it again 
% and see what the table looks like. Now, find the next best, and remove 
% that. Calculate the proportion of response explained by that explainer. 
% Repeat the process until there are no explainers left that pass 5% of the
% responses.

start = Preselect_ANCOVA(in,tokentask);
clear in;

[res1,Results.Count1,Results.Rate1,Results.max1] = Stepwise_ancova(start,tokentask);
[res2,Results.Count2,Results.Rate2,Results.max2] = Stepwise_ancova(res1,tokentask);
[res3,Results.Count3,Results.Rate3,Results.max3] = Stepwise_ancova(res2,tokentask);
[res4,Results.Count4,Results.Rate4,Results.max4] = Stepwise_ancova(res3,tokentask);
% [res5,Results.Count5,Results.Rate5,Results.max5] = Stepwise_ancova(res4,tokentask);
% [res6,Results.Count6,Results.Rate6,Results.max6] = Stepwise_ancova(res5,tokentask);
% [res7,Results.Count7,Results.Rate7,Results.max7] = Stepwise_ancova(res6,tokentask);

%% Best Subset - for a subset of 1 variable, identify the number of
% responses explained and which subset explained the highest proportion of
% responses. Then repeat for a subset of 2 variables. Then 3, 4, 5. etc.

pooledorig = sum(Results.Count1,1);
pooled = sum(Results.Count1,1);
for iJ = 1:size(Results.Count1,2)
    if iJ == 1
        Results.d(iJ) = max(pooled);
        c = find(pooled == max(pooled));
        if length(c) == 1
            Results.ind(iJ) = c;
        else
            Results.ind(iJ) = c(1);
        end
        pooled(:,pooled == max(pooled)) = 0;
        Results.rate(iJ) = (Results.d(iJ)/sum(pooledorig))*100;
    else
        Results.d(iJ) = Results.d(iJ-1)+max(pooled);
        c = find(pooled == max(pooled));
        if length(c) == 1
            Results.ind(iJ) = c;
        else
            Results.ind(iJ) = c(1);
        end
        pooled(:,pooled == max(pooled)) = 0;
        Results.rate(iJ) = (Results.d(iJ)/sum(pooledorig))*100;
    end
end

%% post-hoc
% For each mariginal explainer in stepwise, compare its' proportion of
% explained responses to that of another highly correlated, but excluded
% variable (correlation value > 0.8). Test the inequality with binomial

end