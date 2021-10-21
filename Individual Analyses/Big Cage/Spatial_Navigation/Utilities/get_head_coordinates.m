cd '/mnt/scratch/DM_spatial/process_notransform/Done_json'
proc = dir('yo*');
head_nose_coordinates = cell(size(proc,1),1);
head_direction = cell(size(proc,1),1);
for iA = 1:size(head_nose_coordinates,1)
%     % get the name of the file to open
%     temp2 = strsplit(proc(iA).name, 'yo_');
%     temp3 = strsplit(temp2{2}, '_01');
%     
%     % get the date of the recorded session
%     day = temp3{1};
%     
%     % load the capture data
%     load(proc(iA).name)
%     
%     % pull out the nose and head coordinates
%     nose = data_proc.data(:,1:3);
%     head = data_proc.data(:,4:6);
%     order = 'x,z,y';
%     
%     % store the data in a coordinates structure
%     head_nose_coordinates{iA,1}.day = day;
%     head_nose_coordinates{iA,1}.order = order;
%     head_nose_coordinates{iA,1}.nose = nose;
%     head_nose_coordinates{iA,1}.head = head;
    
    x_head = head_nose_coordinates{iA,1}.head(:,1);
    y_head = head_nose_coordinates{iA,1}.head(:,3);
    z_head = head_nose_coordinates{iA,1}.head(:,2);
    x_nose = head_nose_coordinates{iA,1}.nose(:,1);
    y_nose = head_nose_coordinates{iA,1}.nose(:,3);
    z_nose = head_nose_coordinates{iA,1}.nose(:,2);
    
    % center nose coordinates to the head coordinates
    new_x_nose = x_nose - x_head;
    new_y_nose = y_nose - y_head;
    new_z_nose = z_nose - z_head;
    
    % convert centered nose coordinates into cylindrical polar coordinates
    [theta_nose,rho_nose,z_nose] = cart2pol(new_x_nose,new_y_nose,new_z_nose);
        
    % determine the vertical hypotenuse of the nose
    vert_hyp_nose = sqrt(rho_nose.^2 + z_nose.^2);
        
    % compute the pitch of the nose (the angle between center and nose
    % elevation
    vert_cos = rho_nose./vert_hyp_nose;
    vert_ang_nose = acos(vert_cos);
    
    % store the head direction data
    head_direction{iA,1}.yaw = theta_nose;
    head_direction{iA,1}.yaw_radius = rho_nose;
    head_direction{iA,1}.pitch_radius = vert_hyp_nose;
    head_direction{iA,1}.pitch = vert_ang_nose;
    head_direction{iA,1}.day = head_nose_coordinates{iA,1}.day;
    
    clearvars -except head_nose_coordinates head_direction iA proc
end
clear iA