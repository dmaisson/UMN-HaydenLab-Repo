%% Integration
figure;
% subplot(421);
% scatter(abs(Results.data13.Epoch1.b.prob1),abs(Results.data13.Epoch1.b.size1)); hold on;
% [Line] = BestFitLines_unsigned(Results,13,0,0.2);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('OFC13');
% subplot(422);
% scatter(abs(Results.data11.Epoch1.b.prob1),abs(Results.data11.Epoch1.b.size1)); hold on;
% [Line] = BestFitLines_unsigned(Results,11,0,0.2);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding')
% ylabel('Reward Coding')
% title('OFC11')
subplot(221);
scatter(abs(Results.data14.Epoch1.b.prob1),abs(Results.data14.Epoch1.b.size1)); hold on;
[Line] = BestFitLines_unsigned(Results,14,0,0.3);
plot(Line.samples,Line.Integ);
ylim([0 0.3]);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('vmPFC');
subplot(222);
scatter(abs(Results.data25.Epoch1.b.prob1),abs(Results.data25.Epoch1.b.size1)); hold on;
[Line] = BestFitLines_unsigned(Results,25,0,0.3);
plot(Line.samples,Line.Integ);
ylim([0 0.3]);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('sgACC');
subplot(223);
scatter(abs(Results.data32.Epoch1.b.prob1),abs(Results.data32.Epoch1.b.size1)); hold on;
[Line] = BestFitLines_unsigned(Results,32,0,0.3);
plot(Line.samples,Line.Integ);
ylim([0 0.3]);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('ACC32');
% subplot(426);
% scatter(abs(Results.dataPCC.Epoch1.b.prob1),abs(Results.dataPCC.Epoch1.b.size1)); hold on;
% [Line] = BestFitLines_unsigned(Results,1,0,0.1);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('PCC');
% subplot(427);
% scatter(abs(Results.dataVS.Epoch1.b.prob1),abs(Results.dataVS.Epoch1.b.size1)); hold on;
% [Line] = BestFitLines_unsigned(Results,2,0,0.4);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('VS');
subplot(224);
scatter(abs(Results.data24.Epoch1.b.prob1),abs(Results.data24.Epoch1.b.size1)); hold on;
[Line] = BestFitLines_unsigned(Results,24,0,0.3);
plot(Line.samples,Line.Integ);
ylim([0 0.3]);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('dCC');
% subplot(529);
% scatter(Results.dataRSC.cat.prob,Results.dataRSC.cat.size); hold on;
% [Line] = BestFitLines(Results,3,-0.2,0.2);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('RSC');

