temp(:,1) = PCC_Results.subject1.ortho.VarE.safelow{1}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.safelow{1}(1:10,1);
PCC_Results.avg_VarE.safelow{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.safelow{2}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.safelow{2}(1:10,1);
PCC_Results.avg_VarE.safelow{2} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.lowsafe{1}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.lowsafe{1}(1:10,1);
PCC_Results.avg_VarE.lowsafe{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.lowsafe{2}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.lowsafe{2}(1:10,1);
PCC_Results.avg_VarE.lowsafe{2} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.safehigh{1}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.safehigh{1}(1:10,1);
PCC_Results.avg_VarE.safehigh{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.safehigh{2}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.safehigh{2}(1:10,1);
PCC_Results.avg_VarE.safehigh{2} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.highsafe{1}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.highsafe{1}(1:10,1);
PCC_Results.avg_VarE.highsafe{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.VarE.highsafe{2}(1:10,1);
temp(:,2) = PCC_Results.subject2.ortho.VarE.highsafe{2}(1:10,1);
PCC_Results.avg_VarE.highsafe{2} = mean(temp,2);

%%
temp(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{1}(1:10,1);
temp(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{1}(1:10,1);
PCC_Results.avg_VarE.evenodd{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{2}(1:10,1);
temp(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{2}(1:10,1);
PCC_Results.avg_VarE.evenodd{2} = mean(temp,2);

temp(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{1}(1:10,1);
temp(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{1}(1:10,1);
PCC_Results.avg_VarE.oddeven{1} = mean(temp,2);
temp(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{2}(1:10,1);
temp(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{2}(1:10,1);
PCC_Results.avg_VarE.oddeven{2} = mean(temp,2);

clear temp x;
save ('PCC_Results.mat','-v7.3');

%% Plot explained variance
figure;
subplot 321;
hold on;
x(:,1) = PCC_Results.subject1.ortho.VarE.safelow{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.VarE.safelow{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe offer', 'eq. low stakes offer');

subplot 322;
hold on;
x(:,1) = PCC_Results.subject1.ortho.VarE.lowsafe{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.VarE.lowsafe{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq. low stakes offer','safe offer');

subplot 323;
hold on;
x(:,1) = PCC_Results.subject1.ortho.VarE.safehigh{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.VarE.safehigh{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe offer', 'eq. high stakes offer');

subplot 324;
hold on;
x(:,1) = PCC_Results.subject1.ortho.VarE.highsafe{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.VarE.highsafe{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq. high stakes offer','safe offer');

subplot 325;
hold on;
x(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.oddeven{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('odd', 'even');

subplot 326;
hold on;
x(:,1) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{1,1}(1:10,:);
x(:,2) = PCC_Results.subject1.ortho.EvenOdd.VarE.evenodd{1,2}(1:10,:);
bar(x);
% ylim([0 30]);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('even','odd');

clear x;
cd Figures
saveas(gcf,'avg_ortho','epsc');