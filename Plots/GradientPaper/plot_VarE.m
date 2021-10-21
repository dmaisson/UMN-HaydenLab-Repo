x = -1:.1:2.4;

y(1,:) = VarE.vmPFC{3}.*10;
y(2,:) = VarE.vmPFC{4}.*10;
y(3,:) = VarE.vmPFC{5}.*10;
y(4,:) = VarE.vmPFC{6}.*10;
% y = nanmean(y).*10;
figure;
subplot 221
hold on
sempos = y(1,:) + y(3,:);
semneg = y(1,:) - y(3,:);
plot(x,y(1,1:35),'b','Linewidth',1);
plot(x,sempos(1,1:35),'b','Linewidth',0.25);
plot(x,semneg(1,1:35),'b','Linewidth',0.25);
sempos = y(2,:) + y(4,:);
semneg = y(2,:) - y(4,:);
plot(x,y(2,1:35),'r','Linewidth',1);
plot(x,sempos(1,1:35),'r','Linewidth',0.25);
plot(x,semneg(1,1:35),'r','Linewidth',0.25);
ylim([0 8]);
vline(0,0);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('explained variance (%)');
title('vmPFC');

y(1,:) = VarE.sgACC{3}.*10;
y(2,:) = VarE.sgACC{4}.*10;
y(3,:) = VarE.sgACC{5}.*10;
y(4,:) = VarE.sgACC{6}.*10;
% y = nanmean(y).*10;
subplot 222
hold on
sempos = y(1,:) + y(3,:);
semneg = y(1,:) - y(3,:);
plot(x,y(1,1:35),'b','Linewidth',1);
plot(x,sempos(1,1:35),'b','Linewidth',0.25);
plot(x,semneg(1,1:35),'b','Linewidth',0.25);
sempos = y(2,:) + y(4,:);
semneg = y(2,:) - y(4,:);
plot(x,y(2,1:35),'r','Linewidth',1);
plot(x,sempos(1,1:35),'r','Linewidth',0.25);
plot(x,semneg(1,1:35),'r','Linewidth',0.25);
ylim([0 8]);
vline(0,0);
vline(0.75,0);
vline(1.5,0);
xlabel('time (s)');
ylabel('explained variance (%)');
title('sgACC');

y(1,:) = VarE.pgACC{3}.*10;
y(2,:) = VarE.pgACC{4}.*10;
y(3,:) = VarE.pgACC{5}.*10;
y(4,:) = VarE.pgACC{6}.*10;
% y = nanmean(y).*10;
subplot 223
hold on
sempos = y(1,:) + y(3,:);
semneg = y(1,:) - y(3,:);
plot(x,y(1,1:35),'b','Linewidth',1);
plot(x,sempos(1,1:35),'b','Linewidth',0.25);
plot(x,semneg(1,1:35),'b','Linewidth',0.25);
sempos = y(2,:) + y(4,:);
semneg = y(2,:) - y(4,:);
plot(x,y(2,1:35),'r','Linewidth',1);
plot(x,sempos(1,1:35),'r','Linewidth',0.25);
plot(x,semneg(1,1:35),'r','Linewidth',0.25);
ylim([0 8]);
vline(0,0);
vline(1,0);
vline(2,0);
xlabel('time (s)');
ylabel('explained variance (%)');
title('pgACC');

y(1,:) = VarE.dACC{3}.*10;
y(2,:) = VarE.dACC{4}.*10;
y(3,:) = VarE.dACC{5}.*10;
y(4,:) = VarE.dACC{6}.*10;
% y = nanmean(y).*10;
subplot 224
hold on
sempos = y(1,:) + y(3,:);
semneg = y(1,:) - y(3,:);
plot(x,y(1,1:35),'b','Linewidth',1);
plot(x,sempos(1,1:35),'b','Linewidth',0.25);
plot(x,semneg(1,1:35),'b','Linewidth',0.25);
sempos = y(2,:) + y(4,:);
semneg = y(2,:) - y(4,:);
plot(x,y(2,1:35),'r','Linewidth',1);
plot(x,sempos(1,1:35),'r','Linewidth',0.25);
plot(x,semneg(1,1:35),'r','Linewidth',0.25);
ylim([0 8]);
vline(0,0);
vline(0.75,0);
vline(1.5,0);
xlabel('time (s)');
ylabel('explained variance (%)');
title('dACC');