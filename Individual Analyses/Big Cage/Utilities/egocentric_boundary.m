function output = egocentric_boundary(HD,set)

s = 180000;
for iJ = 1:size(HD,1) %for each day of tracking data
    HD_day = HD{iJ}.day; %identify the date of the tracking data
    for iK = 1:size(set,1) %for each neuron
       rec_day = set{iK}.day; %identify the date the neuron was recorded
       if sum(HD_day == rec_day) == 10 %if the two dates match
           y = set{iK}.resSeries'; %set the outcome variable to the residualized spike train
           temp(:,1) = HD{iJ}.head(:,1); %extract the cartesian x of the head
           temp(:,2) = HD{iJ}.head(:,3); %extract the cartesian y of the head
           temp(end:s,:) = NaN; %make the vectors equal in length by adding appropriate number of NaNs
           [predictors,outcome,deg_binned] = setup_vars_egobound(y,temp);
           [~,~,stats] = glmfit(predictors,outcome); %regress outcome on predictors
           if stats.p(2) <= 0.05 && stats.p(3) <= 0.05
               EB(iK,1) = 1;
           else
               EB(iK,1) = 0;
           end
       end
    end
end
sig_rate = (sum(EB)/iK)*100;

output.predictors = predictors;
output.outcome = outcome;
output.deg_binned = deg_binned;
output.sig_rate = sig_rate;
output.EB = EB;

end
