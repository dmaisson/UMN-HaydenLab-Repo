function out = can_corr_plot(in)
%% safe-low
output = canonical_corr_PCs(in.ortho.both.PCs);

x1 = in.ortho.both.projected1.safelow(:,1);
y1 = in.ortho.both.projected1.safelow(:,3);

x2 = output.safelow.U(:,1);
y2 = output.safelow.V(:,1);

b1 = glmfit(x1,y1);
line1 = -8:8;
line1 = b1(1)+(b1(2)*line1);
out.r1_safelow = corr(x1,y1);

b2 = glmfit(x2,y2);
line2 = -8:8;
line2 = b2(1)+(b2(2)*line2);
out.r2_safelow = corr(x2,y2);

xticks = -8:8;
figure;
hold on;
scatter(x1,y1,'b','o');
plot(xticks,line1,'b');
scatter(x2,y2,'r','+');
plot(xticks,line2,'r');
xlim([-4 4]);
ylim([-4 4]);

%% safe-high

x1 = in.ortho.both.projected1.safehigh(:,1);
y1 = in.ortho.both.projected1.safehigh(:,3);

x2 = output.safehigh.U(:,1);
y2 = output.safehigh.V(:,1);

b1 = glmfit(x1,y1);
line1 = -8:8;
line1 = b1(1)+(b1(2)*line1);
out.r1_safehigh = corr(x1,y1);

b2 = glmfit(x2,y2);
line2 = -8:8;
line2 = b2(1)+(b2(2)*line2);
out.r2_safehigh = corr(x2,y2);

xticks = -8:8;
figure;
hold on;
scatter(x1,y1,'b','o');
plot(xticks,line1,'b');
scatter(x2,y2,'r','+');
plot(xticks,line2,'r');
xlim([-4 4]);
ylim([-4 4]);

%%
output = canonical_corr_PCs_riskyrisky(in.ortho.both.riskyrisky.PCs);

x1 = in.ortho.both.riskyrisky.projected1.lowhigh(:,1);
y1 = in.ortho.both.riskyrisky.projected1.highlow(:,3);

x2 = output.U(:,1);
y2 = output.V(:,1);

b1 = glmfit(x1,y1);
line1 = -8:8;
line1 = b1(1)+(b1(2)*line1);
out.r1_lowhigh = corr(x1,y1);

b2 = glmfit(x2,y2);
line2 = -8:8;
line2 = b2(1)+(b2(2)*line2);
out.r2_lowhigh = corr(x2,y2);

xticks = -8:8;
figure;
hold on;
scatter(x1,y1,'b','o');
plot(xticks,line1,'b');
scatter(x2,y2,'r','+');
plot(xticks,line2,'r');
xlim([-4 4]);
ylim([-4 4]);
