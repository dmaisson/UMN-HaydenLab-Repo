ep1spk = ep1spk (:,100:399);
col_spk = FR_CollapseBins(ep1spk,5);

n1 = size(col_spk,1);
n2 = size(col_spk,2);

low(1:n1,1:n2) = NaN;
high(1:n1,1:n2) = NaN;
safe(1:n1,1:n2) = NaN;

for iJ = 1:n1
    if ep1tr(iJ,2) == 2 
        low(iJ,:) = col_spk(iJ,:).*5;
    elseif ep1tr(iJ,5) == 2
        low(iJ,:) = col_spk(iJ,:).*5;
    elseif ep1tr(iJ,2) == 3
        high(iJ,:) = col_spk(iJ,:).*5;
    elseif ep1tr(iJ,5) == 3
        high(iJ,:) = col_spk(iJ,:).*5;
    elseif ep1tr(iJ,2) == 1
        safe(iJ,:) = col_spk(iJ,:).*5;
    elseif ep1tr(iJ,5) == 1
        safe(iJ,:) = col_spk(iJ,:).*5;
    end
end

mLow = smoothdata(nanmean(low));
mLowEr = (nanstd(low))/sqrt(n1);
mLow_upper = (mLow+mLowEr);
mLow_lower = (mLow-mLowEr);
mHigh = smoothdata(nanmean(high));
mHighEr = (nanstd(high))/sqrt(n1);
mHigh_upper = (mHigh+mHighEr);
mHigh_lower = (mHigh-mHighEr);
mSafe = smoothdata(nanmean(safe));
mSafeEr = (nanstd(safe))/sqrt(n1);
mSafe_upper = (mSafe+mSafeEr);
mSafe_lower = (mSafe-mSafeEr);
xticks = -1:0.1:4.9;

figure;
hold on;
plot(xticks,mLow);
plot(xticks,mLow_upper);
plot(xticks,mLow_lower);

figure;
hold on;
plot(xticks,mHigh);
plot(xticks,mHigh_upper);
plot(xticks,mHigh_lower);

figure;
hold on;
plot(xticks,mSafe);
plot(xticks,mSafe_upper);
plot(xticks,mSafe_lower);

figure;
hold on;
plot(xticks,mLow,'Linewidth',2);
plot(xticks,mHigh,'Linewidth',2);
plot(xticks,mSafe,'Linewidth',2);
