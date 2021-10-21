figure;
subplot(421)
plot(Results.modrate.xtick,Results.data13.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data13.modrate.rate.SideC);
ylim([0 30]);
title('Area 13');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(422)
plot(Results.modrate.xtick,Results.data11.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data11.modrate.rate.SideC);
ylim([0 30]);
title('Area 11');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(423)
plot(Results.modrate.xtick,Results.data14.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data14.modrate.rate.SideC);
ylim([0 30]);
title('Area 14');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(424)
plot(Results.modrate.xtick,Results.data25.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data25.modrate.rate.SideC);
ylim([0 30]);
title('Area 25');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(.75);vline(1.5);vline(1.8);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(425)
plot(Results.modrate.xtick,Results.data32.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data32.modrate.rate.SideC);
ylim([0 30]);
title('Area 32');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(426)
plot(Results.modrate.xtick,Results.dataPCC.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.dataPCC.modrate.rate.SideC);
ylim([0 30]);
title('PCC');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(427)
plot(Results.modrate.xtick,Results.dataVS.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.dataVS.modrate.rate.SideC);
ylim([0 30]);
title('VS');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(1);vline(2);vline(2.3);vline(3);
hline(5);
legend('Side of First','Side of Choice');

subplot(428)
plot(Results.modrate.xtick,Results.data24.modrate.rate.Side1); hold on;
plot(Results.modrate.xtick,Results.data24.modrate.rate.SideC);
ylim([0 30]);
title('Area 24');
xlabel('Time(s) from Offer 1');
ylabel('FR corr with position (%)');
vline(0);vline(.75);vline(1.5);vline(1.8);vline(3);
hline(5);
legend('Side of First','Side of Choice');
% 
% subplot(529)
% plot(Results.modrate.xtick,Results.dataRSC.modrate.rate.Side1); hold on;
% plot(Results.modrate.xtick,Results.dataRSC.modrate.rate.SideC);
% title('RSC');
% xlabel('Time(s) from Offer 1');
% ylabel('FR corr with position (%)');
% vline(0);vline(1);vline(2);vline(2.3);vline(3);
% hline(5);
% legend('Side of First','Side of Choice');
