function [Line,Error] = BestFitLines(Results,site,sample1,sample2)

if site == 11
    R = Results.data11;
elseif site == 13
    R = Results.data13;
elseif site == 14
    R = Results.data14;
elseif site == 24
    R = Results.data24;
elseif site == 25
    R = Results.data25;
elseif site == 32
    R = Results.data32;
elseif site == 1
    R = Results.dataPCC;
elseif site == 2
    R = Results.dataVS;
elseif site == 3
    R = Results.dataRSC;
end

%% means of X and Y
xmean.Integ = mean(R.Epoch1.b.prob1);
ymean.Integ = mean(R.Epoch1.b.size1);

xmean.Inhib = mean(R.Epoch2.b.EV1);
ymean.Inhib = mean(R.Epoch2.b.EV2);

xmean.Align = mean(R.Epoch1.b.EV1);
ymean.Align = mean(R.Epoch2.b.EV2);

xmean.WM = mean(R.Epoch1.b.EV1);
ymean.WM = mean(R.Epoch2.b.EV1);

%% slope: m = sum[(x-xmean)(y-ymean)]/sum[(x-xmean)^2]
for iJ = 1:size(R.Epoch1.b.prob1,1)
    diff.x(iJ,1) = R.Epoch1.b.prob1(iJ,1) - xmean.Integ;
    diff.y(iJ,1) = R.Epoch1.b.size1(iJ,1) - ymean.Integ;
end
prod = (diff.x) .* (diff.y);
m.Integ = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;
% SEM = std/

for iJ = 1:size(R.Epoch2.b.EV1,1)
    diff.x(iJ,1) = R.Epoch2.b.EV1(iJ,1) - xmean.Inhib;
    diff.y(iJ,1) = R.Epoch2.b.EV2(iJ,1) - ymean.Inhib;
end
prod = (diff.x) .* (diff.y);
m.Inhib = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;

for iJ = 1:size(R.Epoch1.b.EV1,1)
    diff.x(iJ,1) = R.Epoch1.b.EV1(iJ,1) - xmean.Align;
    diff.y(iJ,1) = R.Epoch2.b.EV2(iJ,1) - ymean.Align;
end
prod = (diff.x) .* (diff.y);
m.Align = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;

for iJ = 1:size(R.Epoch1.b.EV1,1)
    diff.x(iJ,1) = R.Epoch1.b.EV1(iJ,1) - xmean.WM;
    diff.y(iJ,1) = R.Epoch2.b.EV1(iJ,1) - ymean.WM;
end
prod = (diff.x) .* (diff.y);
m.WM = sum(prod) / (sum(diff.x .^ 2));
clear prod diff iJ;

%% Y-intercept: b = ymean - m*xmean
b.Integ = ymean.Integ - (m.Integ * xmean.Integ);
b.Inhib = ymean.Inhib - (m.Inhib * xmean.Inhib);
b.Align = ymean.Align - (m.Align * xmean.Align);
b.WM = ymean.WM - (m.WM * xmean.WM);

%% Line sample values: y = mx + b
Line.samples = [sample1,sample1/2,sample1/3,sample1/4,0,sample2/4,sample2/3,sample2/2,sample2];
for iJ = 1:length(Line.samples)
    Line.Integ(iJ) = (m.Integ * Line.samples(iJ)) + b.Integ;
    Line.Inhib(iJ) = (m.Inhib * Line.samples(iJ)) + b.Inhib;
    Line.Align(iJ) = (m.Align * Line.samples(iJ)) + b.Align;
    Line.WM(iJ) = (m.WM * Line.samples(iJ)) + b.WM;
end

%% Error
for iJ = 1:length(R.Epoch1.b.prob1)
    EInteg(iJ) = R.Epoch1.b.prob1(iJ) - ((m.Integ * R.Epoch1.b.size1(iJ)) + b.Integ);
    EInhib(iJ) = R.Epoch2.b.EV2(iJ) - ((m.Inhib * R.Epoch2.b.EV1(iJ)) + b.Inhib);
    EAlign(iJ) = R.Epoch2.b.EV2(iJ) - ((m.Align * R.Epoch1.b.EV1(iJ)) + b.Align);
    EWM(iJ) = R.Epoch2.b.EV1(iJ) - ((m.WM * R.Epoch1.b.EV1(iJ)) + b.WM);
end

mInteg = mean(EInteg);
mInhib = mean(EInhib);
mAlign = mean(EAlign);
mWM = mean(EWM);

ErInteg = m.Integ + (1.66*mInteg);
ErInhib = m.Inhib + (1.66*mInhib);
ErAlign = m.Align + (1.66*mAlign);
ErWM = m.WM + (1.66*mWM);

for iJ = 1:length(Line.samples)
    Error.plus.Integ(iJ) = ((m.Integ+ErInteg) * Line.samples(iJ)) + b.Integ;
    Error.plus.Inhib(iJ) = ((m.Inhib+ErInhib) * Line.samples(iJ)) + b.Inhib;
    Error.plus.Align(iJ) = ((m.Align+ErAlign) * Line.samples(iJ)) + b.Align;
    Error.plus.WM(iJ) = ((m.WM+ErWM) * Line.samples(iJ)) + b.WM;
end
for iJ = 1:length(Line.samples)
    Error.minus.Integ(iJ) = ((m.Integ-ErInteg) * Line.samples(iJ)) + b.Integ;
    Error.minus.Inhib(iJ) = ((m.Inhib-ErInhib) * Line.samples(iJ)) + b.Inhib;
    Error.minus.Align(iJ) = ((m.Align-ErAlign) * Line.samples(iJ)) + b.Align;
    Error.minus.WM(iJ) = ((m.WM-ErWM) * Line.samples(iJ)) + b.WM;
end

end
