function [y] = TrialSpikeIsolation(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

y=[];
for iL = 1:size(x,1)
    if ~isnan(x(iL,1)) %if cell 1:length in column1 is NOT NaN
        if isempty(y) %if the indexing var is empty
            y(1,:)=x(iL,:); %add the current row to the indexing var
        else %if the indexing var has already been added to
            y(size(y,1)+1,:)=x(iL,:); %add the current row to the next row of the indexing var
        end
    end
end

end

