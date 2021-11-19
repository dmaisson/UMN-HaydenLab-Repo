figure;
line_lim = 1;
ymax = 5;
scatter(pop.VS.safe_betas,abs(pop.VS.med_betas)); hold on;
[Line] = BestFitLines_unsigned_saferisky(pop.VS.safe_betas,abs(pop.VS.med_betas),0,line_lim);
plot(Line.samples,Line.output);
ylim([0 ymax]);
clear Line

[R,~,L,U] = corrcoef(pop.VS.safe_betas,abs(pop.VS.med_betas));

line2plot(2,:) = abs(pop.VS.med_betas).*R(1,2);
line2plot(1,:) = abs(pop.VS.med_betas).*L(1,2);
line2plot(3,:) = abs(pop.VS.med_betas).*U(1,2);

figure;
hold on;
ylim([0 ymax]);
plot(abs(pop.VS.med_betas),line2plot(1,:), 'r');
plot(abs(pop.VS.med_betas),line2plot(2,:), 'k');
plot(abs(pop.VS.med_betas),line2plot(3,:), 'r');
clear R L U line2plot

figure;
scatter(pop.VS.safe_betas,abs(pop.VS.high_betas)); hold on;
[Line] = BestFitLines_unsigned_saferisky(pop.VS.safe_betas,abs(pop.VS.high_betas),0,line_lim);
plot(Line.samples,Line.output);
ylim([0 ymax]);
clear Line

[R,~,L,U] = corrcoef(pop.VS.safe_betas,abs(pop.VS.high_betas));

line2plot(2,:) = abs(pop.VS.high_betas).*R(1,2);
line2plot(1,:) = abs(pop.VS.high_betas).*L(1,2);
line2plot(3,:) = abs(pop.VS.high_betas).*U(1,2);

figure;
hold on;
ylim([0 ymax]);
plot(abs(pop.VS.high_betas),line2plot(1,:), 'r');
plot(abs(pop.VS.high_betas),line2plot(2,:), 'k');
plot(abs(pop.VS.high_betas),line2plot(3,:), 'r');
clear R L U line2plot
