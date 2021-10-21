function [sv] = SV_gambles(input,min,max,binsize)
%SV_gambles: This is a function that estimates the high-stakes risky
%probability that has an equivalent SV to the low-stakes risky probability

%   This function will first separate trials for which a risky offer is
%   pitted against a safe offer. It will do this for both high- and
%   low-stakes risky offers. Then it will call the switch_point function
%   for each, which estimates the probability value for the risky offer
%   that results in an approximately 50/50 choice rate between the safe and
%   risky offers. The risky-offer probibility for which the subject is
%   equally likely to choose the risky and safe offers is the point of
%   Subjective Value Equivalence.

%% remove duplicate days
data = delete_duplicate_days(input);

%% isolate trials on which a high-stakes offer is against a low-stakes
probs = min:binsize:max;
for iL = 1:length(probs)-1
    for iJ = 1:length(data)
        for iK = 1:length(data{iJ})
            if (data{iJ}(iK,2) == 2 && data{iJ}(iK,5) == 3)
                if data{iJ}(iK,1) > probs(iL) && data{iJ}(iK,1) < probs(iL+1)
                    gambles{iL,1}{iJ,1}(iK,:) = data{iJ}(iK,:);
                end
            elseif (data{iJ}(iK,2) == 3 && data{iJ}(iK,5) == 2)
                if data{iJ}(iK,4) > probs(iL) && data{iJ}(iK,4) < probs(iL+1)
                    gambles{iL,1}{iJ,1}(iK,:) = data{iJ}(iK,:);
                end
            else
                gambles{iL,1}{iJ,1}(iK,1:size(data{iJ},2)) = NaN;
            end
        end
    end
end

for iL = 1:length(gambles)
    for iJ = 1:length(gambles{iL})
        for iK = length(gambles{iL}{iJ}):-1:1
            if gambles{iL}{iJ}(iK,2) == 0 || isnan(gambles{iL}{iJ}(iK,2))
                gambles{iL}{iJ}(iK,:) = [];
            end
        end
    end
end
clear iJ iK iL;

%% In each range, at 50/50 choice mark find the corresponding high-stakes prob
for iJ = 1:length(gambles)
    [sv(iJ,1),y{iJ,1},z{iJ,1}] = switch_point_gambles(gambles{iJ},min,max,binsize);
end
clear iJ;
%%
figure;
for iJ = 1:length(sv)
    subplot(4,5,iJ)
    title('High v. Low: Low prob range ' + z{iJ});
    plot(z{iJ},y{iJ});
    xlabel('high-stakes offer probability')
    ylabel('likelihood of choosing the low-stakes option')
    hline(50);
    vline(sv(iJ),0);
end

end