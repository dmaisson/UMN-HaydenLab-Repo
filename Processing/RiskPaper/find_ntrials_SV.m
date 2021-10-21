function [safe,low,high] = find_ntrials_SV(in)

safe = in.subject1.out_safe.safe;
probs = 0:0.05:1;
probs(7) = 0.3;
svlow1 = in.subject1.sv.low;
svhigh1 = in.subject1.sv.high;
x = find(svlow1 == probs);
low.Ep1 = in.subject1.out_safe.low.Ep1{x}.cell;
low.Ep2 = in.subject1.out_safe.low.Ep2{x}.cell;
x = find(svhigh1 == probs);
high.Ep1 = in.subject1.out_safe.high.Ep1{x}.cell;
high.Ep2 = in.subject1.out_safe.high.Ep2{x}.cell;

n1 = length(safe.Ep1);
for iJ = 1:n1
    safetemp1(iJ,1) = length(safe.Ep1{iJ}.vars);
    lowtemp1(iJ,1) = length(low.Ep1{iJ}.vars);
    hightemp1(iJ,1) = length(high.Ep1{iJ}.vars);
end
for iJ = 1:n1
    safetemp2(iJ,1) = length(safe.Ep2{iJ}.vars);
    lowtemp2(iJ,1) = length(low.Ep2{iJ}.vars);
    hightemp2(iJ,1) = length(high.Ep2{iJ}.vars);
end

safe = cat(1,safetemp1,safetemp2);
low = cat(1,lowtemp1,lowtemp2);
high = cat(1,hightemp1,hightemp2);

end