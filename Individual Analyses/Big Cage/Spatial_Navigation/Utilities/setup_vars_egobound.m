function [predictors,outcome,deg_binned] = setup_vars_egobound(y,temp)
s = 180000;

[x(:,1),x(:,2)] = cart2pol(temp(:,1),temp(:,2)); %convert x and y of head from cartesian to polar
clear temp %clear the placeholder
temp = rad2deg(x(:,1)); %convert the head angle from radians to degrees
deg_range = linspace(-180,180,360); %generate a binning variable, spaced by 1-degree
deg_range(1,end+1) = 999; %add a place holder to the end for the for-loop
for iL = 1:size(deg_range,2) %loop through the binning variable
    for iM = 1:size(temp,1) %loop through the head angle variable
        if temp(iM,1) > deg_range(1,iL) && temp(iM,1) <= deg_range(1,iL+1) %find cases where the head angle is within a given angle bin
            temp2{1,1}(iL,iM) = x(iM,2); %store the distance in radians from the center of the room
            temp2{1,2}(iL,iM) = y(iM,1); %store the corresponding spike data
        else
            temp2{1,1}(iL,iM) = NaN;
            temp2{1,2}(iL,iM) = NaN;
        end
    end
    boundary(iL,1) = max(temp2{1,1}(iL,:)); %for each head angle, determine the maximum distance (serving as boundary of environment) from the center
end
boundary(end,:) = []; %clear the extra rows
temp2{1,1}(end,:) = [];
temp2{1,2}(end,:) = [];
for iL = 1:size(boundary,1) %loop through the boundary variable
    deg_binned{iL,1} = temp2{1,1}(iL,~isnan(temp2{1,1}(iL,:))); %pull out cases when the binned distance is not NaN
    deg_binned{iL,1} = boundary(iL,1) - deg_binned{iL,1}; %subtract the binned distance from the maximum distance, to end up with distance FROM max (distance from boundary)
    deg_binned{iL,2} = temp2{1,2}(iL,:); %extract the binned spike data
    deg_binned{iL,2}(2,:) = 1:s; %add frame index column
    for iM = 1:s %loop through the frame index
        if iM == deg_binned{iL,2}(2,iM) %for each frame index
            deg_binned{iL,2}(3,iM) = x(iM,1); %add the frame index to the corresponding boundary distance
        else
            deg_binned{iL,2}(2,iM) = NaN;
        end
    end
    deg_binned{iL,2} = deg_binned{iL,2}(:,~isnan(deg_binned{iL,2}(1,:))); %remove NaNs
    deg_binned{iL,2}(2,:) = deg_binned{iL,1};
    if iL == 1 %if it's the first pass
        outcome = deg_binned{iL,2}(1,:)'; %collect the spike data as the outcome
        predictors = deg_binned{iL,2}(2:3,:)'; %collection the distance as the predictor
    else %otherwise
        outcome = cat(1,outcome,(deg_binned{iL,2}(1,:))'); %concatenate the spike data to the end
        predictors = cat(1,predictors,(deg_binned{iL,2}(2:3,:))'); %concatenate the boundary distance
    end
end
end