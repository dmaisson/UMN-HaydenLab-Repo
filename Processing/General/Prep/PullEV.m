function [out] = PullEV(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for iL = 1:length(data)
    out{iL}(:,1) = data{iL}.vars(:,3); %EV offer 1
    out{iL}(:,2) = data{iL}.vars(:,6); %EV offer 2
end
out = out';
end

