function output = spikes2degreebins_resSeries(set,head_direction,bin_size)

resSeries = set.resSeries;
spike_day = set.day;

for iA = 1:size(head_direction,1)
    HD_day = head_direction{iA}.day;
    if sum((HD_day == spike_day)) == 10
        idx = iA;
    end
end
polar = wrapTo360(rad2deg(head_direction{idx}.yaw(:,1)'));

s = size(resSeries,2);

degrees = linspace(0,360-bin_size,360/bin_size);
degrees(1,end+1) = 360;

degree_times = cell(size(degrees,2)-1,1);
for iA = 1:size(degree_times,1)
    degree_times{iA,1}(1,1:s) = NaN;
end

angleSeries = polar(1,:);
angleSeries(1,end+1:s) = NaN;

cycles = 1:size(angleSeries,2);

for iA = 1:size(degrees,2)-1
    for iB = 1:s
        if angleSeries(1,iB) > degrees(1,iA) && angleSeries(1,iB) <= degrees(1,iA+1)
            degree_times{iA,1}(1,iB) = cycles(1,iB);
        end
    end
    degree_times{iA,1} = degree_times{iA,1}(~isnan(degree_times{iA,1}));
end

binned_resSeries = cell(size(degrees,2)-1,1);

for iA = 1:size(degree_times,1)
    x = degree_times{iA,1};
    for iB = 1:size(x,2)-1
        y(iB,1) = x(1,iB);
        y(iB,2) = x(1,iB+1);
    end
    for iB = 1:size(y,1)
        if (y(iB,2) - y(iB,1)) ~= 1
            y(iB,1) = y(iB,2);
        end
    end
    for iB = size(y,1):-1:2
        if y(iB,1) == y(iB-1,1)
            y(iB-1,:) = [];
        end
    end
    for iB = size(y,1):-1:2
        if (y(iB,1) - y(iB-1,1)) == 1
            y(iB-1,2) = y(iB,2);
            y(iB,:) = [];
        end
    end
    y(:,3) = (((y(:,2) - y(:,1))+1)/30)*1000;
    degree_times{iA,2} = y;
    clear x y;
    
    temp{iA,1} = cell(size(degree_times{iA,2},1),1);
%     binned_resSeries{iA,1} = cell(size(degree_times{iA,2},1),1);
    for iB = 1:size(degree_times{iA,2},1)
        temp{iA,1}{iB,1} = resSeries(1,degree_times{iA,2}(iB,1):degree_times{iA,2}(iB,2));
        x(iB,1) = size(temp{iA,1}{iB,1},2);
        mean_binned_resSeries{iA,1}(iB,1) = mean(temp{iA,1}{iB,:});
    end
    y = max(x);
    for iB = 1:size(degree_times{iA,2},1)
        temp{iA,1}{iB,1}(1,end+1:y) = NaN;
        binned_resSeries{iA,1}(iB,:) = temp{iA,1}{iB,1};
    end
    angle_kernel{iA,1} = nanmean(binned_resSeries{iA,1},1);
    clear temp x y
    binned_rate(1,iA) = (mean(mean_binned_resSeries{iA,1}))*30;
end

output.degree_times = degree_times;
output.binned_resSeries = binned_resSeries;
output.binned_rate = binned_rate;
output.degrees = degrees;
output.mean_binned_resSeries = mean_binned_resSeries;
output.angle_kernel = angle_kernel;
