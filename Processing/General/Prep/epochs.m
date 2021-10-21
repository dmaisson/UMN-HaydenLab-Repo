function [epoch2,epoch3] = epochs(epoch1,ms)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
if ms == 20
    epoch2 = epoch1+50;
    epoch3 = epoch1+115;
elseif ms == 10
    epoch2 = epoch1+100;
    epoch3 = epoch1+200;
elseif ms == 1
    epoch2 = epoch1+1000;
    epoch3 = epoch1+2000;
end

end

