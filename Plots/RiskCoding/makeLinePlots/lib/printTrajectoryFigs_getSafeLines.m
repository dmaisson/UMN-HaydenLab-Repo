function [fs_x,fs_y,fs_z] = printTrajectoryFigs_getSafeLines(factors,idx_safe)

fac_safe = factors(1:3,idx_safe,:);

fs_x = permute(nanmean(factors(1,idx_safe,:)),[3 1 2]);
fs_y = permute(nanmean(factors(2,idx_safe,:)),[3 1 2]);
fs_z = permute(nanmean(factors(3,idx_safe,:)),[3 1 2]);



end