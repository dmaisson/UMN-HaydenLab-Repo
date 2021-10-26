function psth = SpikeTime_trialization(in,lfp,trial_length)

% in should be the cell-separated structure array
    %spikeSeries is the structure field containing the raw spike series
    %lfp: a binary (yes/no) argument indicating whether the data being
        %trialized is the processed LFP time series
    %lfpSeries is the down-sampled, pre-processed LFP time series field
    %trial_length: indicates how many seconds the trial should be following
        %a spike event
        
spikeSeries = in.spikeSeries;
if lfp == 1
    lfpSeries = in.lfpSeries;
end
spike_idx = find(spikeSeries == 1);

s = size(spikeSeries,2); %data is time binned by capture data frame-rate (30Hz)

window_size = trial_length*30; %30 frames is 1 second, so 60 frames (i.e. 60 time bins) is 2 seconds of data

n = size(spike_idx,2); %how many trials there will be, based on how many spikes there were

psth = zeros(n,window_size); %initialize an empty variable

if lfp == 0 %if we're dealing with spikes
    for iA = 1:n %iterate through the trials
        if spike_idx(iA)+(window_size-1) < s %if there are enough data points left in the series to fit into a trial
            psth(iA,:) = spikeSeries(1,spike_idx(iA):spike_idx(iA)+(window_size-1)); %take the spike as the first time point, and add 2 second of the signal to the rest of the trial
        else %if the spike happened toward the end, and there aren't enough time bins left to complete the trial
            temp = spikeSeries(1,spike_idx(iA):end); %place holder for the the content that is available
            append_var = size(temp,2); %determine how many bins are missing to be a complete trial
            cat_var = zeros(1,size(psth,2) - append_var); %create a vector of zeros for whatever is required to complete the trial
            temp = cat(2,temp,cat_var); %concatenate the two
            psth(iA,:) = temp; %add those zeros to the end of the "trial"
        end
    end
else %if we're dealing with the LFP, do the same but store the LFP series values
    for iA = 1:n
        if spike_idx(iA)+(window_size-1) < s
            psth(iA,:) = lfpSeries(1,spike_idx(iA):spike_idx(iA)+(window_size-1));
        else
            temp = lfpSeries(1,spike_idx(iA):end);
            append_var = size(temp,2);
            cat_var = zeros(1,size(psth,2) - append_var);
            temp = cat(2,temp,cat_var);
            psth(iA,:) = temp;
        end
    end
end

end