function psth = LeverEvent_trialization(in,lfp,trial_length)

% in should be the cell-separated structure array
    %spikeSeries is the structure field containing the raw spike series
    %lfp: a binary (yes/no) argument indicating whether the data being
        %trialized is the processed LFP time series
    %lfpSeries is the down-sampled, pre-processed LFP time series field
    %eventSeries is the structure field containing a row vector of
        %leverpress events, binned against the captured frames
    %trial_length: indicates how many seconds the trial should be on either
        %side of the leverpress
        
eventSeries = in.eventSeries;
spikeSeries = in.spikeSeries;
if lfp == 1
    lfpSeries = in.lfpSeries;
end

event_idx = find(eventSeries == 1);

s = size(eventSeries,2); %data is time binned by capture data frame-rate (30Hz) i.e. 33.3 ms

window_size = trial_length*30; %30 frames is 1 second, so 60 frames (i.e. 60 time bins) is 2 seconds of data

n = size(event_idx,2); %how many trials there will be, based on how many spikes there were

psth = zeros(n,window_1seconds*2); %initialize an empty variable

if lfp == 0 %if we're dealing with spikes
    for iA = 1:n %iterate through the trials
        if event_idx(iA) - (window_1seconds-1) > 1 %check if there are enough times from start to first leverpress
            if event_idx(iA)+(window_1seconds-1) < s %if there are enough data points left in the series to fit into a trial
                psth(iA,:) = spikeSeries(1,event_idx(iA)-(window_1seconds):event_idx(iA)+(window_1seconds-1)); %take the event as the first time point, and add 1 second of the signal to the rest of the trial to both sides
            else %if the event happened toward the end, and there aren't enough time bins left to complete the trial
                temp = spikeSeries(1,event_idx(iA):end); %place holder for the the content that is available
                append_var = size(temp,2); %determine how many bins are missing to be a complete trial
                cat_var = zeros(1,size(psth,2) - append_var); %create a vector of zeros for whatever is required to complete the trial
                temp = cat(2,temp,cat_var); %concatenate the two
                psth(iA,:) = temp; %add those zeros to the end of the "trial"
            end
        else %if there are too few bins before the lever press
            temp = spikeSeries(1,1:event_idx(iA)+(window_1seconds-1));
            append_var = size(temp,2);
            cat_var = zeros(1,size(psth,2) - append_var);
            temp = cat(2,cat_var,temp);
            psth(iA,:) = temp;
        end
    end
else %if we're dealing with the LFP, do the same but store the LFP series values
    for iA = 1:n %iterate through the trials
        if event_idx(iA) - (window_1seconds-1) > 1 %check if there are enough times from start to first leverpress
            if event_idx(iA)+(window_1seconds-1) < s %if there are enough data points left in the series to fit into a trial
                psth(iA,:) = lfpSeries(1,event_idx(iA)-(window_1seconds):event_idx(iA)+(window_1seconds-1)); %take the event as the first time point, and add 1 second of the signal to the rest of the trial to both sides
            else %if the event happened toward the end, and there aren't enough time bins left to complete the trial
                temp = lfpSeries(1,event_idx(iA):end); %place holder for the the content that is available
                append_var = size(temp,2); %determine how many bins are missing to be a complete trial
                cat_var = zeros(1,size(psth,2) - append_var); %create a vector of zeros for whatever is required to complete the trial
                temp = cat(2,temp,cat_var); %concatenate the two
                psth(iA,:) = temp; %add those zeros to the end of the "trial"
            end
        else %if there are too few bins before the lever press
            temp = lfpSeries(1,1:event_idx(iA)+(window_1seconds-1));
            append_var = size(temp,2);
            cat_var = zeros(1,size(psth,2) - append_var);
            temp = cat(2,cat_var,temp);
            psth(iA,:) = temp;
        end
    end
end

end