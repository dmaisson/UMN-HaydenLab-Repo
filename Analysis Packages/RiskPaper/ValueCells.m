function R = ValueCells(subject1,subject2,sv,range)
%% separate trials by risk-type and calculate mFRs
separated_trials.sub1 = mFR_safeVrisk_SV(subject1,range);
separated_trials.sub2 = mFR_safeVrisk_SV(subject2,range);

%% collapse across subs - keeping eq.risky together, and rest together
n1 = length(subject1);
n2 = length(subject2);
safe.Ep1 = cat(1,separated_trials.sub1.safe.Ep1,separated_trials.sub2.safe.Ep1);
safe.Ep2 = cat(1,separated_trials.sub1.safe.Ep2,separated_trials.sub2.safe.Ep2);
n3 = n1+n2;
mFR.safe = cat(1,separated_trials.sub1.mFR.safe,separated_trials.sub2.mFR.safe);
sem.safe = cat(1,separated_trials.sub1.sem.safe,separated_trials.sub2.sem.safe);
mFR.low = cat(1,separated_trials.sub1.mFR.low,separated_trials.sub2.mFR.low);
sem.low = cat(1,separated_trials.sub1.sem.low,separated_trials.sub2.sem.low);
mFR.high = cat(1,separated_trials.sub1.mFR.high,separated_trials.sub2.mFR.high);
sem.high = cat(1,separated_trials.sub1.sem.high,separated_trials.sub2.sem.high);
for iJ = 1:length(separated_trials.sub1.test)
    test{iJ,1}.low = cat(1,separated_trials.sub1.test{iJ}.low,separated_trials.sub2.test{iJ}.low);
    test{iJ,1}.high = cat(1,separated_trials.sub1.test{iJ}.high,separated_trials.sub2.test{iJ}.high);
    low.Ep1{iJ,1}.cell = cat(1,separated_trials.sub1.low.Ep1{iJ}.cell,separated_trials.sub2.low.Ep1{iJ}.cell);
    low.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.low.Ep2{iJ}.cell,separated_trials.sub2.low.Ep2{iJ}.cell);
    high.Ep1{iJ,1}.cell = cat(1,separated_trials.sub1.high.Ep1{iJ}.cell,separated_trials.sub2.high.Ep1{iJ}.cell);
    high.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.high.Ep2{iJ}.cell,separated_trials.sub2.high.Ep2{iJ}.cell);
end

probs = range:range:1;

