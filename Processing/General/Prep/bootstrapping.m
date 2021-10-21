function [output] = bootstrapping(input,n)
%% DOWNSAMPLE - random withOUT replication

s = randperm(length(input),n);
output(1:n,1:size(input,2)) = NaN;

for iJ = 1:n
    output(iJ,:) = input(s(iJ),:);
end

end