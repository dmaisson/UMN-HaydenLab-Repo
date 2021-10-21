function avgdelta = Subset_Delta_plotMudelta(input)

in.subject1 = input.subject1.subset;
in.subject2 = input.subject2.subset;

%% extract mean deltas
for iJ = 1:length(in.subject1.S)
    avgdelta.subject1.low(iJ,1) = nanmean(in.subject1.subset.mlow);
    avgdelta.subject1.low_sem(iJ,1) = nanmean(in.subject1.subset.slow);
    avgdelta.subject1.high(iJ,1) = nanmean(in.subject1.subset.mhigh);
    avgdelta.subject1.high_sem(iJ,1) = nanmean(in.subject1.subset.shigh);
    
%% Avg across subs
x(:,1) = avgdelta.subject1.low;
x(:,2) = avgdelta.subject2.low;
avgdelta.avged.low = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.high;
x(:,2) = avgdelta.subject2.high;
avgdelta.avged.high = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.pseudolow;
x(:,2) = avgdelta.subject2.pseudolow;
avgdelta.avged.pseudolow = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.pseudohigh;
x(:,2) = avgdelta.subject2.pseudohigh;
avgdelta.avged.pseudohigh = nanmean(x,2);
clear x;

x(:,1) = avgdelta.subject1.low_sem;
x(:,2) = avgdelta.subject2.low_sem;
avgdelta.avged.low_sem = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.high_sem;
x(:,2) = avgdelta.subject2.high_sem;
avgdelta.avged.high_sem = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.pseudolow_sem;
x(:,2) = avgdelta.subject2.pseudolow_sem;
avgdelta.avged.pseudolow_sem = nanmean(x,2);
clear x;
x(:,1) = avgdelta.subject1.pseudohigh_sem;
x(:,2) = avgdelta.subject2.pseudohigh_sem;
avgdelta.avged.pseudohigh_sem = nanmean(x,2);
clear x;

%% K-S test
[~,avgdelta.KS.low.p,avgdelta.KS.low.stats] = kstest2(avgdelta.avged.low,avgdelta.avged.pseudolow);
[~,avgdelta.KS.high.p,avgdelta.KS.high.stats] = kstest2(avgdelta.avged.high,avgdelta.avged.pseudohigh);

%% Plot
figure;
subplot(2,2,1);
hold on;
plot(avgdelta.subject1.low, 'Linewidth',2);
plot(avgdelta.subject1.pseudolow, 'Linewidth',2);
xlabel('subset P at size S');
ylabel('avg. delta');
title('Subject1');
legend('safe v. equiv-low', 'safe v. pseudo equiv-low');
subplot(2,2,2);
hold on;
plot(avgdelta.subject2.low, 'Linewidth',2);
plot(avgdelta.subject2.pseudolow, 'Linewidth',2);
xlabel('subset P at size S');
ylabel('avg. delta');
title('Subject2');
legend('safe v. equiv-low', 'safe v. pseudo equiv-low');
subplot(2,2,3);
hold on;
plot(avgdelta.subject1.high, 'Linewidth',2);
plot(avgdelta.subject1.pseudohigh, 'Linewidth',2);
xlabel('subset P at size S');
ylabel('avg. delta');
title('Subject1');
legend('safe v. equiv-high', 'safe v. pseudo equiv-high');
subplot(2,2,4);
hold on;
plot(avgdelta.subject2.high, 'Linewidth',2);
plot(avgdelta.subject2.pseudohigh, 'Linewidth',2);
xlabel('subset P at size S');
ylabel('avg. delta');
title('Subject2');
legend('safe v. equiv-high', 'safe v. pseudo equiv-high');

%% Plot Avg

figure;
subplot(1,2,1);
hold on;
error_high = avgdelta.avged.low+avgdelta.avged.low_sem;
error_low = avgdelta.avged.low-avgdelta.avged.low_sem;
plot(avgdelta.avged.low,'-b','Linewidth',2);
plot(error_low,'-b');
plot(error_high,'-b');
error_high = avgdelta.avged.pseudolow+avgdelta.avged.pseudolow_sem;
error_low = avgdelta.avged.pseudolow-avgdelta.avged.pseudolow_sem;
plot(avgdelta.avged.pseudolow,'-r','Linewidth',2);
plot(error_low,'-r');
plot(error_high,'-r');
xlabel('subset P at size S');
ylabel('avg. delta');
title('Low');

subplot(1,2,2);
hold on;
error_high = avgdelta.avged.high+avgdelta.avged.high_sem;
error_low = avgdelta.avged.high-avgdelta.avged.high_sem;
plot(avgdelta.avged.high,'b','Linewidth',2);
plot(error_low,'b');
plot(error_high,'b');
error_high = avgdelta.avged.pseudohigh+avgdelta.avged.pseudohigh_sem;
error_low = avgdelta.avged.pseudohigh-avgdelta.avged.pseudohigh_sem;
plot(avgdelta.avged.pseudohigh,'r','Linewidth',2);
plot(error_low,'r');
plot(error_high,'r');
xlabel('subset P at size S');
ylabel('avg. delta');
title('High');

end