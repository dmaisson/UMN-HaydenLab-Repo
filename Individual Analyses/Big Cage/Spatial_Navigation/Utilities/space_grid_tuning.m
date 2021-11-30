function out = space_grid_tuning(set,tracking,bin_size,CTC)
% spatial and grid tuning

win = 1:size(set.resSeries,2);
maps = rate_maps(set,tracking,bin_size,win);

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
        for iA = 1:numel(maps.locations)
            p_i = maps.binned_track(iA)/size(maps.track_times,2);
            lam_i = maps.binned_rates(iA);
            lam = nanmean(maps.binned_rates(:));
            info_i(iA) = (p_i*(lam_i/lam))*log2(lam_i/lam);
        end
        spatial_information = nansum(info_i);
        
        %% cross-temporal correlations
        if CTC == 1
            ten_min = (10*60)*30;
            five_min = ten_min/2;
            
            counter = 1;
            iterator = 1;
            while counter < (size(win,2) - ten_min)
                wins(iterator,:) = counter:(ten_min+counter)-1;
                counter = counter+five_min;
                iterator = iterator + 1;
            end
            clear counter iterator ten_min five_min
            
            for iA = 1:size(wins,1)
                maps_CTC{iA} = rate_maps(set,tracking,bin_size,wins(iA,:));
            end
            
            for iA = 1:size(maps_CTC,2)
                for iB = 1:size(maps_CTC,2)
                    first = maps_CTC{iA}.binned_rates(~isnan(maps_CTC{iA}.binned_rates));
                    first = first(:);
                    second = maps_CTC{iB}.binned_rates(~isnan(maps_CTC{iB}.binned_rates));
                    second = second(:);
                    smaller = min([size(first,1) size(second,1)]);
                    cross_temp_corr(iA,iB) = corr(first(1:smaller),second(1:smaller));
                    clear first second
                end
            end
            clear maps_CTC windows iA iB window
            out.cross_temp_corr = cross_temp_corr;
        end
        % 2 sec run-time
        %% autocorrelagram
        autocorrelogram = spatial_autocorrelogram(maps.binned_rates,size(maps.binned_rates,2));
        
        %% Calculate gridness score
        [grid_score,rotations] = gridness(autocorrelogram);
        
        %% collect
        out.autocorrelogram = autocorrelogram;
        out.maps = maps;
        out.spatial_information = spatial_information;
%         out.field_center = field_center;
        out.grid_score = grid_score;
        out.rotations = rotations;