function [Safe,Win,Loss] = FR_OutcomeGrouping(in,n,bin)
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
    Safe(iL,1:size(data,2)) = NaN;
    Win(iL,1:size(data,2)) = NaN;
    Loss(iL,1:size(data,2)) = NaN;
    if in{n}.vars(iL,10) == 1 && ((in{n}.vars(iL,1) == 1) || (in{n}.vars(iL,4) == 1))
        Safe(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,10) == 1 && ((in{n}.vars(iL,1) ~= 1) && (in{n}.vars(iL,4) ~= 1))
        Win(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,10) > 1
        Win(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,10) == 0
        Loss(iL,:) = data(iL,:);
    end
end
end