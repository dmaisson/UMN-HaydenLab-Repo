figure;
hold on;
R = Behavior(Batman_full,-3,3,.25);
% subplot(521);
plot(R.Bins(:,1),R.Bins(:,3), '-r');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('Area 13')
Beh.B = R;
clear R

R = Behavior(Calvin,-3,3,.25);
% subplot(522);
plot(R.Bins(:,1),R.Bins(:,3), '-g');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('Area 11')
Beh.C = R;
clear R

R = Behavior(Hobbes,-3,3,.25);
% subplot(523);
plot(R.Bins(:,1),R.Bins(:,3), '-b');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('Area 14')
Beh.H = R;
clear R

R = Behavior(Pumbaa_full,-3,3,.25);
% subplot(524);
plot(R.Bins(:,1),R.Bins(:,3), '-c');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('Area 32')
Beh.P = R;
clear R

R = Behavior(Spock,-3,3,.25);
% subplot(525);
plot(R.Bins(:,1),R.Bins(:,3), '-k');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('PCC')
Beh.S = R;
clear R

R = Behavior(Vader,-3,3,.25);
% subplot(526);
plot(R.Bins(:,1),R.Bins(:,3), '-y');
xlabel('EV1 - EV2')
ylabel('% Chose First Offer')
% title('VS')
Beh.V = R;
clear R

hline(50);vline(0,0);