% subject1
svlow = interp1(probs,probs,sv.subject1.low,'nearest');
svhigh = interp1(probs,probs,sv.subject1.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(svlow == probs);
eqlow.Ep1 = separated_trials.sub1.low.Ep1{x}.cell;
eqlow.Ep2 = separated_trials.sub1.low.Ep2{x}.cell;
x = find(svhigh == probs);
eqhigh.Ep1 = separated_trials.sub1.high.Ep1{x}.cell;
eqhigh.Ep2 = separated_trials.sub1.high.Ep2{x}.cell;

% subject2
svlow = interp1(probs,probs,sv.subject2.low,'nearest');
svhigh = interp1(probs,probs,sv.subject2.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(svlow == probs);
eqlow.Ep1 = cat(1,eqlow.Ep1,separated_trials.sub2.low.Ep1{x}.cell);
eqlow.Ep2 = cat(1,eqlow.Ep2,separated_trials.sub2.low.Ep2{x}.cell);
x = find(svhigh == probs);
eqhigh.Ep1 = cat(1,eqhigh.Ep1,separated_trials.sub2.high.Ep1{x}.cell);
eqhigh.Ep2 = cat(1,eqhigh.Ep2,separated_trials.sub2.high.Ep2{x}.cell);

clear iJ x svlow svhigh separated_trials;
separated_trials.safe = safe;
separated_trials.low = low;
separated_trials.high = high;
separated_trials.test = test;
separated_trials.eqlow = eqlow;
separated_trials.eqhigh = eqhigh;
separated_trials.mFR = mFR;
separated_trials.sem = sem;
separated_trials.sv = sv;
separated_trials.n1 = n1;
separated_trials.n2 = n2;
separated_trials.n3 = n3;

clearvars -except separated_trials probs;

%% Test if resulting rate is better than "chance" (i.e. false pos. rate)
% pick one probability at random from (0-100) and ask how often that 
% probability is different in its evoked 
% neural response from the SV that is equivalent to the safe.

for iL = 1:1000
    rx = randi(length(probs));
    lowp = separated_trials.test{rx}.low;
    highp = separated_trials.test{rx}.high;

    indhigh(1:length(highp),1) = NaN;
    indlow(1:length(lowp),1) = NaN;
    temp1 = find(lowp > 0.1);
    temp2 = find(highp > 0.1);
    for iJ = 1:length(temp1)
        indlow(temp1(iJ)) = temp1(iJ);
    end
    for iJ = 1:length(temp2)
        indhigh(temp2(iJ)) = temp2(iJ);
    end
    clear highp lowp temp1 temp2 iJ;

    ind = find(indhigh == indlow);
    testrate(iL,1) = (length(ind)/separated_trials.n3)*100;
    clear indhigh indlow ind;
end
testrate = sort(testrate);
testrate_avg = nanmean(testrate);
testrate_sem = nanstd(testrate)/sqrt(1000);

%% search results of t-tests to identify "value cells"
svlow = interp1(probs,probs,separated_trials.sv.subject1.low,'nearest');
svhigh = interp1(probs,probs,separated_trials.sv.subject1.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(probs == svlow);
y = find(probs == svhigh);
lowp = separated_trials.test{x}.low(1:separated_trials.n1,:);
highp = separated_trials.test{y}.high(1:separated_trials.n1,:);
svlow = interp1(probs,probs,separated_trials.sv.subject2.low,'nearest');
svhigh = interp1(probs,probs,separated_trials.sv.subject2.high,'nearest');
if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end
x = find(probs == svlow);
y = find(probs == svhigh);
lowp = cat(1,lowp,separated_trials.test{x}.low(separated_trials.n1+1:end,:));
highp = cat(1,highp,separated_trials.test{x}.high(separated_trials.n1+1:end,:));
indhigh(1:length(highp),1) = NaN;
indlow(1:length(highp),1) = NaN;

temp1 = find(lowp > 0.1);
temp2 = find(highp > 0.1);

for iJ = 1:length(temp1)
    indlow(temp1(iJ)) = temp1(iJ);
end
for iJ = 1:length(temp2)
    indhigh(temp2(iJ)) = temp2(iJ);
end

clear highp lowp temp1 temp2 temp3 iJ iK prob x y;

ind(1:length(indlow),1) = NaN;
for iJ = 1:length(ind)
    if indhigh(iJ) == indlow(iJ)
        ind(iJ) = indhigh(iJ);
    end
end
clear indlow indhigh;

for iJ = length(ind):-1:1
    if isnan(ind(iJ))
        ind(iJ) = [];
    end
end
rate = (length(ind)/separated_trials.n3)*100;
x = find(testrate < rate);
p_rate = 1-(length(x)/1000);
clear indhigh indlow indgamble indtemp iJ iK x;

%% isolate possible "value cells" based on rates
sigs = filter_sigs(separated_trials,ind,probs);
s = sigs.mFR.safe;
l = sigs.mFR.eqlow;
h = sigs.mFR.eqhigh;
clear x;
l_diff = s - l;
h_diff = s - h;
clear s l h;

[~,indsig(:,1)] = sort(l_diff,1);
[~,indsig(:,2)] = sort(h_diff,1);

for iJ = 1:size(indsig,1)/2
    sigs.safelow.Ep1{iJ,1} = sigs.safe.Ep1{indsig(iJ,1)};
    sigs.safelow.Ep2{iJ,1} = sigs.safe.Ep2{indsig(iJ,1)};
    sigs.safehigh.Ep1{iJ,1} = sigs.safe.Ep1{indsig(iJ,2)};
    sigs.safehigh.Ep2{iJ,1} = sigs.safe.Ep2{indsig(iJ,2)};
    sigs.eqlowhalf.Ep1{iJ,1} = sigs.eqlow.Ep1{indsig(iJ,2)};
    sigs.eqlowhalf.Ep2{iJ,1} = sigs.eqlow.Ep2{indsig(iJ,2)};
    sigs.eqhighhalf.Ep1{iJ,1} = sigs.eqhigh.Ep1{indsig(iJ,2)};
    sigs.eqhighhalf.Ep2{iJ,1} = sigs.eqhigh.Ep2{indsig(iJ,2)};
    for iK = 1:length(probs)
    sigs.lowhalf.Ep1{iK,1}.cell{iJ,1} = sigs.low.Ep1{iK,1}.cell{indsig(iJ,1)};
    sigs.lowhalf.Ep2{iK,1}.cell{iJ,1} = sigs.low.Ep2{iK,1}.cell{indsig(iJ,1)};
    sigs.highhalf.Ep1{iK,1}.cell{iJ,1} = sigs.high.Ep1{iK,1}.cell{indsig(iJ,2)};
    sigs.highhalf.Ep2{iK,1}.cell{iJ,1} = sigs.high.Ep2{iK,1}.cell{indsig(iJ,2)};
    end
end

%% Classifier on whole population and on subset based on rate
iterations = 1000;
[classifier.full.out,classifier.full.SEM] = Classification_SV(separated_trials,iterations);
[classifier.sigs.out,classifier.sigs.SEM] = Classification_SV_sigs(sigs,iterations);

%% Delta Analayses
diff = mFRdiff_SafeRisky(separated_trials,probs);
subset = subset_deltas(separated_trials,probs);
% [avg, p] = mFRdiff_SafeRisky_poscontrol(separated_trials,probs);

%% Collect Results
R.diff = diff;
% R.poscontrol.avg = avg;
% R.poscontrol.p = p;
R.subset = subset;
R.separated_trials = separated_trials;
R.ind = ind;
R.rate = rate;
R.testrate = testrate_avg;
R.testreate_sem = testrate_sem;
R.p_rate = p_rate;
R.sigs = sigs;
R.classifier = classifier;
R.MI = MuIn;

end
