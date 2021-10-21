%% read in data
data = dir('yo*');
numfiles = length(data);
load('area_lookup.mat');
for k = 1:numfiles
  temp = load(data(k).name); 
  temp2 = strsplit(data(k).name, 'yo_');
  temp3 = strsplit(temp2{2}, '_01');
  day = temp3{1};
  for j = 1:size(temp.neuron,1)
    temp.neuron{j,8} = day;
    temp.neuron{j,9} = temp.cellsOrig{j,2};
    temp.neuron{j,10} = temp.cellsOrig{j,3}{1,1};
    for L = 1:size(area_lookup,1)
        if temp.neuron{j,10} == area_lookup{L,2}
            temp.neuron{j,11} = area_lookup{L,1};
        elseif temp.neuron{j,10} == 0
            temp.neuron{j,11} = 'unknown';
        end
    end
    temp.neuron{j,12} = temp.XY_mat;
    temp.neuron{j,13} = temp.XYZ_mat;
    temp.neuron{j,14} = temp.com;
    x = strsplit(data(k).name,'_01');
    y = x{1};
    event_file = (['events/' y '.mat']);
    temp.neuron{j,15} = load(event_file);
  end
  if k == 1
      cells = temp.neuron;
  else
      cells = cat(1,cells,temp.neuron);
  end
  clear temp temp2 temp3 j day
end

clearvars -except cells

cd ..
save('Cells_with_COM','-v7.3');

%% regress out reward events
%%%%% trialize the spike data %%%%%
for iI = 1:size(cells,1)
tic
neuron = cells{iI,1}; %pull the spatially binned rate data from a single neuron
com = cells{iI,14}; %pull the center of mass from tracking for that day
evt = cells{iI,15}.evt; %pull the event data for that day
events(:,1) = evt.patchID;
events(:,2) = evt.eventcode;
events(:,3) = evt.timestamp/30000;

%%%%% erase all events that are not reward codes (i.e. solenoid open) %%%%%
for iJ = size(events,1):-1:1
    if events(iJ,2) ~= 4
        events(iJ,:) = [];
    end
end
clear iJ;

%%%%%% this next section fills a spatial bin matrix with COM timestamps in Seconds %%%%%%
%%%this is a time draining segment...must reevaluate approach%%%
div_space = linspace(-4, 4, 11); %create a vector representing spatial bins
div_space(end+1) = 5; %add a dummy variable to the end that is out of range
inbin_temp = cell(size(div_space,2)-1,size(div_space,2)-1); %create #bin_X_#bin cell matrix
for iJ = 1:size(div_space,2)-1 %for each of the bins (minus the dummy); this is x-axis iterator
    for iK = 1:size(div_space,2)-1 %for each of the bins (minus the dummy); this is y-axis iterator
        for iL = 1:size(com,1) %for each cycle (each image)
            inbin_temp{iJ,iK}(iL,1) = NaN; %fill the cell matrix with a single NaN value
            % if the COM is within a given x-axis spatial bin
            if com(iL,1) > div_space(1,iJ) && com(iL,1) < div_space(1,iJ+1)
                % if the COM is within a given y-axis spatial bin
                if com(iL,3) > div_space(1,iK) && com(iL,3) < div_space(1,iK+1)
                    inbin_temp{iJ,iK}(iL,1) = iL/30; %enter the timestamp (i.e. the cycle number / sampling rate of 30Hz)
                end
            end
        end
    end
end
clear iJ iK iL com;

%%%%% pull out all the timestamps, reducing by the NaNs %%%%%
% the result here is times of bin occupancy
for iJ = size(inbin_temp,1):-1:1 %for each x bin
    for iK = size(inbin_temp,2):-1:1 %for each y bin
        inbin_times{iJ,iK}(:,1) = inbin_temp{iJ,iK}(find(~isnan(inbin_temp{iJ,iK}(:,1))),1); %pull out only real timestamps for COM in bins
    end
end
clear inbin_temp iJ iK iL evt;

%%%%% separate trials based on unbroken sequences of occupancy %%%%%
% the results here is "trials" of bin occupency, where each trial
% consititues an unbroken sequence of occupency times such that if the
% animal left the bin for even a single frame, it woudl mark the end of the
% trial
inbin_temp = cell(size(div_space,2)-1,size(div_space,2)-1); %create #bin_X_#bin cell matrix
for iJ = 1:size(inbin_times,1) %for each x bin
    for iK = 1:size(inbin_times,2) %for each y bin
        inbin_temp{iJ,iK} = inbin_times{iJ,iK};
        if ~isempty(inbin_temp{iJ,iK})
            for iL = 1:size(inbin_times{iJ,iK},1)-1
                inbin_temp{iJ,iK}(iL,2) = NaN;
                if (inbin_temp{iJ,iK}(iL+1,1) - inbin_temp{iJ,iK}(iL,1)) < 0.04
                    inbin_temp{iJ,iK}(iL,2) = inbin_temp{iJ,iK}(iL+1,1);
                end
            end
            inbin_temp{iJ,iK}(end,2) = NaN;
            for iL = 1:size(inbin_times{iJ,iK},1)
                if isnan(inbin_temp{iJ,iK}(iL,2))
                    inbin_temp{iJ,iK}(iL,1) = NaN;
                end
            end
        end
    end
