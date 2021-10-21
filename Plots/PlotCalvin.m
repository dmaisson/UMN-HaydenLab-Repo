%% Open multiple days into workspace
OpenMultipleSets
%% Prep them all for analysis
Calvin = PrepCal(data_all);
%% Analyze Behavior
[Bins,sem] = Behavior_Multiple(Calvin,input('Min?'),input('Max?'),input('Bin size?'));
%% Plot Behavior
figure;
hold on;
errorbar(Bins(:,1,(size(Bins,3)-1)),Bins(:,4,(size(Bins,3)-1)),sem, '-k');
xlim([-300 300]);
ylim([-5 105]);
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
hline(50);vline(0);