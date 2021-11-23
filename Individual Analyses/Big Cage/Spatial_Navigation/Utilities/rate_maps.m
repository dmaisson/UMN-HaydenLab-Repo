function [binned_rates,binned_spikes,binned_track,locations,track_times,binned_rates_plotting] = rate_maps(set,tracking,bin_size,win)

enclosure = 300; % in cm

x_axis = enclosure/bin_size;
y_axis = enclosure/bin_size;
%         z_axis = enclosure/bin_size;

resSeries = set.resSeries(1,win);
resSeries(2,:) = (tracking.com(win,1)*100)';
resSeries(3,:) = (tracking.com(win,3)*100)';
resSeries(4,:) = (tracking.com(win,2)*100)';
track_times = 1:size(resSeries,2);
track_x = resSeries(2,:)';
track_y = resSeries(3,:)';
%         track_z = resSeries(4,:)';

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
track_location = zeros(1,size(track_times,2));

%% spiking
x_coo = zeros(1,size(win,2));
for iA = 1:x_axis
    a = find(resSeries(2,:) >= bin_x(1,iA) & resSeries(2,:) < bin_x(1,iA+1));
    if ~isempty(a)
        x_coo(1,a(1,:)) = iA;
    end
    clear a
end
x_coo(1,x_coo==0) = NaN;
y_coo = zeros(1,size(win,2));
for iA = 1:y_axis
    a = find(resSeries(3,:) >= bin_y(1,iA) & resSeries(3,:) < bin_y(1,iA+1));
    if ~isempty(a)
        y_coo(1,a(1,:)) = iA;
    end
    clear a
end
y_coo(1,y_coo==0) = NaN;
for iA = 1:size(x_coo,2)
    if ~isnan(x_coo(1,iA))
        resSeries(5,iA) = locations(x_coo(1,iA),y_coo(1,iA));
    end
end
clear x_coo y_coo

%% tracking
track_x = track_x';
track_y = track_y';
x_coo = zeros(1,size(win,2));
for iA = 1:x_axis
    a = find(track_x(1,:) >= bin_x(1,iA) & track_x(1,:) < bin_x(1,iA+1));
    if ~isempty(a)
        x_coo(1,a(1,:)) = iA;
    end
    clear a
end
x_coo(1,x_coo==0) = NaN;
y_coo = zeros(1,size(win,2));
for iA = 1:y_axis
    a = find(track_y(1,:) >= bin_y(1,iA) & track_y(1,:) < bin_y(1,iA+1));
    if ~isempty(a)
        y_coo(1,a(1,:)) = iA;
    end
    clear a
end
y_coo(1,y_coo==0) = NaN;
for iA = 1:size(x_coo,2)
    if ~isnan(x_coo(1,iA))
        track_location(1,iA) = locations(x_coo(1,iA),y_coo(1,iA));
    end
end
clear x_coo y_coo

%% consolidate
resSeries = resSeries(:,~isnan(resSeries(2,:)));
track_location = track_location(:,~isnan(resSeries(2,:)));
binned_spikes(1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:size(resSeries,2)
    binned_spikes(resSeries(5,iA)) = binned_spikes(resSeries(5,iA)) + resSeries(1,iA);
end

binned_track(1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:size(track_location,2)
    binned_track(track_location(1,iA)) = binned_track(track_location(1,iA)) + 1;
end

binned_rates = (binned_spikes./binned_track).*33.3;
binned_rates = smooth_2d_ratemap(binned_rates, 5);
binned_rates_plotting = binned_rates;
binned_rates_plotting(isnan(binned_rates_plotting(:))) = 0;
binned_rates_plotting(isinf(binned_rates_plotting(:))) = 0;

end