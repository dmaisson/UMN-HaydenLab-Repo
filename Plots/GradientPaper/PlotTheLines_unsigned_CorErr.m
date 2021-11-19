



dACC.Align(2,:) = x.*fun.Align.R(1,2);
dACC.Align(1,:) = x.*fun.Align.L(1,2);
dACC.Align(3,:) = x.*fun.Align.U(1,2);

dACC.Inhib(2,:) = x.*fun.Inhib.R(1,2);
dACC.Inhib(1,:) = x.*fun.Inhib.L(1,2);
dACC.Inhib(3,:) = x.*fun.Inhib.U(1,2);

%%
figure;
hold on;
ylim([0 0.4]);
scatter(betas.dACC(:,1),betas.dACC(:,2));
plot(x,dACC.Integ(1,:), 'r');
plot(x,dACC.Integ(2,:), 'k');
plot(x,dACC.Integ(3,:), 'r');

figure;
hold on;
ylim([0 0.4]);
scatter(betas.dACC(:,3),betas.dACC(:,5));
plot(x,dACC.Align(1,:), 'r');
plot(x,dACC.Align(2,:), 'k');
plot(x,dACC.Align(3,:), 'r');

figure;
hold on;
ylim([0 0.4]);
scatter(betas.dACC(:,4),betas.dACC(:,5));
plot(x,dACC.Inhib(1,:), 'r');
plot(x,dACC.Inhib(2,:), 'k');
plot(x,dACC.Inhib(3,:), 'r');
