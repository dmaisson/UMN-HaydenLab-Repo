function [out] = PullSide_shuffle(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for iL = 1:length(data)
    out{iL}(:,1) = data{iL}.zvars(:,7); %Side of offer 1
    out{iL}(:,2) = data{iL}.zvars(:,8); %Side of chosen
end
out = out';
end

