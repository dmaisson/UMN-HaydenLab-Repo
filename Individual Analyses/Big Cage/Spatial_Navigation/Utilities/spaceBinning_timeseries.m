function output = spaceBinning_timeseries(input)

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
timeSeries = input.resSeries.*30;
occupancy = input.occupancy;
    
for iJ = 1:size(com_x,2)
    for iK = 1:size(div,2)-1 % check x coordinate
        if com_x(1,iJ) >= div(1,iK) && com_x(1,iJ) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
                if com_y(1,iJ) >= div(1,iL) && com_y(1,iJ) < div(1,iL+1)
                    temp{iK,iL}(1,iJ) = timeSeries(1,iJ); % add the corresponding rate
                else
                    temp{iK,iL}(1,iJ) = NaN; % add the corresponding rate
                end
            end
        end
    end
end
binned_rates(1:size(temp,1),1:size(temp,2)) = NaN;
for iJ = 1:size(temp,1)
    for iK = 1:size(temp,2)
        if ~isempty(temp{iJ,iK})
            binned_rates(iJ,iK) = nanmean(temp{iJ,iK});
        end
        if occupancy(iJ,iK) == 0
            binned_rates(iJ,iK) = NaN;
        end
    end
end
binned_rates_normed = binned_rates./occupancy;

output = input;
output.binned_rates = binned_rates;
output.binned_rates_normed = binned_rates_normed;