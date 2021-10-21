function R = MI_pseudo(subject1,subject2,sv,range)
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

%% Mutual Information
iterations = 100;
[MuIn, sigrate,samples] = MI_PsuedoWrapper(separated_trials,iterations);

%% Collect
R.MuIn = MuIn;
R.sigrate = sigrate;
R.samples = samples;

end