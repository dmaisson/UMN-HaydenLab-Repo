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
    out{iA,1} = space_grid_tuning(OFC{iA},tracking,10);
    clear tracking spike_day tracking_day idx
end

%%
pick = randperm(size(out,1));
figure;
for iA = 1:4
    subplot (2,2,iA)
    pcolor(out{pick(iA)}.space_autocorr_binned); caxis([-1 1])
    colormap jet
    shading interp
    colorbar
end