function [binned_rate, binned_count, binned_time] = spikes2degreebins(HD,set,bin_size)

spike_date = set.day;
timeSeries = set.spikeSeries;
for iA = 1:size(HD,1)
    HD_date = HD{iA}.day;
    if sum(HD_date == spike_date) == 10
        x(iA,1) = 1;
    else
        x(iA,1) = NaN;
    end
end
y = find(x == 1);
head_angles = rad2deg(HD{y}.polar(:,1))';
head_angles(1,end+1:size(timeSeries,2)) = NaN;
clearvars -except head_angles timeSeries HD set bin_size;

angle_at_spike = head_angles(timeSeries ~= 0);

degree_bins = (-180:bin_size:180);

binned_count = zeros(size(degree_bins,2)-1,1);
binned_time = zeros(size(degree_bins,2)-1,1);

for iA = 1:size(angle_at_spike,2)
    for iB = 1:size(degree_bins,2)
        if angle_at_spike(1,iA) >= degree_bins(1,iB) && angle_at_spike(1,iA) < degree_bins(1,iB+1)
            binned_count(iB,1) = binned_count(iB,1) + 1;
        end
    end
end

for iA = 1:size(head_angles,2)
    for iB = 1:size(degree_bins,2)
        if head_angles(1,iA) >= degree_bins(1,iB) && head_angles(1,iA) < degree_bins(1,iB+1)
            binned_time(iB,1) = binned_time(iB,1) + 1;
        end
    end
end

binned_rate = (binned_count./binned_time)*33.33333;

% binned_rate = imgaussfilt(binned_rate',bin_size);
binned_rate = binned_rate';
binned_count = binned_count';
binned_time = binned_time';