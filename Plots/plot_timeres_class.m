figure;
hold on;
plot(x,smoothdata(accuracy_Choice),'Linewidth',2);
plot(x,smoothdata(accuracy_ChoiceS),'Linewidth',2);
ylim([0.58 0.8]);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('decoder accuracy');
legend('choice','choice side');

figure;
hold on;
plot(x,smoothdata(accuracy_Choice),'Linewidth',2);
plot(x,smoothdata(accuracy_ChoiceS),'Linewidth',2);
plot(x,smoothdata(accuracy_ChosenEV),'Linewidth',2);
ylim([0.58 0.8]);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('decoder accuracy');
legend('choice','choice side','chosen value');

figure;
hold on;
plot(x,smoothdata(accuracy_EV1),'Linewidth',2);
plot(x,smoothdata(accuracy_EV2),'Linewidth',2);
plot(x,smoothdata(accuracy_Choice),'Linewidth',2);
ylim([0.58 0.8]);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('decoder accuracy');
legend('offer 1 value','offer 2 value','choice');

figure;
hold on;
plot(x,smoothdata(accuracy_EV1),'Linewidth',2);
plot(x,smoothdata(accuracy_EV2),'Linewidth',2);
plot(x,smoothdata(accuracy_Choice),'Linewidth',2);
plot(x,smoothdata(accuracy_ChosenEV),'Linewidth',2);
ylim([0.58 0.8]);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('decoder accuracy');
legend('offer 1 value','offer 2 value','choice','chosen value');