function [out] = PullSide(data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for iL = 1:length(data)
    out{iL}(:,1) = data{iL}.vars(:,7); %Side of offer 1
    out{iL}(:,2) = data{iL}.vars(:,8); %Side of chosen
end
out = out';
end

