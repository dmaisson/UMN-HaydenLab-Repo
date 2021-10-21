function output = spaceBinning_COM(input)

tile_size = 10;
axisxmin = -4;
axismax = 4;
axis_segments = tile_size+1;
div = linspace(axisxmin, axismax, axis_segments);
div(end+1) = axismax+1;
occupancy = zeros(tile_size+1);
com = input.com;
% number of frames spent in each spatial bin
for iJ = 1:size(com,1)
    for iK = 1:size(div,2)-1 % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
                if com(iJ,3) >= div(1,iL) && com(iJ,3) < div(1,iL+1)
                    occupancy(iK,iL) = occupancy(iK,iL) + 1; % add a frame counter
                end
            end
        end
    end
end
output = input;
output.occupancy = occupancy./30; % amount of time (s) spent in a given spatial bin