end
for iJ = 1:size(inbin_times,1) %for each x bin
    for iK = 1:size(inbin_times,2) %for each y bin
        if ~isempty(inbin_temp{iJ,iK})
            if nansum(inbin_temp{iJ,iK}) == 0
                inbin_temp{iJ,iK} = [];
            end
        end
    end
end
for iJ = 1:size(inbin_times,1) %for each x bin
    for iK = 1:size(inbin_times,2) %for each y bin
        if ~isempty(inbin_temp{iJ,iK})
        x = find(~isnan(inbin_temp{iJ,iK}));
            if x(1) > 1
                for iL = x(1):-1:1
                    inbin_temp{iJ,iK}(iL,:) = [];
                end
            end
        end
    end
end
inbin_trials = cell(size(div_space,2)-1,size(div_space,2)-1); %create #bin_X_#bin cell matrix
for iJ = 1:size(inbin_times,1)
    for iK = 1:size(inbin_times,2)
        if ~isempty(inbin_times{iJ,iK})
            c = 1;
            for iL = 1:size(inbin_temp{iJ,iK},1)
                if iL == 1 && isnan(inbin_temp{iJ,iK}(iL,1))
                    inbin_trials{iJ,iK}(iL,1) = NaN;
                    inbin_trials{iJ,iK}(iL,1) = NaN;
                else
                    if isnan(inbin_temp{iJ,iK}(iL,1))
                        inbin_trials{iJ,iK}(iL,1) = inbin_temp{iJ,iK}(c,1);
                        inbin_trials{iJ,iK}(iL,2) = inbin_temp{iJ,iK}(iL-1,2);
                        c = iL+1;
                    end
                end
            end
        end
    end
end
for iJ = 1:size(inbin_trials,1)
    for iK = 1:size(inbin_trials,2)
        if ~isempty(inbin_trials{iJ,iK})
            for iL = size(inbin_trials{iJ,iK},1):-1:1
                if (inbin_trials{iJ,iK}(iL,1) == 0) && (inbin_trials{iJ,iK}(iL,2) == 0)
                    inbin_trials{iJ,iK}(iL,:) = [];
                end
            end
            for iL = size(inbin_trials{iJ,iK},1):-1:1
                if isnan(inbin_trials{iJ,iK}(iL,1))
                    inbin_trials{iJ,iK}(iL,:) = [];
                end
            end
        end
    end
end
clear inbin_temp iJ iK iL evt c inbin_times;

%%%%% This will turn spike and reward-event times into trials that match occupancy trials %%%%%
for iJ = 1:size(inbin_trials,1) %for each x bin
    for iK = 1:size(inbin_trials,2) %for each y bin
        for iL = 1:size(inbin_trials{iJ,iK},1) %for each "trial"
            inbin_trials{iJ,iK}(iL,3) = 0;
            inbin_trials{iJ,iK}(iL,4) = 0;
            for iM = size(neuron,1):-1:1 %for each spike timestamp of a given neuron (see line 44)
                % check if the given neuron's spike time occured within
                % the given trial time (that is, before the next trial)
                if neuron(iM,1) >= inbin_trials{iJ,iK}(iL,1) && ...
                        neuron(iM,1) <= inbin_trials{iJ,iK}(iL,2)
                    inbin_trials{iJ,iK}(iL,3) = inbin_trials{iJ,iK}(iL,3)+1; %add a spike event for that trial
                    %(the effect is to create a vector of psths across trials)
%                     neuron(iM,:) = [];
                end
            end
            inbin_trials{iJ,iK}(iL,3) = inbin_trials{iJ,iK}(iL,3)/...
                (inbin_trials{iJ,iK}(iL,2)-inbin_trials{iJ,iK}(iL,1));
            % perform the same "trialization" for REWARD EVENT timestamps
            for iM = size(events,1):-1:1
                if events(iM,3) >= inbin_trials{iJ,iK}(iL,1) && ...
                        events(iM,3) <= inbin_trials{iJ,iK}(iL,2)
                    inbin_trials{iJ,iK}(iL,4) = inbin_trials{iJ,iK}(iL,4)+1; %add a event for that trial
%                     events(iM,:) = [];
                end
            end
        end
    end
end
clear iJ iK iL iM div_space neuron;
% now we have, for each spatial bin:
    % 1) a vector of start times for occupancy trials
    % 2) a vector of end times for occupancy trials
    % 3) a vector of spike counts in that trial
    % 4) a vector of reward counts (i.e. reward quantity) in that trial

