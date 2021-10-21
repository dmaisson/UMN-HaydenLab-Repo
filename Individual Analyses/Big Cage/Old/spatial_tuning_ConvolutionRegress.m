%% enter here the preprocess steps required on Loki



%%
neuron = cell(size(cells,1),1);
sig(1:size(cells,1)) = NaN;

for iI = 1:size(cells,1)
iI
tic
    
    %%%%% Reward Response PSTH %%%%%
    
    % extract all feeder events timestamps and patchIDs
    vars(:,1) = cells{iI,15}.evt.patchID;
    vars(:,2) = cells{iI,15}.evt.eventcode;
    vars(:,3) = cells{iI,15}.evt.timestamp;

    % extract lever press timestamps
    leverPress = vars(vars(:,2) == 2,:);

    % convert timestamps to seconds (30k fs)
    scale = 1000; %puts scale in seconds
    % scale = 1; %puts scale in 1ms
    leverPress(:,3) = leverPress(:,3)/(30*scale);

    %create "trial" windows (start and stop timestampts for +/- 10sec)
    window = 4; 
    totalTime = window*2;
    leverPress(:,4) = leverPress(:,3)-((1000/scale)*window);
    leverPress(:,5) = leverPress(:,3)+((1000/scale)*window);

    clear evt vars iJ

    % extract spike timestamps
    spikeTimes = cells{iI,1};

    % group all spike timestamps within +/- 4 seconds of that lever press
    % timestamp into a "trial"
    trialSpikeTimes(1:size(leverPress,1),1:size(spikeTimes,1)) = NaN;
    for iJ = 1:size(leverPress,1)
        for iK = 1:size(spikeTimes,1)
            if (spikeTimes(iK,1) >= leverPress(iJ,4)) && ...
                    (spikeTimes(iK,1) <= leverPress(iJ,5))
                trialSpikeTimes(iJ,iK) = spikeTimes(iK,1);
            end
        end
    end

    % calculate FR into bins
    trialTimes(1:size(leverPress,1),1:size(linspace(leverPress(iJ,4),leverPress(iJ,5),...
            ((1000/scale)*totalTime)),2)) = NaN;
    for iJ = 1:size(leverPress,1)
        trialTimes(iJ,:) = linspace(leverPress(iJ,4),leverPress(iJ,5),...
            ((1000/scale)*totalTime));
    end
    psth = zeros(size(trialTimes,1),size(trialTimes,2));
    for iJ = 1:size(psth,1) %for each "trial"
        for iK = 1:size(psth,2)-1 %for each 1ms bin
            for iL = 1:size(trialSpikeTimes,2) %for each spike timestamp
                if (trialSpikeTimes(iJ,iL) >= trialTimes(iJ,iK)) && ...
                        (trialSpikeTimes(iJ,iL) < trialTimes(iJ,iK+1)) %if the spike timestamp is greater than the ms bin and less than the next
                    psth(iJ,iK) = psth(iJ,iK)+1; %add a spike counter to that ms bin
                end
            end
        end
    end
    clear iJ iK iL

    % gather variables
    neuron{iI,1}.leverPress = leverPress;
    neuron{iI,1}.rewpsth = psth;
    neuron{iI,1}.mpsth = nanmean(psth,1);
    neuron{iI,1}.spikeTimes = spikeTimes;
    neuron{iI,1}.com = cells{iI,14};
    clearvars -except neuron cells iI;
    
    %%%%% Residualize the time series by reward coding %%%%%
    
    neuron{iI,1} = Residualize_timeseries_reward(neuron{iI,1});
    
    %%%%% Spatially bin the Center of Mass %%%%%
    
    neuron{iI,1} = spaceBinning_COM(neuron{iI,1});
    
    %%%%% Spatially bin the residualized timeseries %%%%%
    
    neuron{iI,1} = spaceBinning_timeseries(neuron{iI,1});
    
    %%%%% find spatial tuning %%%%%
    
    neuron{iI,1} = spatialInformation(neuron{iI,1});
    
    %%%%% check if spatial information is significant %%%%%
    
    neuron{iI,1} = sig_spatialInfo(neuron{iI,1});
    sig(iI,1) = neuron{iI,1}.sig;
    
    %%%%% create a nicer rate map for plotting %%%%%
    
    x = min(neuron{iI,1}.binned_rates_normed(:));
    for iJ = 1:size(neuron{iI,1}.binned_rates_normed,1)
        for iK = 1:size(neuron{iI,1}.binned_rates_normed,2)
            if isnan(neuron{iI,1}.binned_rates_normed(iJ,iK))
                neuron{iI,1}.plotting_rates(iJ,iK) = x;
            else
                neuron{iI,1}.plotting_rates(iJ,iK) = neuron{iI,1}.binned_rates_normed(iJ,iK);
            end
        end
    end
    
toc
end
clearvars -except sig neuron
sigrate = (sum(sig)/size(neuron,1))*100;
