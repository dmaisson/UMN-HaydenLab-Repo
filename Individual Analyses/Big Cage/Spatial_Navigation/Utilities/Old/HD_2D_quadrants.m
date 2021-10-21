function [quads,day] = HD_2D_quadrants(head_nose_coordinates,head_direction)

upper_left = cell(size(head_nose_coordinates,1),1);
upper_right = cell(size(head_nose_coordinates,1),1);
lower_left = cell(size(head_nose_coordinates,1),1);
lower_right = cell(size(head_nose_coordinates,1),1);

for iJ = 1:size(head_nose_coordinates,1)
    n = size(head_nose_coordinates{iJ}.head,1);
    head_nose_coordinates{iJ}.head(:,4) = 1:n;
    head_direction{iJ}.polar(:,4) = 1:n;
    
    temp = head_nose_coordinates{iJ}.head(head_nose_coordinates{iJ}.head(:,1) < 0,:);
    temp2 = temp(temp(:,3) > 0,:);
    polar(1:n,1:4) = NaN;
    for iK = 1:size(temp2,1)
        polar(temp2(iK,4),:) = head_direction{iJ}.polar(temp2(iK,4),:);
    end
    polar = polar(~isnan(polar(:,4)),:);
    upper_left{iJ,1} = polar;
    clear temp temp2 polar;
    
    temp = head_nose_coordinates{iJ}.head(head_nose_coordinates{iJ}.head(:,1) > 0,:);
    temp2 = temp(temp(:,3) > 0,:);
    polar(1:n,1:4) = NaN;
    for iK = 1:size(temp2,1)
        polar(temp2(iK,4),:) = head_direction{iJ}.polar(temp2(iK,4),:);
    end
    polar = polar(~isnan(polar(:,4)),:);
    upper_right{iJ,1} = polar;
    clear temp temp2 polar;
    
    temp = head_nose_coordinates{iJ}.head(head_nose_coordinates{iJ}.head(:,1) > 0,:);
    temp2 = temp(temp(:,3) <= 0,:);
    polar(1:size(head_direction{iJ}.polar,1),1:4) = NaN;
    for iK = 1:size(temp2,1)
        polar(temp2(iK,4),:) = head_direction{iJ}.polar(temp2(iK,4),:);
    end
    polar = polar(~isnan(polar(:,4)),:);
    lower_right{iJ,1} = polar;
    clear temp temp2 polar;
    
    temp = head_nose_coordinates{iJ}.head(head_nose_coordinates{iJ}.head(:,1) <= 0,:);
    temp2 = temp(temp(:,3) <= 0,:);
    polar(1:size(head_direction{iJ}.polar,1),1:4) = NaN;
    for iK = 1:size(temp2,1)
        polar(temp2(iK,4),:) = head_direction{iJ}.polar(temp2(iK,4),:);
    end
    polar = polar(~isnan(polar(:,4)),:);
    lower_left{iJ,1} = polar;
    clear temp temp2 polar;
    
    day{iJ,1} = head_nose_coordinates{iJ}.day;
end
quads{1,1} = upper_left;
quads{1,2} = upper_right;
quads{2,1} = lower_left;
quads{2,2} = lower_right;
clearvars -except quads day;


