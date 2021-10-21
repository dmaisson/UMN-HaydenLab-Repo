function [head_direction,degree_times] = Prep_headdirection(input,deg_band)

degrees = -180:deg_band:180;
for iI = 1:size(input,1)
    orig_x = input{iI}.nose(:,1);
    orig_y = input{iI}.nose(:,3);
    orig_z = input{iI}.nose(:,2);
    trans_x = input{iI}.head(:,1);
    trans_y = input{iI}.head(:,3);
    trans_z = input{iI}.head(:,2);
    new_x = orig_x - trans_x;
    new_y = orig_y - trans_y;
    new_z = orig_z - trans_z;
    head_direction{iI,1}.day = input{iI}.day;
    head_direction{iI,1}.cart(:,1) = new_x;
    head_direction{iI,1}.cart(:,2) = new_y;
    head_direction{iI,1}.cart(:,3) = new_z;
    [head_direction{iI,1}.polar(:,1),head_direction{iI,1}.polar(:,2),...
        head_direction{iI,1}.polar(:,3)] = cart2pol(new_x,new_y,new_z);
    x = rad2deg(head_direction{iI}.polar(:,1));
    degree_times{iI,1} = cell(size(degrees,2)-1,1);
    for iJ = 1:size(degrees,2)-1
        degree_times{iI,1}{iJ,1} = find(x > degrees(1,iJ) & x <= degrees(1,iJ+1));
    end
end