function [sv,gof] = SV_binned(input,min,max,binsize)
%SV: This is a function that estimates the risky probability that has an
%equivalent SV to a safe offer on StagOps

%   This function will first separate trials for which a risky offer is
%   pitted against a safe offer. It will do this for both high- and
%   low-stakes risky offers. Then it will call the switch_point function
%   for each, which estimates the probability value for the risky offer
%   that results in an approximately 50/50 choice rate between the safe and
%   risky offers. The risky-offer probibility for which the subject is
%   equally likely to choose the risky and safe offers is the point of
%   Subjective Value Equivalence.

%% set to trial data
for iJ = 1:length(input)
    start{iJ,1} = input{iJ}.vars;
end

%% remove duplicate days
data = delete_duplicate_days(start);

%% take all trials choosing between risky-low and safe.
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        if (data{iJ}(iK,2) == 1 && data{iJ}(iK,5) == 2)...
                || (data{iJ}(iK,2) == 2 && data{iJ}(iK,5) == 1)
            safe.low{iJ,1}(iK,:) = data{iJ}(iK,:);
        end
    end
end
for iJ = 1:length(safe.low)
    for iK = length(safe.low{iJ}):-1:1
        if safe.low{iJ}(iK,2) == 0
            safe.low{iJ}(iK,:) = [];
        end
    end
end

%% and then you can repeat that process for risk-high 
for iJ = 1:length(data)
    for iK = 1:length(data{iJ})
        if (data{iJ}(iK,2) == 1 && data{iJ}(iK,5) == 3)...
                || (data{iJ}(iK,2) == 3 && data{iJ}(iK,5) == 1)
            safe.high{iJ,1}(iK,:) = data{iJ}(iK,:);
        end
    end
end
for iJ = 1:length(safe.high)
    for iK = length(safe.high{iJ}):-1:1
        if safe.high{iJ}(iK,2) == 0
            safe.high{iJ}(iK,:) = [];
        end
    end
end

%% plot probability(choosing safe) as a function of risky-probability
% find which probability is where the safe crosses 
    %you are basically computing the point where he is indifferent between risky and safe 
% you can average across days, and at this point, across all subjects
[~,y.low,z.low] = switch_point(safe.low,min,max,binsize);
[~,y.high,z.high] = switch_point(safe.high,min,max,binsize);

%% Fit the sigmoids and calculate the indifference point
[fitresult,gof.low] = createFit_sv(z.low,y.low);
a = fitresult.a;
b = fitresult.b;
for iJ = 1:length(z.low)
    out(iJ) = a/(b+exp((b*z.low(iJ))-1));
end
ind = find(out > 50);
sv.low = z.low(ind(end));

[fitresult,gof.high] = createFit_sv(z.high,y.high);
a = fitresult.a;
b = fitresult.b;
for iJ = 1:length(z.high)
    out(iJ) = a/(b+exp((b*z.high(iJ))-1));
end
ind = find(out > 50);
sv.high = z.high(ind(end));

end