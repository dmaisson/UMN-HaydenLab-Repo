function output = Residualize_timeseries_reward(input)

spikeSeries = zeros(size(input.com,1),1)';
eventSeries = zeros(size(input.com,1),1)';
timeSeries = (1:size(input.com,1))/30;
spikeTimes = input.spikeTimes(:,1)';
eventTimes = input.leverPress(:,3)';
kernel = input.mpsth;
for iJ = 1:size(timeSeries,2)-1
    for iK = 1:size(spikeTimes,2)
        if spikeTimes(1,iK) > timeSeries(1,iJ) && ...
                spikeTimes(1,iK) < timeSeries(1,iJ+1)
            spikeSeries(1,iJ) = spikeSeries(1,iJ)+1;
        end
    end
    for iK = 1:size(eventTimes,2)
        if eventTimes(1,iK) > timeSeries(1,iJ) && ...
                eventTimes(1,iK) < timeSeries(1,iJ+1)
            eventSeries(1,iJ) = eventSeries(1,iJ)+1;
        end
    end
end
rewSeries = conv(eventSeries,kernel);
rewSeries = rewSeries(1:size(timeSeries,2));

% %down-sample to 1000 samples, then interpolate for smoother timeseries
% temp = rewSeries;
% temp = FR_CollapseBins(temp,180);
% rewSeries = interp(temp,180);
% clear temp
% temp = spikeSeries;
% temp = FR_CollapseBins(temp,180);
% spikeSeries = interp(temp,180);
% clear temp

% b = glmfit(rewSeries,spikeSeries,'poisson','Link','log');
% yhat = glmval(b,rewSeries,'log')';
% resSeries = spikeSeries - yhat;

mdl =  fitglm(rewSeries,spikeSeries,'linear','Distribution','poisson');
predicted = predict(mdl,spikeSeries')';
resSeries = abs(spikeSeries - predicted);

output = input;
output.spikeSeries = spikeSeries;
output.eventSeries = eventSeries;
output.resSeries = resSeries;