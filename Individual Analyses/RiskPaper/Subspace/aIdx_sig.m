function [mu,sd,p] = aIdx_sig(in)

mat1 = in.safemat;
mat2 = in.lowmat;
mat3 = in.highmat;

sel_dim = 10;

for iJ = 1:1000
    aIdx(iJ,1) = alignmentIdx_columnboot(mat1,mat2,mat3,sel_dim);
    aIdx(iJ,2) = alignmentIdx_rowboot(mat1,mat2,mat3,sel_dim);
end

mu(1,1) = nanmean(aIdx(:,1));
sd(1,1) = nanstd (aIdx(:,1));
mu(1,2) = nanmean(aIdx(:,2));
sd(1,2) = nanstd (aIdx(:,2));

aIdx_floor = sort(aIdx(:,1));
y = find(in.aIdx(1,1) < aIdx_floor);
if isempty(y)
    p.floor.low = 1;
else
    p.floor.low = y(1,1)/1000;
end
clear y;

y = find(in.aIdx(1,2) < aIdx_floor);
if isempty(y)
    p.floor.high = 1;
else
    p.floor.high = y(1,1)/1000;
end
clear y;

aIdx_ceil = sort(aIdx(:,2));
y = find(in.aIdx(1,1) < aIdx_ceil);
if isempty(y)
    p.ceil.low = 1;
else
    p.ceil.low = y(1,1)/1000;
end
clear y;

y = find(in.aIdx(1,2) < aIdx_ceil);
if isempty(y)
    p.ceil.high = 1;
else
    p.ceil.high = y(1,1)/1000;
end
clear y;

end