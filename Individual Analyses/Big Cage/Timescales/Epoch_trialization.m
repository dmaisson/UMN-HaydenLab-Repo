function psth = Epoch_trialization(in,lfp,trial_length,epochs,res)

% in should be the cell-separated structure array
    %spikeSeries is the structure field containing the raw spike series
    %lfp: a binary (yes/no) argument indicating whether the data being
        %trialized is the processed LFP time series
    %lfpSeries is the down-sampled, pre-processed LFP time series field
    %trial_length: indicates how many seconds the trial should be following
        %a start time
    %epochs: indicates the number of continuous epochs
    %res: a flag to indicate if the spike series should be the
        %reward_residualized signal or the now (0: raw, 1: res)

        
    window_size = trial_length*30; %30 frames is 1 second, so 60 frames (i.e. 60 time bins) is 2 seconds of data
    s = size(in{1}.spikeSeries,2); %data is time binned by capture data frame-rate (30Hz)
    epoch_window = s/epochs;
    n = epoch_window/window_size;
    epoch_segments = cell(epochs,1);
    
    for iB = 1:epochs
        for iC = 1:size(in,1)
            psth{iB,1}{iC,1} = NaN(n,window_size); %initialize an empty variable
        end
    end
    
    for iA = 1:size(in,1)
        if res == 0
            spikeSeries = in{iA}.spikeSeries;
        else
            spikeSeries = in{iA}.resSeries;
        end
        if lfp == 1
            lfpSeries = in{iA}.lfpSeries;
        end
        
        start = 1;
        if lfp == 0
            for iB = 1:epochs
                epoch_segments{iB,1} = spikeSeries(1,start:(start+epoch_window)-1);
                start = start+epoch_window;
            end
        else
            for iB = 1:epochs
                epoch_segments{iB,1} = lfpSeries(1,start:(start+epoch_window)-1);
                start = start+epoch_window;
            end
        end %how many trials there will be, based on how many spikes there were
        
        start = 1;
        for iB = 1:epochs
            start = 1;
            for iC = 1:n
                psth{iB,1}{iA,1}(iC,:) = epoch_segments{iB,1}(1,start:(start+window_size)-1);
                start = start+window_size;
            end
        end
    clear epoch_segments start spikeSeries lfpSeries
    end

end