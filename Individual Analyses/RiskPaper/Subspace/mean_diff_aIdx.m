function [m,sd] = mean_diff_aIdx(in)

low = in.ortho.both.aIdx(1,1);
high = in.ortho.both.aIdx(1,2);
control = in.ortho.both.control;

for iJ = 1:length(control)
    shuf_low(iJ,:) = control(iJ,1) - low;
    shuf_high(iJ,:) = control(iJ,1) - high;
end

m.shuflow = nanmean(shuf_low);
sd.shuflow = nanstd(shuf_low);
m.shufhigh = nanmean(shuf_high);
sd.shufhigh = nanstd(shuf_high);

end