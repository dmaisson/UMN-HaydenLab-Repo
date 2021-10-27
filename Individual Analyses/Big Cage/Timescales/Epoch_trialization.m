function psth = Epoch_trialization(in,lfp,trial_length,epochs)

% in should be the cell-separated structure array
    %spikeSeries is the structure field containing the raw spike series
    %lfp: a binary (yes/no) argument indicating whether the data being
        %trialized is the processed LFP time series
    %lfpSeries is the down-sampled, pre-processed LFP time series field
    %trial_length: indicates how many seconds the trial should be following
        %a start time
    %epochs: indicates the number of continuous epochs

    
    spikeSeries = in.spikeSeries;
    if lfp == 1
        lfpSeries = in.lfpSeries;
    end
    
    s = size(spikeSeries,2); %data is time binned by capture data frame-rate (30Hz)
    epoch_window = s/epochs;
    epoch_segments = cell(epochs,1);
    start = 1;

    if lfp == 0
        for iA = 1:epochs
            epoch_segments{iA,1} = spikeSeries(1,start:(start+epoch_window)-1);
            start = start+epoch_window;
        end
    else
        for iA = 1:epochs
            epoch_segments{iA,1} = lfpSeries(1,start:(start+epoch_window)-1);
            start = start+epoch_window;
        end
    end
    
    window_size = trial_length*30; %30 frames is 1 second, so 60 frames (i.e. 60 time bins) is 2 seconds of data
    
    n = epoch_window/window_size; %how many trials there will be, based on how many spikes there were
    
    for iA = 1:epochs
        psth{iA,1} = zeros(n,window_size); %initialize an empty variable
    end
    
    for iA = 1:epochs
        start = 1;
        for iB = 1:n
            psth{iA,1}(iB,:) = epoch_segments{iA,1}(1,start:(start+window_size)-1);
            start = start+window_size;
        end
    end

end