%%%%% Regress the spike rate (#3) for each trial, on the reward amount, and compute the residual spike rate for each trial %%%%%
for iJ = 1:size(inbin_trials,1) %for each x bin
    for iK = 1:size(inbin_trials,2) %for each y bin
        if ~isempty(inbin_trials{iJ,iK}) %if there are trials in that spatial bin
%             if sum(inbin_trials{iJ,iK}(:,4)) > 0
                Y = inbin_trials{iJ,iK}(:,3); %set outcome to firing across trials
                X = inbin_trials{iJ,iK}(:,4); %set predictor to reward across trials
                b = regress(Y, [ones(length(X),1) X]); %compute regression coefficient
                Yhat = [ones(length(X),1) X]*b; %compute predicted firing rate
                inbin_trials{iJ,iK}(:,5) = Y - Yhat; %compute residual between predicted and actual firing rate
%             else
%                 inbin_trials{iJ,iK} = cells{iI,2}(iJ,iK);
%             end
        end
        clear Y X b Yhat;
    end
end
clear iJ iK;

%%%%% create rate map of residualized firing rates %%%%%
for iJ = 1:size(inbin_trials,1) %for each x bin
    for iK = 1:size(inbin_trials,2) %for each y bin
        if isempty(inbin_trials{iJ,iK}) 
            regressed_rate(iJ,iK) = NaN;
        else
            if size(inbin_trials{iJ,iK},2) > 1
                regressed_rate(iJ,iK) = mean(inbin_trials{iJ,iK}(:,5)); %set matrix of firing rates to the regressed rate across trials
            else
                regressed_rate(iJ,iK) = inbin_trials{iJ,iK};
            end
        end
    end
end

%%%%% save back the information into the original data structure %%%%%
cells{iI,14} = events;
cells{iI,15} = regressed_rate;
clearvars -except cells iI;
clc
iI
toc
end

%% find significant spatial information - 2D
% information = sum_across_bins((probability of being in bin i)*((mFR in
% bin i)/(mFR of cell))*log2*((mFR in
% bin i)/(mFR of cell))

% formally:
% prob_i = prob of being in bin i (i.e. % of time spent in bin)
for iI = 1:size(cells,1)
    XY_mat = cells{iI,12};
    prob_i = XY_mat./sum(XY_mat(:));
    % mFR_i = mean firing rate in bin i
    FRs = cells{iI,15};
    mFR_i = Z_score(FRs);
    % mFR = overal; mean firing rate for the neuron
    mFR = nanmean(FRs(:));
    for iJ = 1:size(mFR_i,1)
        for iK = 1:size(mFR_i,2)
            info_in_bin(iJ,iK) = prob_i(iJ,iK)*(mFR_i(iJ,iK)/mFR)*log2(mFR_i(iJ,iK)/mFR);
            if isnan(info_in_bin(iJ,iK))
                info_in_bin(iJ,iK) = 0;
            end
        end
    end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
    cells{iI,4} = sum(info_in_bin(:));
    cells{iI,16} = info_in_bin;
    iI
end

% shuffle
for iH = 1:size(cells,1)
    XY_mat = cells{iH,12};
    prob_i = XY_mat./sum(XY_mat(:));
    for iI = 1:1000
        % mFR_i = mean firing rate in bin i
        FRs = cells{iH,15};
        mFR_i = Z_score(FRs);
        % mFR = overal; mean firing rate for the neuron
        mFR = nanmean(FRs(:));
        rand1 = randi(size(prob_i,1));
        rand2 = randi(size(prob_i,2));
        for iJ = 1:size(mFR_i,1)
            for iK = 1:size(mFR_i,2)
                info_in_bin(iJ,iK) = prob_i(rand1,rand2)*(mFR_i(iJ,iK)/mFR)*log2(mFR_i(iJ,iK)/mFR);
                if isnan(info_in_bin(iJ,iK))
                    info_in_bin(iJ,iK) = 0;
                end
            end
        end
    % so:
    % information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
        shuffle(iI,1) = sum(info_in_bin(:));
    end
    cells{iH,5} = nanmean(shuffle);
    shuffle_sorted = sort(shuffle);
    rank = find(cells{iH,4} > shuffle_sorted);
    cells{iH,6} = size(rank,1)/10;
    if cells{iH,6} >= 95
        cells{iH,7} = 1;
    else
        cells{iH,7} = 0;
    end
    iH
end
clearvars -except cells

%% rate of sig spatial
for iJ = 1:size(cells,1)
    x(iJ,1) = cells{iJ,7};
end
rate_sig = (sum(x)/size(x,1))*100; clear x;

%% isolate spatial sig
for iJ = 1:size(cells,1)
    for iK = 1:size(cells,2)
        if cells{iJ,7} == 1
            sig{iJ,iK} = cells{iJ,iK};
        end
    end
end
for iJ = size(sig,1):-1:1
    if isempty(sig{iJ,1})
        sig(iJ,:) = [];
    end
end
clear iJ iK;

%% histogram by region
for iJ = 1:size(sig)
    y(iJ,1) = sig{iJ,10};
end
hist(y,30);

%% save
save('filtered_cells_regressed_ONLYwhenPressed','-v7.3');