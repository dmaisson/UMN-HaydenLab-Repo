function diff = mFRdiff_SafeRisky_Ep2(in,probs)

% setup variable
for iJ = 1:length(in.safe.Ep2)
    x = nanmean(in.safe.Ep2{iJ}.psth,2);
    safe(iJ,1) = nanmean(x);
    clear x;
    x = nanmean(in.eqlow.Ep2{iJ}.psth,2);
    low(iJ,1) = nanmean(x);
    clear x;
    x = nanmean(in.eqhigh.Ep2{iJ}.psth,2);
    high(iJ,1) = nanmean(x);
    clear x;
    for iK = 1:length(probs)
        x = nanmean(in.low.Ep2{iK}.cell{iJ}.psth,2);
        mFR.low(iJ,iK) = nanmean(x);
        clear x;
        x = nanmean(in.high.Ep2{iK}.cell{iJ}.psth,2);
        mFR.high(iJ,iK) = nanmean(x);
        clear x;
    end
end
diff.low = abs(safe - low);
diff.high = abs(safe - high);

%run bootstrap on low stakes
for iJ=1:1000 
   rprob = randi(length(probs)); %find a random prob
   y = mFR.low(:,rprob);
   diff.rand_low(:,iJ) = abs(safe - y); %calculate diff
end
%run bootstrap on high stakes
for iJ=1:1000 
   rprob = randi(length(probs)); %find a random prob
   y = mFR.high(:,rprob);
   diff.rand_high(:,iJ) = abs(safe - y); %calculate diff
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
    if round(diff.p.low(iJ,1),2) < 0.05
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
    if round(diff.p.high(iJ,1),2) < 0.05
        diff.p.high(iJ,2) = 1;
    else
        diff.p.high(iJ,2) = 0;
    end
end

diff.rate.low = (sum(diff.p.low(:,2))/length(diff.p.low))*100;
diff.rate.high = (sum(diff.p.high(:,2))/length(diff.p.high))*100;
diff.rand_low_mean = mean(diff.rand_low,2);
diff.rand_high_mean = mean(diff.rand_high,2);

end