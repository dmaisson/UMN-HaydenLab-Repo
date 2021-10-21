function output = spaceBinning_COM_3D(input)

tile_size = 10;
axisxmin = -4;
axismax = 4;
axis_segments = tile_size+1;
div = linspace(axisxmin, axismax, axis_segments);
div(end+1) = axismax+1;
for iJ = 1:tile_size+1
    occupancy3D(:,:,iJ) = zeros(tile_size+1);
end
com = input.com;
% number of frames spent in each spatial bin
for iJ = 1:size(com,1)
    for iK = 1:size(div,2)-1 % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
                if com(iJ,3) >= div(1,iL) && com(iJ,3) < div(1,iL+1)
                    for iM = 1:size(div,2)-1 %check z coordinate
                        if com(iJ,2) >= div(1,iM) && com(iJ,2) < div(1,iM+1)
                            occupancy3D(iK,iL,iM) = occupancy3D(iK,iL,iM) + 1; % add a frame counter
                        end
                    end
                end
            end
        end
    end
end
output = input;
output.occupancy3D = occupancy3D./30; % amount of time (s) spent in a given spatial bin