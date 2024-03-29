for iA = 1:numel(OFC)
    tic
    disp(['original: ', num2str(iA)])
    spike_day = OFC{iA}.day;
    for iB = 1:numel(tracking_data)
        tracking_day = tracking_data(iB).date;
        if sum((tracking_day == spike_day)) == 10
            idx = iB;
        end
    end
    tracking = tracking_data(idx);
    space_grid{iA,1} = space_grid_tuning(OFC{iA},tracking,7.5,1);
    clear tracking spike_day tracking_day idx
    toc
end

%% significance testing
bootstrap = 500;

for iB = 1:numel(OFC)
    spike_day = OFC{iB}.day;
    for iC = 1:numel(tracking_data)
        tracking_day = tracking_data(iC).date;
        if sum((tracking_day == spike_day)) == 10
            idx = iC;
        end
    end
    tracking_day = tracking_data(idx).date;
    tracking = tracking_data(idx);
    set = OFC{iB};
    for iA = 1:bootstrap
        disp(['bootstrapping; ', 'cell: ', num2str(iB), '; ', 'boostrap: ', num2str(iA)]);
        tic
%         fwdbkwd = [-1 1];
%         x = randi(2);
%         shift_frames = randi([1500,4500])*fwdbkwd(x);
%         set.resSeries = circshift(set.resSeries,shift_frames);
%         x = randi(2);
%         shift_frames = randi([1500,4500])*fwdbkwd(x);
%         tracking.com = circshift(tracking.com,shift_frames,1);
        shift = randperm(size(set.resSeries,2));
        set.resSeries(1,:) = set.resSeries(1,shift(1,:));
        time_shift_control = space_grid_tuning(set,tracking,7.5,0);
        shifted_grid_score(iB,iA) = time_shift_control.grid_score;
        shifted_SI(iB,iA) = time_shift_control.spatial_information;
        clear shift_frames time_shift_control
        toc
    end
    clear tracking spike_day tracking_day idx set
    x = sort(shifted_grid_score(iB,:));
    y = space_grid{iB}.grid_score;
    z = find(y>x);
    space_grid{iB,1}.grid_score_p = 1-(size(z,2)/bootstrap);
    clear x y z
    x = sort(shifted_SI(iB,:));
    y = space_grid{iB}.spatial_information;
    z = find(y>x);
    space_grid{iB,1}.SI_p = 1-(size(z,2)/bootstrap);
    clear x y z
    clear shifted_grid_score shifted_SI
%     save('space_grid_2.mat','space_grid','-v7.3');
end

%%
for iA = 1:size(space_grid,1)
    grid_p(iA,1) = space_grid{iA}.grid_score_p;
    SI_p(iA,1) = space_grid{iA}.SI_p;
    grid_score(iA,1) = space_grid{iA}.grid_score;
end

sig_grid = find(grid_score>0);
sig_SI = find(SI_p<0.05);
