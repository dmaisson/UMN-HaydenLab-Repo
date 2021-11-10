for iA = 1:numel(OFC)
    spike_day = OFC{iA}.day;
    for iB = 1:numel(tracking_data)
        tracking_day = tracking_data(iB).date;
        if sum((tracking_day == spike_day)) == 10
            idx = iB;
        end
    end
    tracking_day = tracking_data(idx).date;
    tracking = tracking_data(idx);
    space_grid{iA,1} = space_grid_tuning(OFC{iA},tracking,10);
    clear tracking spike_day tracking_day idx
end

%% significance testing
bootstrap = 500;
for iA = 1:bootstrap
    for iB = 1:numel(OFC)
        spike_day = OFC{iB}.day;
        for iC = 1:numel(tracking_data)
            tracking_day = tracking_data(iC).date;
            if sum((tracking_day == spike_day)) == 10
                idx = iC;
            end
        end
        shift_frames = randi([300,900]);
        set = OFC{iB};
        set.resSeries = circshift(set.resSeries,shift_frames);
        tracking_day = tracking_data(idx).date;
        tracking = tracking_data(idx);
        time_shift_control = space_grid_tuning(set,tracking,10);
        shifted_grid_score(iB,iA) = time_shift_control.grid_score;
        shifted_SI(iB,iA) = time_shift_control.spatial_information;
        clear tracking spike_day tracking_day idx time_shift_control set shift_frames
    end
end

for iA = 1:size(OFC,1)
    x = sort(shifted_grid_score(iA,:));
    y = space_grid{iA}.grid_score;
    z = find(y>x);
    space_grid{iA,1}.grid_score_p = 1-(size(z,2)/bootstrap);
    clear x y z
    x = sort(shifted_SI(iA,:));
    y = space_grid{iA}.spatial_information;
    z = find(y>x);
    space_grid{iA,1}.SI_p = 1-(size(z,2)/bootstrap);
    clear x y z
end
clear shifted_grid_score shifted_SI

%%
pick = randperm(size(grid_idx,1));
figure;
for iA = 1:4
    subplot (2,2,iA)
    pcolor(out{grid_idx(pick(iA))}.autocorrelogram); caxis([-1 1])
    colormap jet
    shading interp
    colorbar
end
