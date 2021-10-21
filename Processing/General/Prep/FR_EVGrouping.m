function [high,equal,low] = FR_EVGrouping(in,n,bin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if bin == 20
data = in{n}.psth(:,200:499);
elseif bin == 10
data = in{n}.psth(:,400:999);
elseif bin == 1
data = in{n}.psth(:,1:end);
end

% Group FR from above range by trials with High, Med, and Low offers
    % Offer1 rwd size is column2
for iL = 1:length(in{n}.vars)
    high(iL,1:size(data,2)) = NaN;
    equal(iL,1:size(data,2)) = NaN;
    low(iL,1:size(data,2)) = NaN;
    if in{n}.vars(iL,3) > in{n}.vars(iL,6)
        high(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,3) == in{n}.vars(iL,6)
        equal(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,3) < in{n}.vars(iL,6)
        low(iL,:) = data(iL,:);
    end
end
end

