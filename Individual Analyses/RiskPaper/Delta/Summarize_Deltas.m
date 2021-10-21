low = cat(1,VS_Results.subject1.diff.low,VS_Results.subject2.diff.low);
high = cat(1,VS_Results.subject1.diff.high,VS_Results.subject2.diff.high);
randlow = cat(1,VS_Results.subject1.diff.rand_low,VS_Results.subject2.diff.rand_low);
randhigh = cat(1,VS_Results.subject1.diff.rand_high,VS_Results.subject2.diff.rand_high);

n = length(low);
mLow = nanmean(low);
semLow = nanstd(low)/sqrt(n);
mRandLow = nanmean(nanmean(randlow,2));
semRandLow = nanstd(nanmean(randlow,2))/sqrt(n);

mHigh = nanmean(high);
semHigh = nanstd(high)/sqrt(n);
mRandHigh = nanmean(nanmean(randhigh,2));
semRandHigh = nanstd(nanmean(randhigh,2))/sqrt(n);

pos_control = cat(1,VS_Results.subject1.delta_poscont.avg.control,VS_Results.subject2.delta_poscont.avg.control);
m_cont = nanmean(nanmean(pos_control));
sem_cont = nanstd(nanmean(pos_control));

