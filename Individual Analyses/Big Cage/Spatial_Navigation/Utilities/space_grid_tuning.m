function out = space_grid_tuning(set,tracking,bin_size)
% spatial and grid tuning
    % spatial smoothing
    
        %%%%% need to correct for 'edge' artifacts  %%%%%
        %%%%%   need to try gradual elimination?    %%%%%
        
        enclosure = 300; % in cm
        
        x_axis = enclosure/bin_size;
        y_axis = enclosure/bin_size;
        z_axis = enclosure/bin_size;
        
%         spike_times = set.spikeTimes(:,1)*30;
%         spike_x = set.spikeTimes(:,2)*100;
%         spike_y = set.spikeTimes(:,3)*100;
%         spike_z = set.spikeTimes(:,4)*100;
%         n = size(spike_times,1);
        spikeSeries = set.spikeSeries;
        resSeries = set.resSeries;
        com_temp = tracking.com';
        resSeries(2,:) = com_temp(1,:)*100;
        resSeries(3,:) = com_temp(3,:)*100;
        resSeries(4,:) = com_temp(2,:)*100;
        
        bin_x = linspace(min(resSeries(2,:)),max(resSeries(2,:)),x_axis);
        bin_y = linspace(min(resSeries(3,:)),max(resSeries(3,:)),y_axis);
        bin_z = linspace(min(resSeries(4,:)),max(resSeries(4,:)),z_axis);
        
        locations(1:x_axis,1:y_axis) = NaN; 
        for iA = 1:x_axis
            if iA == 1
                locations(:,iA) = 1:x_axis;
            else
                locations(:,iA) = locations(:,iA-1) + x_axis;
            end
        end
        
        bin_x(1,end+1) = bin_x(1,end)+999;
        bin_y(1,end+1) = bin_y(1,end)+999;
        
        for iA = 1:x_axis
            for iB = 1:y_axis
                for iC = 1:size(resSeries,2)
                    if (resSeries(2,iC) >= bin_x(1,iA) && resSeries(2,iC) < bin_x(1,iA+1)) ...
                            && (resSeries(3,iC) >= bin_y(1,iB) && resSeries(3,iC) < bin_y(1,iB+1))
                        resSeries(5,iC) = locations(iA,iB);
                    end
                end
            end
        end
        
%         spike_location(1:n,1) = NaN;
%         for iA = 1:x_axis
%             for iB = 1:y_axis
%                 for iC = 1:n
%                     if (spike_x(iC,1) >= bin_x(1,iA) && spike_x(iC,1) < bin_x(1,iA+1)) ...
%                             && (spike_y(iC,1) >= bin_y(1,iB) && spike_y(iC,1) < bin_y(1,iB+1))
%                         spike_location(iC,1) = locations(iA,iB);
%                     end
%                 end
%             end
%         end
        
        %
        track_times = 1:size(tracking.com,1);
        track_x = tracking.com(:,1)*100;
        track_y = tracking.com(:,3)*100;
        track_z = tracking.com(:,2)*100;
        clear com
        
        track_location(1:size(track_times,2),1) = NaN;
        for iA = 1:x_axis
            for iB = 1:y_axis
                for iC = 1:size(track_times,2)
                    if (track_x(iC,1) >= bin_x(1,iA) && track_x(iC,1) < bin_x(1,iA+1)) ...
                            && (track_y(iC,1) >= bin_y(1,iB) && track_y(iC,1) < bin_y(1,iB+1))
                        track_location(iC,1) = locations(iA,iB);
                    end
                end
            end
        end
        
        %
        resSeries = resSeries(:,~isnan(resSeries(2,:)));
        binned_spikes(1:size(locations,1),1:size(locations,1)) = 0;
        for iA = 1:size(resSeries,2)
            binned_spikes(resSeries(5,iA)) = binned_spikes(resSeries(5,iA)) + resSeries(1,iA);
        end
        
%         spike_location = spike_location(~isnan(spike_location));
%         binned_spikes(1:size(locations,1),1:size(locations,1)) = 0;
%         for iA = 1:size(spike_location,1)
%             binned_spikes(spike_location(iA,1)) = binned_spikes(spike_location(iA,1)) + resSeries(1,iA);
%         end
        
%         for iA = 1:size(spike_location,1)
%             binned_spikes(spike_location(iA,1)) = binned_spikes(spike_location(iA,1)) + 1;
%         end
        
        track_location = track_location(~isnan(track_location));
        binned_track(1:size(locations,1),1:size(locations,1)) = 0;
        for iA = 1:size(track_location,1)
            binned_track(track_location(iA,1)) = binned_track(track_location(iA,1)) + 1;
        end
        
        binned_rates = (binned_spikes./binned_track).*33.3;
        binned_rates(isnan(binned_rates(:))) = 0;
        binned_rates(isinf(binned_rates(:))) = 0;
        binned_rates = smooth_2d_ratemap(binned_rates, 5);
%         cleavars -except binned_rates binned_spikes binned_track spike_locations spike_times track_location

        %% Field centers
        
        field_center_rate = max(binned_rates(:));
        center_map = zeros(size(binned_rates,1));
        for iA = 1:numel(center_map)
            if binned_rates(iA) >= 0.4*field_center_rate
                center_map(iA) = 1;
            end
        end
        [field_center(1,:),field_center(2,:)] = find(binned_rates == max(binned_rates(:)));
        
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
        
        
        
        %% autocorrelagram
%         for iA = 1:numel(binned_rates)
%             rate_location(iA,1) = binned_rates(iA);
%         end
%         rate_location(isnan(rate_location)) = 0;
%         tau = (1:size(rate_location,1))';
%         
%         for iA = 1:size(rate_location,1)
%             if iA == 1
%                 shifted_location = rate_location;
%                 space_autocorr_lin(iA,1) = corr(rate_location(:,1),shifted_location(:,1),'Type','Pearson');
%             else
%                 shift = tau(iA:end);
%                 dropped = 1:shift(1); dropped(end) = []; dropped = dropped';
%                 shift = cat(1,shift,dropped);
%                 for iB = 1:size(shift,1)
%                     shifted_location(iB,1) = rate_location(shift(iB,1),1);
%                 end
%                 space_autocorr_lin(iA,1) = corr(rate_location(:,1),shifted_location(:,1),'Type','Pearson');
%                 clear shift dropped shifted_location;
%             end
%         end
%         
%         space_autocorr_binned = zeros(x_axis);
%         for iA = 1:size(space_autocorr_lin,1)
%             space_autocorr_binned(iA) = space_autocorr_lin(iA,1);
%         end
        
        autocorrelogram = spatial_autocorrelogram(binned_rates,x_axis);
        
        %% Calculate gridness score
        
        
%         [gridSize, gridOrientation, ellipseCoords, orientationAngs, ...
%             sixPkCoords, threeAngleCoords] = get_gridfield_stats(autocorrelogram);
        
        %% collect
        out.autocorrelogram = autocorrelogram;
        out.binned_rates = binned_rates;
        out.binned_track = binned_track;
        out.binned_spikes = binned_spikes;
        out.spatial_information = spatial_information;
        out.field_center = field_center;