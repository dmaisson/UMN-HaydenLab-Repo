function [out] = PullEV_shuffle(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for iL = 1:length(data)
    out{iL}(:,1) = data{iL}.zvars(:,3); %EV offer 1
    out{iL}(:,2) = data{iL}.zvars(:,6); %EV offer 2
end
out = out';
end

