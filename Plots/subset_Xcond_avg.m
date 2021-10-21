function [avg,sem] = subset_Xcond_avg(in)

x(:,1) = in.avg.low;
x(:,2) = in.avg.high;
y(:,1) = in.sem.low;
y(:,2) = in.sem.high;
avg.true = mean(x,2);
sem.true = mean(y,2);
clear x y;

x(:,1) = in.avg.pslow;
x(:,2) = in.avg.pshigh;
y(:,1) = in.sem.pslow;
y(:,2) = in.sem.pshigh;
avg.control = mean(x,2);
sem.control = mean(y,2);
clear x y;

%% Plot
figure;
hold on;
error_high = avg.true+sem.true;
error_low = avg.true-sem.true;
plot(avg.true,'-b','Linewidth',2);
plot(error_low,'-b');
plot(error_high,'-b');
error_high = avg.control+sem.control;
error_low = avg.control-sem.control;
plot(avg.control,'-r','Linewidth',2);
plot(error_low,'-r');
plot(error_high,'-r');

end