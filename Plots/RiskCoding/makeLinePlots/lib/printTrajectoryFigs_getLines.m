function [fh_x,fh_y,fh_z,fl_x,fl_y,fl_z] = printTrajectoryFigs_getLines(factors,idx_high,idx_low)

fac_high = factors(1:3,idx_high,:);
fac_low = factors(1:3,idx_low,:);

fh_x = permute(nanmean(factors(1,idx_high,:)),[3 1 2]);
fh_y = permute(nanmean(factors(2,idx_high,:)),[3 1 2]);
fh_z = permute(nanmean(factors(3,idx_high,:)),[3 1 2]);
fl_x = permute(nanmean(factors(1,idx_low,:)),[3 1 2]);
fl_y = permute(nanmean(factors(2,idx_low,:)),[3 1 2]);
fl_z = permute(nanmean(factors(3,idx_low,:)),[3 1 2]);


end