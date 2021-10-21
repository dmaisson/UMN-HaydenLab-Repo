function out = HD_tuning_glm(set,head_direction)

resSeries = set.resSeries;
spike_day = set.day;

for iA = 1:size(head_direction,1)
    HD_day = head_direction{iA}.day;
    if sum((HD_day == spike_day)) == 10
        idx = iA;
    end
end

yaw = head_direction{idx}.yaw(:,1);
% resSeries = imgaussfilt(resSeries);
% angles = wrapTo360(rad2deg(polar(:,1)));
% angles = rad2deg(polar(:,1));
% angles(end+1:size(resSeries,2),1) = NaN;
yaw(end+1:size(resSeries,2),1) = NaN;

% out = fit_lc(angles,resSeries,[]);
out = fit_lc(yaw,resSeries,[]);