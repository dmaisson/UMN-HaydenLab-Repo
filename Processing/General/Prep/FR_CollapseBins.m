function [y] = FR_CollapseBins(x,ms)
%UNTITLED2 Summary of this function goes here
%   X is the data to be down-sampled
%   ms is the factor by which to down sample

c = 1;

for iL = 1:size(x,1)
    for iK = 1:(size(x,2)/ms)
        if c == 1
            y(iL,iK) = sum(x(iL,c:c+(ms-1)));
            c = c+(ms-1);
        elseif c ~= 1
            y(iL,iK) = sum(x(iL,c+1:c+(ms)));
            c = c+ms;
        end
    end
    c = 1;
end

end

