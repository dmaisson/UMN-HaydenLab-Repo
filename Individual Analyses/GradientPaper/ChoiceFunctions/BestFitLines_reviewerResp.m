function [Line,Error] = BestFitLines_reviewerResp(comp,site,sample1,sample2)

if site == 14
    R = comp.vmPFC;
elseif site == 24
    R = comp.sgACC;
elseif site == 25
    R = comp.dACC;
elseif site == 32
    R = comp.pgACC;
end

%% means of X and Y
xmean = mean(R(:,1));
ymean = mean(R(:,2));

%% slope: m = sum[(x-xmean)(y-ymean)]/sum[(x-xmean)^2]
for iJ = 1:size(R,1)
    diff.x(iJ,1) = R(iJ,1) - xmean;
    diff.y(iJ,1) = R(iJ,2) - ymean;
end
prod = (diff.x) .* (diff.y);
m = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;
% SEM = std/


clear prod diff iJ;

%% Y-intercept: b = ymean - m*xmean
b = ymean - (m * xmean);

%% Line sample values: y = mx + b
Line.samples = [sample1,sample1/2,sample1/3,sample1/4,0,sample2/4,sample2/3,sample2/2,sample2];
for iJ = 1:length(Line.samples)
    Line.func(iJ) = (m * Line.samples(iJ)) + b;
end

%% Error
for iJ = 1:size(R,1)
    E(iJ) = R(iJ,2) - ((m * R(iJ,1)) + b);
end

m = mean(E);

Er = m + (1.66*m);

for iJ = 1:length(Line.samples)
    Error.plus(iJ) = ((m+Er) * Line.samples(iJ)) + b;
end
for iJ = 1:length(Line.samples)
    Error.minus(iJ) = ((m-Er) * Line.samples(iJ)) + b;
end

end
