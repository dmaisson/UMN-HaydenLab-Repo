function output = spaceBinning_timeseries_3D(input)

tile_size = 10;
axisxmin = -4;
axismax = 4;
axis_segments = tile_size+1;
div = linspace(axisxmin, axismax, axis_segments);
div(end+1) = axismax+1;
temp = cell(tile_size+1); %create a binned map of space with zeroes
com = input.com;
com_x = com(:,1)';
com_y = com(:,3)';
com_z = com(:,2)';
timeSeries = (input.resSeries);
occupancy = input.occupancy3D;

for iJ = 1:size(com_x,2)
    for iK = 1:size(div,2)-1 % check x coordinate
        if com_x(1,iJ) >= div(1,iK) && com_x(1,iJ) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
                if com_y(1,iJ) >= div(1,iL) && com_y(1,iJ) < div(1,iL+1)
                    for iM = 1:size(div,2)-1 %check z coordinate
                        if com_z(1,iJ) >= div(1,iM) && com_z(1,iJ) < div(1,iM+1)
                            temp{iK,iL,iM}(1,iJ) = timeSeries(1,iJ); % add the corresponding rate
                        else
                            temp{iK,iL,iM}(1,iJ) = NaN; % add the corresponding rate
                        end
                    end
                end
            end
        end
    end
end
binned_rates(1:size(temp,1),1:size(temp,2),1:size(temp,3)) = NaN;
for iJ = 1:size(temp,1)
    for iK = 1:size(temp,2)
        for iL = 1:size(temp,3)
            if ~isempty(temp{iJ,iK,iL})
                binned_rates(iJ,iK,iL) = (nanmean(temp{iJ,iK,iL}))*30;
            end
            if occupancy(iJ,iK,iL) == 0
                binned_rates(iJ,iK,iL) = NaN;
            end
        end
    end
end
binned_rates_normed = binned_rates./occupancy;

output = input;
output.binned_rates3D = binned_rates;
output.binned_rates_normed3D = binned_rates_normed;