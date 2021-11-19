function pop = ValueCells(subject1,subject2,sv,rng)
%% separate trials by risk-type and calculate mFRs
separated_trials.sub1 = mFR_safeVrisk_SV_mod(subject1,rng);
separated_trials.sub2 = mFR_safeVrisk_SV_mod(subject2,rng);

%% collapse across subs - keeping eq.risky together, and rest together
n1 = length(subject1);
n2 = length(subject2);
safe.Ep1 = cat(1,separated_trials.sub1.safe.Ep1,separated_trials.sub2.safe.Ep1);
safe.Ep2 = cat(1,separated_trials.sub1.safe.Ep2,separated_trials.sub2.safe.Ep2);
safe.pre_trial = cat(1,separated_trials.sub1.safe.pre_trial,separated_trials.sub2.safe.pre_trial);
n3 = n1+n2;
for iJ = 1:length(separated_trials.sub1.low.Ep1)
    low.Ep1{iJ,1}.cell = cat(1,separated_trials.sub1.low.Ep1{iJ}.cell,separated_trials.sub2.low.Ep1{iJ}.cell);
    low.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.low.Ep2{iJ}.cell,separated_trials.sub2.low.Ep2{iJ}.cell);
    high.Ep1{iJ,1}.cell = cat(1,separated_trials.sub1.high.Ep1{iJ}.cell,separated_trials.sub2.high.Ep1{iJ}.cell);
    high.Ep2{iJ,1}.cell = cat(1,separated_trials.sub1.high.Ep2{iJ}.cell,separated_trials.sub2.high.Ep2{iJ}.cell);
end

probs = rng:rng:1;

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
separated_trials.eqlow = eqlow;
separated_trials.eqhigh = eqhigh;
separated_trials.sv = sv;
separated_trials.n1 = n1;
separated_trials.n2 = n2;
separated_trials.n3 = n3;

R.separated_trials = separated_trials;
clearvars -except R probs;

%% Population overlap
pop = Beta_corrs_SafeRisky(R.separated_trials);

end
