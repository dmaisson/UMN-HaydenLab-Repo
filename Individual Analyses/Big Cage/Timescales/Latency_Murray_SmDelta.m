function [L] = Latency_Murray_SmDelta(start,laglen)
%% Instructions
%   - autocorrelate between time bins across trials for each cell
% 	- fit the decay function to the autocorrelation data (using levenberg-marquardt)
% 	- extract intrinsic timescale from fitting process (solve for tau)
% 	- compare effect of timescales by regressing on them in 3 ways
% 		- predictor: timescale; outcome: autocorrelation offset
% 		- predictor: mFR; outcome: timescale
% 		- predictor: trial-trial correlation; outcome autocorrelation offset
%% Pull out the desired data and shrink it to 40ms bins
data = psth_resample_align(start);

for iJ = 1:size(data,1)
    forespikes{iJ} = data{iJ}(:,50:149);
end
forespikes = forespikes';
clear data fore iJ start;

%% Autocorrelation
% Correlation between data @ time i and itself @ time j
laglen = laglen/20;
lag(:,1) = (1:laglen); % 20ms - 360ms
for iJ = 1:length(lag) % for each difference in time between bins (from 40-360ms)
    for iK = 1:size(forespikes,1) % for each cell
        for iL = 1:(size(forespikes{iK},2)-lag(iJ)) % for each bin
            temp(iK,iL) = corr(forespikes{iK}(:,iL),forespikes{iK}(:,iL+lag(iJ))); % correlate bin i and bin j, where i and j are separate by a time distance defined by lag
        end
    end
    temp_avg(:,iJ) = nanmean(temp,2);
end
auto = (nanmean(temp_avg,1))';
autosem = ((nanstd(temp_avg,1))/sqrt(size(temp_avg,1)));
clear iJ iK iL temp temp_avg laglen;
lag(1:(lag(end)),1) = (20:20:(lag(end)*20));
figure;
hold on; errorbar(lag,auto,autosem, 'o');
ylim([0 0.15]);

%% Fit the decay function
% decay function = A[exp(-kD/tau)+B] %inverse is log
% terms:
% A = autocorrelation output for each lag size
% kD = lag (in number of x-sized bins; in this cas 40ms)
% tau = timescale(unknown)
% B = offset
% solve for B when exp term is 1 and/or 0...but what's A?
%when exp term is 1, B = 0; when exp term is 0, B = 1.

% decay = fit(lag,auto,'exp1');
% % the result here is a fit function of a*exp(x*b);
% % if x = kD, then b = -(1/tau); thus, tau = -(1/b) is B-offset is 0;
% plot(decay,lag,auto);
x0 = [1 0 0];
decay_fun = fittype( @(A,b,B,x) (A*(exp((x*b))+B)) );
decay = fit(lag,auto,decay_fun, 'StartPoint', x0);
plot(decay,lag,auto);

%% Maximize fit
% sum of squared differences between data and line
A = decay.A;
b = decay.b;
B = decay.B;
% clear decay;
tau = 1/((-1)*b);
for iJ = 1:length(auto)
    pred(iJ,1) = (A.*(exp(b.*lag(iJ,1))+B));
    diff(iJ,1) = auto(iJ,1) - pred(iJ,1);
    diff_sq = diff.^2;
end
SSe = sum(diff_sq);

%% collect
L.auto = auto;
L.autosem = autosem;
L.decay = decay;
L.tau = tau;
L.A = A;
L.B = B;
L.lag = lag;
L.SSe = SSe;
end