%% enter here the preprocess steps required on Loki
%run  spatial_preprocess_loki.m first

cd '/mnt/scratch/DM_spatial'
data = dir('yo*');
numfiles = length(data);
load('area_lookup.mat');
for k = 1:numfiles
  temp = load(data(k).name); 
  temp2 = strsplit(data(k).name, 'yo_');
  temp3 = strsplit(temp2{2}, '_01');
  day = temp3{1};
  for j = 1:size(temp.neuron,1)
    temp.neuron{j,4} = day;
    temp.neuron{j,5} = temp.cellsOrig{j,2};
    temp.neuron{j,6} = temp.cellsOrig{j,3}{1,1};
    for L = 1:size(area_lookup,1)
        if temp.neuron{j,6} == area_lookup{L,2}
            temp.neuron{j,7} = area_lookup{L,1};
        elseif temp.neuron{j,6} == 0
            temp.neuron{j,7} = 'unknown';
        end
    end
    temp.neuron{j,8} = temp.XY_mat;
    temp.neuron{j,9} = temp.XYZ_mat;
    temp.neuron{j,10} = temp.com;
    x2 = strsplit(data(k).name,'_01');
    y = x2{1};
    event_file = (['events/' y '.mat']);
    temp.neuron{j,11} = load(event_file);
  end
  if k == 1
      cells = temp.neuron;
  else
      cells = cat(1,cells,temp.neuron);
  end
  clear temp temp2 temp3 j day
end

clearvars -except cells

get_head_coordinates;

%%
neuron = cell(size(cells,1),1);

for iI = 1:size(cells,1)
iI
tic
    
    %%%%% Reward Response PSTH %%%%%
    
    % extract all feeder events timestamps and patchIDs
    vars(:,1) = cells{iI,11}.evt.patchID;
    vars(:,2) = cells{iI,11}.evt.eventcode;
    vars(:,3) = cells{iI,11}.evt.timestamp;

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
    neuron{iI,1}.com = cells{iI,9};
    clearvars -except neuron cells iI;
    
    %%%%% Residualize the time series by reward coding %%%%%
    
    neuron{iI,1} = Residualize_timeseries_reward(neuron{iI,1});
    
    %%%%% Spatially bin the Center of Mass %%%%%
    
    neuron{iI,1} = spaceBinning_COM(neuron{iI,1});
    
    %%%%% 3D - Spatially bin the Center of Mass %%%%%
    
    neuron{iI,1} = spaceBinning_COM_3D(neuron{iI,1});
    
    %%%%% Spatially bin the residualized timeseries %%%%%
    
    neuron{iI,1} = spaceBinning_timeseries(neuron{iI,1});
    
    %%%%% 3D - Spatially bin the residualized timeseries %%%%%
    
    neuron{iI,1} = spaceBinning_timeseries_3D(neuron{iI,1});
    
    %%%%% find spatial tuning %%%%%
    
    neuron{iI,1} = spatialInformation(neuron{iI,1});
    
    %%%%% 3D - find spatial tuning %%%%%
    
    neuron{iI,1} = spatialInformation_3D(neuron{iI,1});
    
    %%%%% check if spatial information is significant %%%%%
    
    neuron{iI,1} = sig_spatialInfo(neuron{iI,1});
    
    %%%%% 3D - check if spatial information is significant %%%%%
    
    neuron{iI,1} = sig_spatialInfo_3D(neuron{iI,1});
    
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
    clear x
    
    x = min(neuron{iI,1}.binned_rates_normed3D(:));
    for iJ = 1:size(neuron{iI,1}.binned_rates_normed3D,1)
        for iK = 1:size(neuron{iI,1}.binned_rates_normed3D,2)
            for iL = 1:size(neuron{iI,1}.binned_rates_normed3D,3)
                if isnan(neuron{iI,1}.binned_rates_normed3D(iJ,iK,iL))
                    neuron{iI,1}.plotting_rates3D(iJ,iK,iL) = x;
                else
                    neuron{iI,1}.plotting_rates3D(iJ,iK,iL) = ...
                        neuron{iI,1}.binned_rates_normed3D(iJ,iK,iL);
                end
            end
        end
    end
    
    %%%%% Remove extraneous fields %%%%%
    fields = {'com','rank'};
    neuron{iI,1} = rmfield(neuron{iI,1},fields);
    
    %%%%% Add area labels and day%%%%%
    neuron{iI,1}.area = cells{iI,7};
    neuron{iI,1}.area_label = cells{iI,6};
    neuron{iI,1}.day = cells{iI,4};
    
toc
end

%% isolate significant neurons

[sig_neuron,sig_rate,sig_neuron_3D,sig_rate3D] = isolate_sig_info(neuron);

%% save

save('all_cells_spatial','-v7.3');