%% Inhibition
figure;
% subplot(421);
% scatter(abs(Results.data13.Epoch2.b.EV1),abs(Results.data13.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,13,0,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('Area 13')
% subplot(422);
% scatter(abs(Results.data11.Epoch2.b.EV1),abs(Results.data11.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,11,0,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('Area 11')
subplot(221);
scatter(abs(Results.data14.Epoch2.b.EV1),abs(Results.data14.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,14,0,0.1);
plot(Line.samples,Line.Inhib);
ylim([0 0.1]);
xlabel('EV1 in Epoch2')
ylabel('EV2 in Epoch2')
title('Area 14')
subplot(222);
scatter(abs(Results.data25.Epoch2.b.EV1),abs(Results.data25.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,25,0,0.1);
plot(Line.samples,Line.Inhib);
ylim([0 0.1]);
xlabel('EV1 in Epoch2')
ylabel('EV2 in Epoch2')
title('Area 25')
subplot(223);
scatter(abs(Results.data32.Epoch2.b.EV1),abs(Results.data32.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,32,0,0.1);
plot(Line.samples,Line.Inhib);
ylim([0 0.1]);
xlabel('EV1 in Epoch2')
ylabel('EV2 in Epoch2')
title('Area 32')
% subplot(426);
% scatter(abs(Results.dataPCC.Epoch2.b.EV1),abs(Results.dataPCC.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,1,0,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('PCC')
% subplot(427);
% scatter(abs(Results.dataVS.Epoch2.b.EV1),abs(Results.dataVS.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,2,0,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('VS')
subplot(224);
scatter(abs(Results.data13.Epoch2.b.EV1),abs(Results.data13.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,24,0,0.1);
plot(Line.samples,Line.Inhib);
ylim([0 0.1]);
xlabel('EV1 in Epoch2')
ylabel('EV2 in Epoch2')
title('Area 24')
% subplot(529);
% scatter(Results.dataRSC.Epoch2.b.EV1,Results.dataRSC.Epoch2.b.EV2); hold on;
% [Line] = BestFitLines(Results,24,-0.1,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('RSC')

%% Alignment
figure;
% subplot(421);
% scatter(abs(Results.data13.Epoch1.b.EV1),abs(Results.data13.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,13,0,0.1);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('Area 13')
% subplot(422);
% scatter(abs(Results.data11.Epoch1.b.EV1),abs(Results.data11.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,11,0,0.1);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('Area 11')
subplot(221);
scatter(abs(Results.data14.Epoch1.b.EV1),abs(Results.data14.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,14,0,0.1);
plot(Line.samples,Line.Align);
ylim([0 0.1]);
xlabel('EV1 in Epoch1')
ylabel('EV2 in Epoch2')
title('Area 14')
subplot(222);
scatter(abs(Results.data25.Epoch1.b.EV1),abs(Results.data25.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,25,0,0.1);
plot(Line.samples,Line.Align);
ylim([0 0.1]);
xlabel('EV1 in Epoch1')
ylabel('EV2 in Epoch2')
title('Area 25')
subplot(223);
scatter(abs(Results.data32.Epoch1.b.EV1),abs(Results.data32.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,32,0,0.1);
plot(Line.samples,Line.Align);
ylim([0 0.1]);
xlabel('EV1 in Epoch1')
ylabel('EV2 in Epoch2')
title('Area 32')
% subplot(426);
% scatter(abs(Results.dataPCC.Epoch1.b.EV1),abs(Results.dataPCC.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,1,0,0.1);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('PCC')
% subplot(427);
% scatter(abs(Results.dataVS.Epoch1.b.EV1),abs(Results.dataVS.Epoch2.b.EV2)); hold on;
% [Line] = BestFitLines_unsigned(Results,2,0,0.2);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('VS')
subplot(224);
scatter(abs(Results.data24.Epoch1.b.EV1),abs(Results.data24.Epoch2.b.EV2)); hold on;
[Line] = BestFitLines_unsigned(Results,24,0,0.1);
plot(Line.samples,Line.Align);
ylim([0 0.1]);
xlabel('EV1 in Epoch1')
ylabel('EV2 in Epoch2')
title('Area 24')
% subplot(529);
% scatter(Results.dataRSC.Epoch1.b.EV1,Results.dataRSC.Epoch2.b.EV2); hold on;
% [Line] = BestFitLines(Results,24,-0.2,0.2);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('RSC')

%% WM
figure;
subplot(421);
scatter(abs(Results.data13.Epoch1.b.EV1),abs(Results.data13.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,13,0,0.1);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 13')
subplot(422);
scatter(abs(Results.data11.Epoch1.b.EV1),abs(Results.data11.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,11,0,0.1);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 11')
subplot(423);
scatter(abs(Results.data14.Epoch1.b.EV1),abs(Results.data14.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,14,0,0.2);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 14')
subplot(424);
scatter(abs(Results.data25.Epoch1.b.EV1),abs(Results.data25.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,25,0,0.2);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 25')
subplot(425);
scatter(abs(Results.data32.Epoch1.b.EV1),abs(Results.data32.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,32,0,0.1);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 32')
subplot(426);
scatter(abs(Results.dataPCC.Epoch1.b.EV1),abs(Results.dataPCC.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,1,0,0.1);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('PCC')
subplot(427);
scatter(abs(Results.dataVS.Epoch1.b.EV1),abs(Results.dataVS.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,2,0,0.2);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('VS')
subplot(428);
scatter(abs(Results.data24.Epoch1.b.EV1),abs(Results.data24.Epoch2.b.EV1)); hold on;
[Line] = BestFitLines_unsigned(Results,24,0,0.2);
plot(Line.samples,Line.WM);
xlabel('EV1 in Epoch1')
ylabel('EV1 in Epoch2')
title('Area 24')
% subplot(529);
% scatter(Results.dataRSC.Epoch1.b.EV1,Results.dataRSC.Epoch2.b.EV1); hold on;
% [Line] = BestFitLines(Results,24,-0.2,0.2);
% plot(Line.samples,Line.WM);
% xlabel('EV1 in Epoch1')
% ylabel('EV1 in Epoch2')
% title('RSC')