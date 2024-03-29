%% Integration
% figure;
% scatter(Results.data13.Epoch1.b.prob1,Results.data13.Epoch1.b.size1); hold on;
% [Line,Error] = BestFitLines(Results,13,-0.4,0.4);
% plot(Line.samples,Line.Integ, '-k');
% plot(Line.samples,Error.plus.Integ, '-r');
% plot(Line.samples,Error.minus.Integ, '-r');
% ylim([-0.4 0.4]);
% hline(0); vline(0);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('OFC13');
% clear Line Error;
% figure;
% scatter(Results.data11.Epoch1.b.prob1,Results.data11.Epoch1.b.size1); hold on;
% [Line,Error] = BestFitLines(Results,11,-0.4,0.4);
% plot(Line.samples,Line.Integ, '-k');
% plot(Line.samples,Error.plus.Integ, '-r');
% plot(Line.samples,Error.minus.Integ, '-r');
% ylim([-0.4 0.4]);
% hline(0); vline(0);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('OFC11');
% clear Line Error;
figure;
scatter(integ.vmPFC(:,1),integ.vmPFC(:,2)); hold on;
[Line,Error] = BestFitLines_reviewerResp(integ,14,-0.25,0.25);
plot(Line.samples,Line.func, '-k');
plot(Line.samples,Error.plus, '-r');
plot(Line.samples,Error.minus, '-r');
xlim([-0.25 0.25]);
ylim([-0.25 0.25]);
hline(0); vline(0,0);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('vmPFC');
clear Line Error;
figure;
scatter(Results.data25.Epoch1.b.prob1,Results.data25.Epoch1.b.size1); hold on;
[Line,Error] = BestFitLines(Results,25,-0.4,0.4);
plot(Line.samples,Line.Integ, '-k');
plot(Line.samples,Error.plus.Integ, '-r');
plot(Line.samples,Error.minus.Integ, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('sgACC');
clear Line Error;
figure;
scatter(Results.data32.Epoch1.b.prob1,Results.data32.Epoch1.b.size1); hold on;
[Line,Error] = BestFitLines(Results,32,-0.4,0.4);
plot(Line.samples,Line.Integ, '-k');
plot(Line.samples,Error.plus.Integ, '-r');
plot(Line.samples,Error.minus.Integ, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('ACC32');
clear Line Error;
% figure;
% scatter(Results.dataPCC.Epoch1.b.prob1,Results.dataPCC.Epoch1.b.size1); hold on;
% [Line,Error] = BestFitLines(Results,1,-0.4,0.4);
% plot(Line.samples,Line.Integ, '-k');
% plot(Line.samples,Error.plus.Integ, '-r');
% plot(Line.samples,Error.minus.Integ, '-r');
% ylim([-0.4 0.4]);
% hline(0); vline(0);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('PCC');
% clear Line Error;
% figure;
% scatter(Results.dataVS.Epoch1.b.prob1,Results.dataVS.Epoch1.b.size1); hold on;
% [Line,Error] = BestFitLines(Results,2,-0.4,0.4);
% plot(Line.samples,Line.Integ, '-k');
% plot(Line.samples,Error.plus.Integ, '-r');
% plot(Line.samples,Error.minus.Integ, '-r');
% ylim([-0.4 0.4]);
% hline(0); vline(0);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('VS');
% clear Line Error;
figure;
scatter(Results.data24.Epoch1.b.prob1,Results.data24.Epoch1.b.size1); hold on;
[Line,Error] = BestFitLines(Results,24,-0.4,0.4);
plot(Line.samples,Line.Integ, '-k');
plot(Line.samples,Error.plus.Integ, '-r');
plot(Line.samples,Error.minus.Integ, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('Probability Coding');
ylabel('Reward Coding');
title('dCC');
clear Line Error;
% subplot(529);
% scatter(Results.dataRSC.cat.prob,Results.dataRSC.cat.size); hold on;
% [Line] = BestFitLines(Results,3,-0.2,0.2);
% plot(Line.samples,Line.Integ);
% xlabel('Probability Coding');
% ylabel('Reward Coding');
% title('RSC');

%% Inhibition
% figure;
% scatter(Results.data13.Epoch2.b.EV1,Results.data13.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,13,-0.1,0.1);
% plot(Line.samples,Line.Inhib, '-k');
% plot(Line.samples,Error.plus.Inhib, '-r');
% plot(Line.samples,Error.minus.Inhib, '-r');
% ylim([-0.1 0.1]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch2');
% ylabel('EV2 in Epoch2');
% title('Area 13');
% figure;
% scatter(Results.data11.Epoch2.b.EV1,Results.data11.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,11,-0.1,0.1);
% plot(Line.samples,Line.Inhib, '-k');
% plot(Line.samples,Error.plus.Inhib, '-r');
% plot(Line.samples,Error.minus.Inhib, '-r');
% ylim([-0.1 0.1]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch2');
% ylabel('EV2 in Epoch2');
% title('Area 11');
figure;
scatter(Results.data14.Epoch2.b.EV1,Results.data14.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,14,-0.4,0.4);
plot(Line.samples,Line.Inhib, '-k');
plot(Line.samples,Error.plus.Inhib, '-r');
plot(Line.samples,Error.minus.Inhib, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch2');
ylabel('EV2 in Epoch2');
title('Area 14');
figure;
scatter(Results.data25.Epoch2.b.EV1,Results.data25.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,25,-0.4,0.4);
plot(Line.samples,Line.Inhib, '-k');
plot(Line.samples,Error.plus.Inhib, '-r');
plot(Line.samples,Error.minus.Inhib, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch2');
ylabel('EV2 in Epoch2');
title('Area 25');
figure;
scatter(Results.data32.Epoch2.b.EV1,Results.data32.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,32,-0.4,0.4);
plot(Line.samples,Line.Inhib, '-k');
plot(Line.samples,Error.plus.Inhib, '-r');
plot(Line.samples,Error.minus.Inhib, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch2');
ylabel('EV2 in Epoch2');
title('Area 32');
% figure;
% scatter(Results.dataPCC.Epoch2.b.EV1,Results.dataPCC.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,1,-0.1,0.1);
% plot(Line.samples,Line.Inhib, '-k');
% plot(Line.samples,Error.plus.Inhib, '-r');
% plot(Line.samples,Error.minus.Inhib, '-r');
% ylim([-0.1 0.1]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch2');
% ylabel('EV2 in Epoch2');
% title('PCC');
% figure;
% scatter(Results.dataVS.Epoch2.b.EV1,Results.dataVS.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,2,-0.1,0.1);
% plot(Line.samples,Line.Inhib, '-k');
% plot(Line.samples,Error.plus.Inhib, '-r');
% plot(Line.samples,Error.minus.Inhib, '-r');
% ylim([-0.1 0.1]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch2');
% ylabel('EV2 in Epoch2');
% title('VS');
figure;
scatter(Results.data24.Epoch2.b.EV1,Results.data24.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,24,-0.4,0.4);
plot(Line.samples,Line.Inhib, '-k');
plot(Line.samples,Error.plus.Inhib, '-r');
plot(Line.samples,Error.minus.Inhib, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch2');
ylabel('EV2 in Epoch2');
title('Area 24');
% subplot(529);
% scatter(Results.dataRSC.Epoch2.b.EV1,Results.dataRSC.Epoch2.b.EV2); hold on;
% [Line] = BestFitLines(Results,24,-0.1,0.1);
% plot(Line.samples,Line.Inhib);
% xlabel('EV1 in Epoch2')
% ylabel('EV2 in Epoch2')
% title('RSC')

%% Alignment
% figure;
% scatter(Results.data13.Epoch1.b.EV1,Results.data13.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,13,-0.2,0.2);
% plot(Line.samples,Line.Align, '-k');
% plot(Line.samples,Error.plus.Align, '-r');
% plot(Line.samples,Error.minus.Align, '-r');
% ylim([-0.2 0.2]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch1');
% ylabel('EV2 in Epoch2');
% title('Area 13');
% figure;
% scatter(Results.data11.Epoch1.b.EV1,Results.data11.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,11,-0.2,0.2);
% plot(Line.samples,Line.Align, '-k');
% plot(Line.samples,Error.plus.Align, '-r');
% plot(Line.samples,Error.minus.Align, '-r');
% ylim([-0.2 0.2]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch1');
% ylabel('EV2 in Epoch2');
% title('Area 11');
figure;
scatter(Results.data14.Epoch1.b.EV1,Results.data14.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,14,-0.4,0.4);
plot(Line.samples,Line.Align, '-k');
plot(Line.samples,Error.plus.Align, '-r');
plot(Line.samples,Error.minus.Align, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV2 in Epoch2');
title('Area 14');
figure;
scatter(Results.data25.Epoch1.b.EV1,Results.data25.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,25,-0.2,0.2);
plot(Line.samples,Line.Align, '-k');
plot(Line.samples,Error.plus.Align, '-r');
plot(Line.samples,Error.minus.Align, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV2 in Epoch2');
title('Area 25');
figure;
scatter(Results.data32.Epoch1.b.EV1,Results.data32.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,32,-0.2,0.2);
plot(Line.samples,Line.Align, '-k');
plot(Line.samples,Error.plus.Align, '-r');
ylim([-0.4 0.4]);
plot(Line.samples,Error.minus.Align, '-r');
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV2 in Epoch2');
title('Area 32');
% figure;
% scatter(Results.dataPCC.Epoch1.b.EV1,Results.dataPCC.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,1,-0.2,0.2);
% plot(Line.samples,Line.Align, '-k');
% plot(Line.samples,Error.plus.Align, '-r');
% plot(Line.samples,Error.minus.Align, '-r');
% ylim([-0.2 0.2]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch1');
% ylabel('EV2 in Epoch2');
% title('PCC');
% figure;
% scatter(Results.dataVS.Epoch1.b.EV1,Results.dataVS.Epoch2.b.EV2); hold on;
% [Line,Error] = BestFitLines(Results,2,-0.2,0.2);
% plot(Line.samples,Line.Align, '-k');
% plot(Line.samples,Error.plus.Align, '-r');
% plot(Line.samples,Error.minus.Align, '-r');
% ylim([-0.2 0.2]);
% hline(0); vline(0);
% xlabel('EV1 in Epoch1');
% ylabel('EV2 in Epoch2');
% title('VS');
figure;
scatter(Results.data24.Epoch1.b.EV1,Results.data24.Epoch2.b.EV2); hold on;
[Line,Error] = BestFitLines(Results,24,-0.4,0.4);
plot(Line.samples,Line.Align, '-k');
plot(Line.samples,Error.plus.Align, '-r');
plot(Line.samples,Error.minus.Align, '-r');
ylim([-0.4 0.4]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV2 in Epoch2');
title('Area 24');
% subplot(529);
% scatter(Results.dataRSC.Epoch1.b.EV1,Results.dataRSC.Epoch2.b.EV2); hold on;
% [Line] = BestFitLines(Results,24,-0.2,0.2);
% plot(Line.samples,Line.Align);
% xlabel('EV1 in Epoch1')
% ylabel('EV2 in Epoch2')
% title('RSC')

%% WM
figure;
scatter(Results.data13.Epoch1.b.EV1,Results.data13.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,13,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 13');
figure;
scatter(Results.data11.Epoch1.b.EV1,Results.data11.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,11,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 11');
figure;
scatter(Results.data14.Epoch1.b.EV1,Results.data14.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,14,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 14');
figure;
scatter(Results.data25.Epoch1.b.EV1,Results.data25.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,25,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
ylim([-0.2 0.2]);
plot(Line.samples,Error.minus.WM, '-r');
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 25');
figure;
scatter(Results.data32.Epoch1.b.EV1,Results.data32.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,32,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 32');
figure;
scatter(Results.dataPCC.Epoch1.b.EV1,Results.dataPCC.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,1,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('PCC');
figure;
scatter(Results.dataVS.Epoch1.b.EV1,Results.dataVS.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,2,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('VS');
figure;
scatter(Results.data24.Epoch1.b.EV1,Results.data24.Epoch2.b.EV1); hold on;
[Line,Error] = BestFitLines(Results,24,-0.2,0.2);
plot(Line.samples,Line.WM, '-k');
plot(Line.samples,Error.plus.WM, '-r');
plot(Line.samples,Error.minus.WM, '-r');
ylim([-0.2 0.2]);
hline(0); vline(0);
xlabel('EV1 in Epoch1');
ylabel('EV1 in Epoch2');
title('Area 24');
% subplot(529);
% scatter(Results.dataRSC.Epoch1.b.EV1,Results.dataRSC.Epoch2.b.EV1); hold on;
% [Line] = BestFitLines(Results,24,-0.2,0.2);
% plot(Line.samples,Line.WM);
% xlabel('EV1 in Epoch1')
% ylabel('EV1 in Epoch2')
% title('RSC')