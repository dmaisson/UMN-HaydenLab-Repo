function [y] = spikes_6s(x,start,ms)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if ms == 20
    y = x(:,(start-50):499);
elseif ms == 10
    y = x(:,(start-100):999);
elseif ms == 1
    y = x(:,(start-1000):end);
end

end

