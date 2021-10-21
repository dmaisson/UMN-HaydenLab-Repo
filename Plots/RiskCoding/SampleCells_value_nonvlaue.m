%% set variables
separated_trials.sub1 = mFR_safeVrisk_SV(subject1,0.025);
probs = 0.025:0.025:1;

svlow = interp1(probs,probs,sv.low,'nearest');
svhigh = interp1(probs,probs,sv.high,'nearest');
mFR = separated_trials.sub1.mFR;
sem = separated_trials.sub1.sem;
n = length(separated_trials.sub1.safe.Ep1);

if svlow == 0 || isnan(svlow)
    svlow = 0.05;
end
if svhigh == 0 || isnan(svhigh)
    svhigh = 0.05;
end

x = find(svlow == probs);
y = find(probs == svhigh);
lowp = separated_trials.sub1.test{x}.low(1:n,:);
highp = separated_trials.sub1.test{y}.high(1:n,:);

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

% clear highp lowp temp1 temp2 temp3 iJ iK prob x y;

ind(1:length(indlow),1) = NaN;
for iJ = 1:length(ind)
    if indhigh(iJ) == indlow(iJ)
        ind(iJ) = indhigh(iJ);
    end
end
% clear indlow indhigh;

for iJ = length(ind):-1:1
    if isnan(ind(iJ))
        ind(iJ) = [];
    end
end
% clear indhigh indlow indgamble indtemp iJ iK x;

%% plotting
r = randi(length(ind),[1 8]);
figure;
for iJ = 1:length(r)
    subplot(2,4,iJ);
    title("cell" + ind(r(iJ)) + ": Safe v. Gamble");
    hold on;
    errorbar(probs(1:end),mFR.low(ind(r(iJ)),:),sem.low(ind(r(iJ)),:));
    hline(mFR.safe(ind(r(iJ)),:));
    hline(mFR.safe(ind(r(iJ)),:)+sem.safe(ind(r(iJ))));
    hline(mFR.safe(ind(r(iJ)),:)-sem.safe(ind(r(iJ))));
    vline(sv.low,0);
    legend('Low', 'Safe');
    ylabel('Mean FR (Hz)');
    xlabel('Binned Probability of Offer');
end
figure;
for iJ = 1:length(r)
    subplot(2,4,iJ);
    title("cell" + ind(r(iJ)) + ": Safe v. Gamble");
    hold on;
    errorbar(probs(1:end),mFR.high(ind(r(iJ)),:),sem.high(ind(r(iJ)),:));
    hline(mFR.safe(ind(r(iJ)),:));
    hline(mFR.safe(ind(r(iJ)),:)+sem.safe(ind(r(iJ))));
    hline(mFR.safe(ind(r(iJ)),:)-sem.safe(ind(r(iJ))));
    vline(sv.high,0);
    legend('High', 'Safe');
    ylabel('Mean FR (Hz)');
    xlabel('Binned Probability of Offer');
end

%%
t = (1:length(mFR.safe))';
for iJ = 1:length(t)
    for iK = 1:length(ind)
        if t(iJ,1) == ind(iK,1)
            t(iJ,1) = NaN;
        end
    end
end
for iJ = length(t):-1:1
    if isnan(t(iJ,1))
        t(iJ) = [];
    end
end
r = randperm(length(t));
for iJ = 1:length(r)
    n(iJ) = t(r(iJ));
end
n = r(1:8);
n = cell;
figure;
for iJ = 1:length(n)
    subplot(2,4,iJ);
    title("cell" + n(iJ) + ": Safe v. Gamble");
    hold on;
    errorbar(probs(1:end),mFR.low(n(iJ),:),sem.low(n(iJ),:));
    hline(mFR.safe(n(iJ),:));
    hline((mFR.safe(n(iJ),:))+(sem.safe(n(iJ),:)));
    hline((mFR.safe(n(iJ),:))-(sem.safe(n(iJ),:)));
    vline(sv.low,0);
    legend('Low', 'Safe');
    ylabel('Mean FR (Hz)');
    xlabel('Binned Probability of Offer');
end
figure;
for iJ = 1:length(n)
    subplot(2,4,iJ);
    title("cell" + n(iJ) + ": Safe v. Gamble");
    hold on;
    errorbar(probs(1:end),mFR.high(n(iJ),:),sem.high(n(iJ),:));
    hline(mFR.safe(n(iJ),:));
    hline((mFR.safe(n(iJ),:))+(sem.safe(n(iJ),:)));
    hline((mFR.safe(n(iJ),:))-(sem.safe(n(iJ),:)));
    vline(sv.high,0);
    legend('High', 'Safe');
    ylabel('Mean FR (Hz)');
    xlabel('Binned Probability of Offer');
end