function [binned_rate, binned_count, binned_time] = spikes2degreebins_quads(quads,day,set,bin_size)

for iZ = 1:size(set,1)
    spike_date = set{iZ}.day;
    timeSeries = set{iZ}.spikeSeries;
    for iA = 1:size(day,1)
        HD_date = day{iA};
        if sum(HD_date == spike_date) == 10
            x(iA,1) = 1;
        else
            x(iA,1) = NaN;
        end
    end
    y = find(x == 1);
    for iB = 1:numel(quads)
        head_angles{iB}(1,:) = rad2deg(quads{iB}{y,1}(:,1))';
        head_angles{iB}(2,:) = quads{iB}{y}(:,4)';
        for iC = 1:size(head_angles{iB},2)
            angle_at_spike{iB}(1,iC) = timeSeries(1,head_angles{iB}(2,iC));
        end
        %     head_angles{iB}(1,end+1:size(timeSeries,2)) = NaN;
        
        %     clearvars -except head_angles timeSeries HD set bin_size;
        
        angle_at_spike{iB} = head_angles{iB}(1,angle_at_spike{iB} ~= 0);
        %     angle_at_spike{iB} = wrapTo360(angle_at_spike{iB});
        degree_bins = (-180:bin_size:180);
        
        count{iB} = zeros(size(degree_bins,2)-1,1);
        time{iB} = zeros(size(degree_bins,2)-1,1);
        
        for iC = 1:size(angle_at_spike{iB},2)
            for iD = 1:size(degree_bins,2)
                if angle_at_spike{iB}(1,iC) >= degree_bins(1,iD) && angle_at_spike{iB}(1,iC) < degree_bins(1,iD+1)
                    count{iB}(iD,1) = count{iB}(iD,1) + 1;
                end
            end
        end
        
        for iC = 1:size(head_angles{iB},2)
            for iD = 1:size(degree_bins,2)
                if head_angles{iB}(1,iC) >= degree_bins(1,iD) && head_angles{iB}(1,iC) < degree_bins(1,iD+1)
                    time{iB}(iD,1) = time{iB}(iD,1) + 1;
                end
            end
        end
        
        rate{iB} = (count{iB}./time{iB})*33.33333;
        
        % binned_rate = imgaussfilt(binned_rate',bin_size);
        binned_rate{iB}(iZ,:) = rate{iB}';
        binned_count{iB}(iZ,:) = count{iB}';
        binned_time{iB}(iZ,:) = time{iB}';
        clear angle_at_spike ans count degree_bins HD_date head_angles rate time iA iB iC iD;
    end
end