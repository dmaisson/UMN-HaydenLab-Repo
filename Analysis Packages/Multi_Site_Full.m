function [Results] = Multi_Site_Full(Prepped,Raw,iterations)
%% Regression
disp('Running Regression');

R = Wrapper_MultiReg_EVSep(Prepped.data13,155,20);
y = currate_mod(R);
currate = y;
Results.data13 = R;
clear R y
R = Wrapper_MultiReg_EVSep(Prepped.data11,155,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.data11 = R;
clear R y
R = Wrapper_MultiReg_EVSep(Prepped.data14,155,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.data14 = R;
clear R y
R = Wrapper_MultiReg_EVSep_Habiba(Prepped.data25,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.data25 = R;
clear R y
R = Wrapper_MultiReg_EVSep_Zvars(Prepped.data32,155,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.data32 = R;
clear R y
R = Wrapper_MultiReg_EVSep(Prepped.dataPCC,155,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.dataPCC = R;
clear R y
R = Wrapper_MultiReg_EVSep(Prepped.dataVS,155,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.dataVS = R;
clear R y
R = Wrapper_MultiReg_EVSep_Habiba(Prepped.data24,20);
y = currate_mod(R);
currate.R.format = cat(1,currate.R.format,y.R.format);
currate.P.format = cat(1,currate.P.format,y.P.format);
currate.R.pop = cat(1,currate.R.pop,y.R.pop);
currate.P.pop = cat(1,currate.P.pop,y.P.pop);
Results.data24 = R;
clear R y

% Currate Correlations
Results.currate = currate;
clear R y currate %data_myresize
disp('Done and Currated');

%% Shuffle Regressions
disp('Shuffling Regression 13')

data = Prepped.data13;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data13.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data13.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data13.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data13.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data13.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data13.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data13.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data13.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(1,1) = sum(check1)/iterations;
Results.currate.sigformat(1,2) = sum(check2)/iterations;
Results.currate.sigformat(1,3) = sum(check3)/iterations;
Results.currate.sigformat(1,4) = sum(check4)/iterations;
Results.currate.sigpop(1,1) = sum(check5)/iterations;
Results.currate.sigpop(1,2) = sum(check6)/iterations;
Results.currate.sigpop(1,3) = sum(check7)/iterations;
Results.currate.sigpop(1,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression 11')

data = Prepped.data11;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data11.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data11.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data11.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data11.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data11.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data11.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data11.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data11.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(2,1) = sum(check1)/iterations;
Results.currate.sigformat(2,2) = sum(check2)/iterations;
Results.currate.sigformat(2,3) = sum(check3)/iterations;
Results.currate.sigformat(2,4) = sum(check4)/iterations;
Results.currate.sigpop(2,1) = sum(check5)/iterations;
Results.currate.sigpop(2,2) = sum(check6)/iterations;
Results.currate.sigpop(2,3) = sum(check7)/iterations;
Results.currate.sigpop(2,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression 11')

data = Prepped.data14;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data14.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data14.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data14.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data14.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data14.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data14.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data14.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data14.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(3,1) = sum(check1)/iterations;
Results.currate.sigformat(3,2) = sum(check2)/iterations;
Results.currate.sigformat(3,3) = sum(check3)/iterations;
Results.currate.sigformat(3,4) = sum(check4)/iterations;
Results.currate.sigpop(3,1) = sum(check5)/iterations;
Results.currate.sigpop(3,2) = sum(check6)/iterations;
Results.currate.sigpop(3,3) = sum(check7)/iterations;
Results.currate.sigpop(3,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression 25')

data = Prepped.data25;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_Habiba_shuffle(output,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data25.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data25.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data25.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data25.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data25.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data25.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data25.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data25.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(4,1) = sum(check1)/iterations;
Results.currate.sigformat(4,2) = sum(check2)/iterations;
Results.currate.sigformat(4,3) = sum(check3)/iterations;
Results.currate.sigformat(4,4) = sum(check4)/iterations;
Results.currate.sigpop(4,1) = sum(check5)/iterations;
Results.currate.sigpop(4,2) = sum(check6)/iterations;
Results.currate.sigpop(4,3) = sum(check7)/iterations;
Results.currate.sigpop(4,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression 32')

data = Prepped.data32;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data32.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data32.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data32.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data32.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data32.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data32.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data32.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data32.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(5,1) = sum(check1)/iterations;
Results.currate.sigformat(5,2) = sum(check2)/iterations;
Results.currate.sigformat(5,3) = sum(check3)/iterations;
Results.currate.sigformat(5,4) = sum(check4)/iterations;
Results.currate.sigpop(5,1) = sum(check5)/iterations;
Results.currate.sigpop(5,2) = sum(check6)/iterations;
Results.currate.sigpop(5,3) = sum(check7)/iterations;
Results.currate.sigpop(5,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression PCC')

data = Prepped.dataPCC;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.dataPCC.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.dataPCC.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.dataPCC.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.dataPCC.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.dataPCC.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.dataPCC.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.dataPCC.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.dataPCC.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(6,1) = sum(check1)/iterations;
Results.currate.sigformat(6,2) = sum(check2)/iterations;
Results.currate.sigformat(6,3) = sum(check3)/iterations;
Results.currate.sigformat(6,4) = sum(check4)/iterations;
Results.currate.sigpop(6,1) = sum(check5)/iterations;
Results.currate.sigpop(6,2) = sum(check6)/iterations;
Results.currate.sigpop(6,3) = sum(check7)/iterations;
Results.currate.sigpop(6,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression VS')

data = Prepped.dataVS;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_shuffle(output,155,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.dataVS.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.dataVS.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.dataVS.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.dataVS.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.dataVS.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.dataVS.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.dataVS.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.dataVS.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(7,1) = sum(check1)/iterations;
Results.currate.sigformat(7,2) = sum(check2)/iterations;
Results.currate.sigformat(7,3) = sum(check3)/iterations;
Results.currate.sigformat(7,4) = sum(check4)/iterations;
Results.currate.sigpop(7,1) = sum(check5)/iterations;
Results.currate.sigpop(7,2) = sum(check6)/iterations;
Results.currate.sigpop(7,3) = sum(check7)/iterations;
Results.currate.sigpop(7,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;
%%%%%%%
disp('Shuffling Regression 24')

data = Prepped.data24;
parfor iJ = 1:iterations
output = myshuffle(data);
out = MultiReg_Habiba_shuffle(output,20);
regIntegE1format(iJ,:) = out.Integ.E1format(1,:);
regInhibformat(iJ,:) = out.Inhibformat(1,:);
regAlignformat(iJ,:) = out.Alignformat(1,:);
regWMformat(iJ,:) = out.WMformat;
regIntegE1pop(iJ,:) = out.Integ.E1pop(1,:);
regInhibpop(iJ,:) = out.Inhibpop(1,:);
regAlignpop(iJ,:) = out.Alignpop(1,:);
regWMpop(iJ,:) = out.WMpop;
end
check1(1:iterations,1) = NaN;
check2(1:iterations,1) = NaN;
check3(1:iterations,1) = NaN;
check4(1:iterations,1) = NaN;
check5(1:iterations,1) = NaN;
check6(1:iterations,1) = NaN;
check7(1:iterations,1) = NaN;
check8(1:iterations,1) = NaN;
for iJ = 1:iterations
if Results.data24.Integ.E1.r.format > regIntegE1format(iJ,1)
check1(iJ,1) = 1;
else
check1(iJ,1) = 0;
end
if Results.data24.Inhib.EV.r.format < regInhibformat(iJ,1)
check2(iJ,1) = 1;
else
check2(iJ,1) = 0;
end
if Results.data24.Align.r.format > regAlignformat(iJ,1)
check3(iJ,1) = 1;
else
check3(iJ,1) = 0;
end
if Results.data24.WM.r.format > regWMformat(iJ,1)
check4(iJ,1) = 1;
else
check4(iJ,1) = 0;
end

if Results.data24.Integ.E1.r.pop > regIntegE1pop(iJ,1)
check5(iJ,1) = 1;
else
check5(iJ,1) = 0;
end
if Results.data24.Inhib.EV.r.pop > regInhibpop(iJ,1)
check6(iJ,1) = 1;
else
check6(iJ,1) = 0;
end
if Results.data24.Align.r.pop > regAlignpop(iJ,1)
check7(iJ,1) = 1;
else
check7(iJ,1) = 0;
end
if Results.data24.WM.r.pop > regWMpop(iJ,1)
check8(iJ,1) = 1;
else
check8(iJ,1) = 0;
end
end
Results.currate.sigformat(8,1) = sum(check1)/iterations;
Results.currate.sigformat(8,2) = sum(check2)/iterations;
Results.currate.sigformat(8,3) = sum(check3)/iterations;
Results.currate.sigformat(8,4) = sum(check4)/iterations;
Results.currate.sigpop(8,1) = sum(check5)/iterations;
Results.currate.sigpop(8,2) = sum(check6)/iterations;
Results.currate.sigpop(8,3) = sum(check7)/iterations;
Results.currate.sigpop(8,4) = sum(check8)/iterations;
clear out output regIntegE1 regInhib regIntegcross regAlign regWM ...
check1 check2 check3 check4 check5 iJ;

%% Compile Modulation Rates
disp('Modulation Rate 13')
[Mod.data13] = ModRate(Raw.data13,0,1);
disp('Modulation Rate 11')
[Mod.data11] = ModRate(Raw.data11,0,1);
disp('Modulation Rate 14')
[Mod.data14] = ModRate(Raw.data14,0,1);
disp('Modulation Rate 25')
[Mod.data25] = ModRate(Raw.data25,1,1);
disp('Modulation Rate 32')
[Mod.data32] = ModRate(Raw.data32,0,1);
disp('Modulation Rate PCC')
[Mod.dataPCC] = ModRate(Raw.dataPCC,0,1);
disp('Modulation Rate VS')
[Mod.dataVS] = ModRate(Raw.dataVS,0,1);
disp('Modulation Rate 24')
[Mod.data24] = ModRate(Raw.data24,1,1);
disp('Compile')
Mod.compile = compileMods(Mod);
disp('Done')

%% Modulation Shuffle
disp('Shuffled Modulation 13')
data = Prepped.data13;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(1,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(1,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(1,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(1,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(1,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(1,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(1,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(1,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation 11')
data = Prepped.data11;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(2,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(2,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(2,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(2,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(2,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(2,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(2,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(2,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation 14')
data = Prepped.data14;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(3,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(3,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(3,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(3,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(3,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(3,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(3,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(3,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation 25')
data = Prepped.data25;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(4,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(4,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(4,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(4,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(4,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(4,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(4,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(4,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation 32')
data = Prepped.data32;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(5,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(5,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(5,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(5,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(5,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(5,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(5,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(5,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation PCC')
data = Prepped.dataPCC;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(6,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(6,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(6,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(6,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(6,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(6,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(6,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(6,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation VS')
data = Prepped.dataVS;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(7,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(7,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(7,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(7,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(7,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(7,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(7,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(7,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
%%%%%%%
disp('Shuffled Modulation 24')
data = Prepped.data24;
parfor iJ = 1:iterations
    output = myshuffle(data);
    out = ModRate_shuffle(output,5);
    Choice(iJ,:) = out.Choice(1,:);
    ChoiceVal(iJ,:) = out.ChoiceVal(1,:);
    UnChoiceVal(iJ,:) = out.UnChoiceVal(1,:);
    ChoiceSide(iJ,:) = out.ChoiceSide(1,:);
end
Results.shufflemod.Choice(8,:) = mean(Choice,1);
Results.shufflemod.ChoiceEr(8,:) = std(Choice(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceVal(8,:) = mean(ChoiceVal,1);
Results.shufflemod.ChoiceValEr(8,:) = std(ChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.UnChoiceVal(8,:) = mean(UnChoiceVal,1);
Results.shufflemod.UnChoiceValEr(8,:) = std(UnChoiceVal(:,1))/sqrt(iterations);
Results.shufflemod.ChoiceSide(8,:) = mean(ChoiceSide,1);
Results.shufflemod.ChoiceSideEr(8,:) = std(ChoiceSide(:,1))/sqrt(iterations);
clear iJ output out Choice ChoiceVal UnChoiceVal ChoiceSide data;
disp('Done')
shufflemod.shufflemod.choiceavg(:,:) = mean(shufflemod.shufflemod.Choice,1);
shufflemod.shufflemod.choiceavg(2,:) = mean(shufflemod.shufflemod.ChoiceVal,1);
shufflemod.shufflemod.choiceavg(3,:) = mean(shufflemod.shufflemod.UnChoiceVal,1);
shufflemod.shufflemod.choiceavg(4,:) = mean(shufflemod.shufflemod.ChoiceSide,1);
shufflemod.shufflemod.avg = mean(shufflemod.shufflemod.choiceavg,1);
shufflemod.shufflemod.shuffled = imresize(shufflemod.shufflemod.shuffleavg,4);
shufflemod.shufflemod.shuffle(2:4,:) = [];

% Test shape against shuffle
[~,Results.KS.p(1,:)] = test_ks(Mod.data13,Results);
[~,Results.KS.p(2,:)] = test_ks(Mod.data11,Results);
[~,Results.KS.p(3,:)] = test_ks(Mod.data14,Results);
[~,Results.KS.p(4,:)] = test_ks(Mod.data25,Results);
[~,Results.KS.p(5,:)] = test_ks(Mod.data32,Results);
[~,Results.KS.p(6,:)] = test_ks(Mod.dataPCC,Results);
[~,Results.KS.p(7,:)] = test_ks(Mod.dataVS,Results);
[~,Results.KS.p(8,:)] = test_ks(Mod.data24,Results);

%% Timescale
Results.data13.latency = Latency_Murray_SmDelta(Raw.data13,720);
Results.data11.latency = Latency_Murray_SmDelta(Raw.data11,720);
Results.data14.latency = Latency_Murray_SmDelta(Raw.data14,720);
Results.data25.latency = Latency_Murray_SmDelta(Raw.data25,720);
Results.data32.latency = Latency_Murray_SmDelta(Raw.data32,720);
Results.dataPCC.latency = Latency_Murray_SmDelta(Raw.dataPCC,720);
Results.dataVS.latency = Latency_Murray_SmDelta(Raw.dataVS,720);
Results.data24.latency = Latency_Murray_SmDelta(Raw.data24,720);

Results.Murray(1,1) = Results.data13.latency.tau;
Results.Murray(2,1) = Results.data11.latency.tau;
Results.Murray(3,1) = Results.data14.latency.tau;
Results.Murray(4,1) = Results.data25.latency.tau;
Results.Murray(5,1) = Results.data32.latency.tau;
Results.Murray(6,1) = Results.dataPCC.latency.tau;
Results.Murray(7,1) = Results.dataVS.latency.tau;
Results.Murray(8,1) = Results.data24.latency.tau;
clear Raw;
save ('Regs_Timescales.mat','-v7.3');

%% Linear classifier for pseudo-population on Choice
disp('Classifier 14')
[classifier.Choice.maccuracy(1,:),classifier.Choice.error(1,:)] = Classification_down(Prepped.data14,0,iterations,7);
disp('Classifier 25')
[classifier.Choice.maccuracy(2,:),classifier.Choice.error(2,:)] = Classification_down(Prepped.data25,1,iterations,1);
disp('Classifier 32')
[classifier.Choice.maccuracy(3,:),classifier.Choice.error(3,:)] = Classification_down(Prepped.data32,0,iterations,1);
disp('Classifier 24')
[classifier.Choice.maccuracy(4,:),classifier.Choice.error(4,:)] = Classification_down(Prepped.data24,1,iterations,1);
disp('Classifier Shuffle')
classifier.Choice.shuffled = mean(classifier.Choice.maccuracy(:,5));

%% Latency
latency(1,:) = FR_latency2peak(Prepped.data14,0);
latency(2,:) = FR_latency2peak(Prepped.data25,1);
latency(3,:) = FR_latency2peak(Prepped.data32,0);
latency(4,:) = FR_latency2peak(Prepped.data24,1);

[~,tbl] = anova2(latency,1);

end
