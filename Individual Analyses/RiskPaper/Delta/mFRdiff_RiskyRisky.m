function diff = mFRdiff_RiskyRisky(in,sv,probs)

% setup variable
safe = in.mFR.safe;
ITI = in.mFR.ITI;
svlow = sv.low;
svhigh = sv.high;
x = find(probs == svlow);
low = in.mFR.low(:,x);
x = find(probs == svhigh);
high = in.mFR.high(:,x);
diff.low = abs(safe - low);
diff.high = abs(safe - high);
diff.ITI = abs(ITI - safe);

%run bootstrap on low stakes
for iJ=1:1000 
   rprob = randi(length(probs)-1); %find a random prob
   y = in.mFR.low(:,rprob);
   diff.rand_low(:,iJ) = abs(y - safe); %calculate diff
end
%run bootstrap on high stakes
for iJ=1:1000 
   rprob = randi(length(probs)-1); %find a random prob
   y = in.mFR.high(:,rprob);
   diff.rand_high(:,iJ) = abs(y - safe); %calculate diff
end


% Find p-value for bootstrap comparisons
%     if X is less than 5% of the elements in Y, then p<0.05. (one-tailed, 
%     for two-tailed, it would have to be less than 2.5% of the elements) 
%     if X is less than X%, then p<X  (one tailed) if you sort Y by size, 
%     then the rank of X tells you the p-value
x = sort(diff.rand_low,2);
for iJ = 1:size(x,1)
    y = find(diff.low(iJ,:) < x(iJ,:));
    if isempty(y)
        diff.p.low(iJ,1) = 1;
    else
        diff.p.low(iJ,1) = y(1,1)/1000;
    end
    clear y;
    if diff.p.low(iJ,1) < 0.05
        diff.p.low(iJ,2) = 1;
    else
        diff.p.low(iJ,2) = 0;
    end
end

x = sort(diff.rand_high,2);
for iJ = 1:size(x,1)
    y = find(diff.high(iJ,:) < x(iJ,:));
    if isempty(y)
        diff.p.high(iJ,1) = 1;
    else
        diff.p.high(iJ,1) = y(1,1)/1000;
    end
    clear y;
    if diff.p.high(iJ,1) < 0.05
        diff.p.high(iJ,2) = 1;
    else
        diff.p.high(iJ,2) = 0;
    end
end

diff.rate.low = (sum(diff.p.low(:,2))/length(diff.p.low))*100;
diff.rate.high = (sum(diff.p.high(:,2))/length(diff.p.high))*100;

% Plot the differences
diff.rand_low_mean = mean(diff.rand_low,2);
diff.rand_high_mean = mean(diff.rand_high,2);

diff.delta_change.rand_low = abs((diff.rand_low_mean - diff.ITI))./diff.ITI;
diff.delta_change.rand_high = abs((diff.rand_high_mean - diff.ITI))./diff.ITI;
diff.delta_change.low = abs((diff.low - diff.ITI))./diff.ITI;
diff.delta_change.high = abs((diff.high - diff.ITI))./diff.ITI;

% figure;
hold on;
plot(hist(diff.low,(min(diff.low):range(diff.low)/10 : max(diff.low))));
plot(hist(diff.high,(min(diff.high):range(diff.low)/10 : max(diff.high))));
plot(hist(diff.rand_low_mean,(min(diff.rand_low_mean):range(diff.rand_low_mean)/10:max(diff.rand_low_mean))));
plot(hist(diff.rand_high_mean,(min(diff.rand_high_mean):range(diff.rand_high_mean)/10:max(diff.rand_high_mean))));
plot(hist(diff.ITI,(min(diff.ITI):range(diff.ITI)/10:max(diff.ITI))));
legend("safe-low", "safe-high", "control-low","control-high","ITI-safe");
xlabel("delta")
ylabel("frequency")

figure;
hold on;
plot(hist(diff.delta_change.low,(min(diff.delta_change.low):range(diff.delta_change.low)/10 : max(diff.delta_change.low))));
plot(hist(diff.delta_change.high,(min(diff.delta_change.high):range(diff.delta_change.high)/10 : max(diff.delta_change.high))));
plot(hist(diff.delta_change.rand_low,(min(diff.delta_change.rand_low):range(diff.delta_change.rand_low)/10:max(diff.delta_change.rand_low))));
plot(hist(diff.delta_change.rand_high,(min(diff.delta_change.rand_high):range(diff.delta_change.rand_high)/10:max(diff.delta_change.rand_high))));
legend("safe-low", "safe-high", "control-low","control-high");
xlabel("change from baseline delta")
ylabel("frequency")


end