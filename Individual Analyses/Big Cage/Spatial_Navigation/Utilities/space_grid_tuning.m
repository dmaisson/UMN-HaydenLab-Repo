function out = space_grid_tuning(set,tracking,bin_size,CTC)
% spatial and grid tuning

window = 1:size(set.resSeries,2);
[binned_rates,binned_spikes,binned_track,locations,track_times,binned_rates_plotting] = rate_maps(set,tracking,bin_size,window);

        %% Field centers
        
%         field_center_rate = max(binned_rates(:));
%         center_map = zeros(size(binned_rates,1));
%         for iA = 1:numel(center_map)
%             if binned_rates(iA) >= 0.4*field_center_rate
%                 center_map(iA) = 1;
%             end
%         end
%         [field_center(1,:),field_center(2,:)] = find(binned_rates == max(binned_rates(:)));
        
%         min_field_size = numel(binned_rates) * 0.01;
%         max_field_size = numel(binned_rates) * 0.25;
%         field_size = 0;
        
%         for iA = 1:size(binned_rates,1)
%             for iB = 1:size(binned_rates,2)
%                 if center_map(iA,iB) == 1
%                     if center_map(iA+1,iB) == 1
%                         if center_map(iA,iB+1) == 1
%                             field_size = field_size + 1;
%                         end
%                     end
%                 end
%             end
%         end
        
        %% spatial information
        for iA = 1:numel(locations)
            p_i = binned_track(iA)/size(track_times,2);
            lam_i = binned_rates(iA);
            lam = nanmean(binned_rates(:));
            info_i(iA) = (p_i*(lam_i/lam))*log2(lam_i/lam);
        end
        spatial_information = nansum(info_i);
        
        %% cross-temporal correlations
        if CTC == 1
            ten_min = (10*60)*30;
            five_min = ten_min/2;
            
            counter = 1;
            iterator = 1;
            while counter < (size(window,2) - ten_min)
                windows(iterator,:) = counter:(ten_min+counter)-1;
                counter = counter+five_min;
                iterator = iterator + 1;
            end
            clear counter iterator ten_min five_min
            
            for iA = 1:size(windows,1)
                [binned_rates_sm{iA,1},~,~] = rate_maps(set,tracking,bin_size,windows(iA,:));
            end
            
            for iA = 1:size(binned_rates_sm,1)
                for iB = 1:size(binned_rates_sm,1)
                    first = binned_rates_sm{iA}(:);
                    second = binned_rates_sm{iB}(:);
                    cross_temp_corr(iA,iB) = corr(first,second);
                    clear first second
                end
            end
            clear binned_rates_sm windows iA iB window
            out.cross_temp_corr = cross_temp_corr;
        end
        % 2 sec run-time
        %% autocorrelagram
        
        autocorrelogram = spatial_autocorrelogram(binned_rates,size(binned_rates,2));
%         autocorrelogram = imgaussfilt(autocorrelogram);
        
        %% Calculate gridness score
        [grid_score,rotations] = gridness(autocorrelogram);
        
        %% collect
        out.autocorrelogram = autocorrelogram;
        out.binned_rates = binned_rates;
        out.binned_track = binned_track;
        out.binned_spikes = binned_spikes;
        out.binned_rates_plotting = binned_rates_plotting;
        out.spatial_information = spatial_information;
%         out.field_center = field_center;
        out.grid_score = grid_score;
        out.rotations = rotations;