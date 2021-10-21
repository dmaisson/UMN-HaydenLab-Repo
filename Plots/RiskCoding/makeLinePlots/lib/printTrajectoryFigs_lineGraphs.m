get_colors; close all

plotHigh = plotOpt.plotHigh; plotLow = plotOpt.plotLow; plotSafe = plotOpt.plotSafe;
trial_subsample_n = 10; % the number of lines to plot for each condition
trial_subsample_size = 100; % the number of trials to average over (randomly selected) for each line
[idx_nonSafe,idx_safe] = getSafeTrials(allTrialdata);

% NOTE: the following are only called "High" and "Low" for convenience with
% pre-existing code. They are all just safe offers.
idx_safeHigh = idx_safe(1:round(length(idx_safe)/2)); idx_safeLow = idx_safe(round(length(idx_safe)/2)+1:end);

fh_ss = randi(length(idx_high),trial_subsample_n,trial_subsample_size);
fl_ss = randi(length(idx_low),trial_subsample_n,trial_subsample_size);
fs_ss = randi(length(idx_safe),trial_subsample_n,trial_subsample_size);

for k = 1:trial_subsample_n+1
    
    if k == 1
        ixh = idx_high; ixl = idx_low; ixs = idx_safe; Lw = 6; La = 1; 
    else
        ixh = idx_high(fh_ss(k-1,:)); ixl = idx_low(fl_ss(k-1,:)); ixs = idx_safe(fs_ss(k-1,:)); Lw = 2; La = 0.25;
    end
    [fh_x,fh_y,fh_z,fl_x,fl_y,fl_z] = printTrajectoryFigs_getLines(factors_noSafe,ixh,ixl);
    [fs_x,fs_y,fs_z] = printTrajectoryFigs_getSafeLines(allFactors,ixs); % note that "opt.factors" haven't been pruned, hence why used here
    
    if k == 1, stLine = [fh_x(1) fh_y(1) fh_z(1)]; end
    [fh_x,fh_y,fh_z] = printTrajectoryFigs_lineOffset(fh_x,fh_y,fh_z,stLine);
    [fl_x,fl_y,fl_z] = printTrajectoryFigs_lineOffset(fl_x,fl_y,fl_z,stLine);
    [fs_x,fs_y,fs_z] = printTrajectoryFigs_lineOffset(fs_x,fs_y,fs_z,stLine);
    hold on;
    if plotHigh
        patchline(fh_x,fh_y,fh_z,'linestyle','-','edgecolor',color_high,'linewidth',Lw,'edgealpha',La);
    end
    hold on;
    if plotLow
        patchline(fl_x,fl_y,fl_z,'linestyle','-','edgecolor',color_low,'linewidth',Lw,'edgealpha',La);
    end
    hold on;
    if plotSafe
        patchline(fs_x,fs_y,fs_z,'linestyle','-','edgecolor',color_safe,'linewidth',Lw,'edgealpha',La);
    end
end

scatter3(fh_x(1),fh_y(1),fh_z(1),150,'k','filled')

% here is where you set where the "shadows" get plotted;
if strcmp(monkey,'Vader')
    factors(3,:,:) = -0.4;
    zOffset = -0.2;
elseif strcmp(monkey,'Pumbaa')
    factors(3,:,:) = -0.2;
    zOffset = 1.5;
end
hold on;

for k = 1:trial_subsample_n+1
    
    if k == 1
        ixh = idx_high; ixl = idx_low; Lw = 6; La = 0.5; 
    else
        ixh = idx_high(fh_ss(k-1,:)); ixl = idx_low(fl_ss(k-1,:)); Lw = 2; La = 0.15;
    end
    [fh_x,fh_y,fh_z,fl_x,fl_y,fl_z] = Neural_printTrajectoryFigs_getLines(factors_noSafe,ixh,ixl);
    if k == 1, stLine = [fh_x(1) fh_y(1) fh_z(1)]; end
    [fh_x,fh_y,fh_z] = Neural_printTrajectoryFigs_lineOffset(fh_x,fh_y,fh_z,stLine);
    [fl_x,fl_y,fl_z] = Neural_printTrajectoryFigs_lineOffset(fl_x,fl_y,fl_z,stLine);
    [fs_x,fs_y,fs_z] = Neural_printTrajectoryFigs_lineOffset(fs_x,fs_y,fs_z,stLine);
    hold on;
    if plotHigh
        patchline(fh_x,fh_y,(zOffset * ones(length(fh_y),1)),'linestyle','-','edgecolor',colors.gray2,'linewidth',Lw,'edgealpha',La);
    end
    hold on;
    if plotLow
        patchline(fl_x,fl_y,(zOffset * ones(length(fh_y),1)),'linestyle','-','edgecolor',colors.gray2,'linewidth',Lw,'edgealpha',La);
    end
    hold on;
    if plotSafe
        patchline(fs_x,fs_y,(zOffset * ones(length(fh_y),1)),'linestyle','-','edgecolor',colors.gray2,'linewidth',Lw,'edgealpha',La);
    end

end

xlabel('factor 1'); ylabel('factor 2'); zlabel('factor 3'); grid('on');

% you can hardcode view options here
if strcmp(monkey,'Pumbaa')
    view(-158,34);
elseif strcmp(monkey,'Vader')
    view(-101,20);
end
