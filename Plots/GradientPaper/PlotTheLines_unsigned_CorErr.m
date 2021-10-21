%%
betas.dACC(:,1) = Results.data24.Epoch1.b.prob1;
betas.dACC(:,2) = Results.data24.Epoch1.b.size1;
betas.dACC(:,3) = Results.data24.Epoch1.b.EV1;
betas.dACC(:,4) = Results.data24.Epoch2.b.EV1;
betas.dACC(:,5) = Results.data24.Epoch2.b.EV2;
betas.dACC = abs(betas.dACC);
x = (0:0.025:0.4);
%%
[fun.Integ.R,~,fun.Integ.L,fun.Integ.U] = corrcoef(betas.dACC(:,1),betas.dACC(:,2));
[fun.Align.R,~,fun.Align.L,fun.Align.U] = corrcoef(betas.dACC(:,3),betas.dACC(:,5));
[fun.Inhib.R,~,fun.Inhib.L,fun.Inhib.U] = corrcoef(betas.dACC(:,4),betas.dACC(:,5));

%%
dACC.Integ(2,:) = x.*fun.Integ.R(1,2);
dACC.Integ(1,:) = x.*fun.Integ.L(1,2);
dACC.Integ(3,:) = x.*fun.Integ.U(1,2);

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
