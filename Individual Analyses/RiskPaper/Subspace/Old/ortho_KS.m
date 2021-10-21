function out = ortho_KS(in)

set1 = in.safelow{1};
set2 = in.safelow{2};
[~,out.p.safelow,out.D.safelow] = kstest2(set1,set2);
figure;
subplot 221
hold on
plot(in.safelow{1}(1:10,1),'Linewidth',2);
plot(in.safelow{2}(1:10,1),'Linewidth',2);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe','eq low');

set1 = in.lowsafe{1};
set2 = in.lowsafe{2};
[~,out.p.lowsafe,out.D.lowsafe] = kstest2(set1,set2);
subplot 222
hold on
plot(in.lowsafe{1}(1:10,1),'Linewidth',2);
plot(in.lowsafe{2}(1:10,1),'Linewidth',2);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq low','safe');

set1 = in.safehigh{1};
set2 = in.safehigh{2};
[~,out.p.safehigh,out.D.safehigh] = kstest2(set1,set2);
subplot 223
hold on
plot(in.safehigh{1}(1:10,1),'Linewidth',2);
plot(in.safehigh{2}(1:10,1),'Linewidth',2);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('safe','eq high');

set1 = in.highsafe{1};
set2 = in.highsafe{2};
[~,out.p.highsafe,out.D.highsafe] = kstest2(set1,set2);
subplot 224
hold on
plot(in.highsafe{1}(1:10,1),'Linewidth',2);
plot(in.highsafe{2}(1:10,1),'Linewidth',2);
xlabel('principal component');
ylabel('explained variance (% of total)');
legend('eq high','safe');

end