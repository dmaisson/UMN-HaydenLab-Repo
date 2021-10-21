function [out1,out2,out3] = FR_OfferGrouping(in,n,col,epoch,bin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if epoch == 1
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
    out1(iL,1:size(data,2)) = NaN;
    out2(iL,1:size(data,2)) = NaN;
    out3(iL,1:size(data,2)) = NaN;
    if in{n}.vars(iL,col) == 1
        out1(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,col) == 2
        out2(iL,:) = data(iL,:);
    elseif in{n}.vars(iL,col) == 3
        out3(iL,:) = data(iL,:);
    end
end
end

end

