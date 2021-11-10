function [binned_rates,binned_spikes,binned_track,locations,track_times] = rate_maps(set,tracking,bin_size,window)

enclosure = 300; % in cm

x_axis = enclosure/bin_size;
y_axis = enclosure/bin_size;
%         z_axis = enclosure/bin_size;

resSeries = set.resSeries(1,window);
com_temp = tracking.com';
com_temp = com_temp(:,window);
resSeries(2,:) = com_temp(1,:)*100;
resSeries(3,:) = com_temp(3,:)*100;
resSeries(4,:) = com_temp(2,:)*100;

bin_x = linspace(min(resSeries(2,:)),max(resSeries(2,:)),x_axis);
bin_y = linspace(min(resSeries(3,:)),max(resSeries(3,:)),y_axis);
%         bin_z = linspace(min(resSeries(4,:)),max(resSeries(4,:)),z_axis);

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

track_times = 1:size(resSeries,2);
track_x = tracking.com(window,1)*100;
track_y = tracking.com(window,3)*100;
%         track_z = tracking.com(:,2)*100;
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

track_location = track_location(~isnan(track_location));
binned_track(1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:size(track_location,1)
    binned_track(track_location(iA,1)) = binned_track(track_location(iA,1)) + 1;
end

binned_rates = (binned_spikes./binned_track).*30;
binned_rates(isnan(binned_rates(:))) = 0;
binned_rates(isinf(binned_rates(:))) = 0;
binned_rates = smooth_2d_ratemap(binned_rates, 5);

end