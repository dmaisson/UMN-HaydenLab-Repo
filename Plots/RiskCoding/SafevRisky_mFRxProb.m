figure; hold on;
xticks = (0:20:480);
plot(xticks,Ep1.mFR.low{1}.twenty)
plot(xticks,Ep1.mFR.low{1}.fourty)
plot(xticks,Ep1.mFR.low{1}.sixty)
plot(xticks,Ep1.mFR.low{1}.eighty)
plot(xticks,Ep1.mFR.low{1}.hund)
legend("Prob:0-20%","Prob:20-40%","Prob:40-60%","Prob:60-80%","Prob:80-100%");
title("Low Offer - Epoch 1")
xlabel("Time in ms")
ylabel("Spikes per second")