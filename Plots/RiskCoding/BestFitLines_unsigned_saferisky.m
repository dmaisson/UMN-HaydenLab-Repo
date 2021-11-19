function [Line] = BestFitLines_unsigned_saferisky(x,y,sample1,sample2)


%% means of X and Y
xmean = mean(abs(x));
ymean = mean(abs(y));

%% slope: m = sum[(x-xmean)(y-ymean)]/sum[(x-xmean)^2]
for iJ = 1:size(x,1)
    diff.x(iJ,1) = abs(x(iJ,1)) - xmean;
    diff.y(iJ,1) = abs(y(iJ,1)) - ymean;
end
prod = (diff.x) .* (diff.y);
m = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;

%% Y-intercept: b = ymean - m*xmean
b = ymean - (m * xmean);

%% Line sample values: y = mx + b
Line.samples = sample1:0.1:sample2;
for iJ = 1:size(Line.samples,2)
    Line.output(iJ) = (m * Line.samples(iJ)) + b;
end

end
