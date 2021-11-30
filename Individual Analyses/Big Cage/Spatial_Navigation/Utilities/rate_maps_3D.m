function out = rate_maps_3D(set,tracking,bin_size,win)

enclosure = 300; % in cm

x_axis = enclosure/bin_size;
y_axis = enclosure/bin_size;
z_axis = enclosure/bin_size;

resSeries = set.resSeries(1,win);
resSeries(2,:) = (tracking.com(win,3)*100)';
resSeries(3,:) = (tracking.com(win,1)*100)';
resSeries(4,:) = (tracking.com(win,2)*100)';
track_times = 1:size(resSeries,2);
track_x = resSeries(2,:)';
track_y = resSeries(3,:)';
track_z = resSeries(4,:)';

bin_x = linspace(min(resSeries(2,:)),max(resSeries(2,:)),x_axis);
bin_y = linspace(min(resSeries(3,:)),max(resSeries(3,:)),y_axis);
bin_z = linspace(min(resSeries(4,:)),max(resSeries(4,:)),z_axis);

locations(1:x_axis,1:y_axis,1:z_axis) = NaN;
for iA = 1:numel(locations)
    locations(iA) = iA;
end

bin_x(1,end+1) = bin_x(1,end)+999;
bin_y(1,end+1) = bin_y(1,end)+999;
bin_z(1,end+1) = bin_z(1,end)+999;
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
z_coo = zeros(1,size(win,2));
for iA = 1:z_axis
    a = find(resSeries(4,:) >= bin_z(1,iA) & resSeries(4,:) < bin_z(1,iA+1));
    if ~isempty(a)
        z_coo(1,a(1,:)) = iA;
    end
    clear a
end
z_coo(1,z_coo==0) = NaN;
for iA = 1:size(x_coo,2)
    if ~isnan(x_coo(1,iA))
        resSeries(5,iA) = locations(x_coo(1,iA),y_coo(1,iA),z_coo(1,iA));
    end
end
clear x_coo y_coo z_coo

%% tracking
track_x = track_x';
track_y = track_y';
track_z = track_z';
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
z_coo = zeros(1,size(win,2));
for iA = 1:y_axis
    a = find(track_z(1,:) >= bin_z(1,iA) & track_z(1,:) < bin_z(1,iA+1));
    if ~isempty(a)
        z_coo(1,a(1,:)) = iA;
    end
    clear a
end
z_coo(1,z_coo==0) = NaN;
for iA = 1:size(x_coo,2)
    if ~isnan(x_coo(1,iA))
        track_location(1,iA) = locations(x_coo(1,iA),y_coo(1,iA),z_coo(1,iA));
    end
end
clear x_coo y_coo z_coo

%% consolidate
resSeries = resSeries(:,~isnan(resSeries(2,:)));
track_location = track_location(:,~isnan(resSeries(2,:)));
binned_spikes(1:size(locations,1),1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:size(resSeries,2)
    binned_spikes(resSeries(5,iA)) = binned_spikes(resSeries(5,iA)) + resSeries(1,iA);
end
binned_track(1:size(locations,1),1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:size(track_location,2)
    binned_track(track_location(1,iA)) = binned_track(track_location(1,iA)) + 1;
end
binned_rates(1:size(locations,1),1:size(locations,1),1:size(locations,1)) = 0;
for iA = 1:numel(binned_spikes)
    binned_rates(iA) = (binned_spikes(iA)/binned_track(iA))*33.3;
end

% binned_rates = imgaussfilt(binned_rates, 5);
binned_rates_plotting = binned_rates;
binned_rates_plotting(isnan(binned_rates_plotting(:))) = 0;
binned_rates_plotting(isinf(binned_rates_plotting(:))) = 0;

%% spatial information
for iA = 1:numel(locations)
    p_i = binned_track(iA)/size(track_times,2);
    lam_i = binned_rates(iA);
    lam = nanmean(binned_rates(:));
    info_i(iA) = (p_i*(lam_i/lam))*log2(lam_i/lam);
end
spatial_information = nansum(info_i);

%% save
out.track_times = track_times;
out.locations = locations;
out.track_location = track_location;
out.spike_location = resSeries(5,:);
out.binned_rates = binned_rates;
out.binned_spikes = binned_spikes;
out.binned_track = binned_track;
out.binned_rates_plotting = binned_rates_plotting;
out.spatial_information = spatial_information;

end