function [avg, p] = mFRdiff_SafeRisky_poscontrol(in)

warning('off','MATLAB:colon:nonIntegerIndex');

for iL = 1:1000
%     x = randi(length(probs));
% low = in.low.Ep1{x}.cell;
%     x = randi(length(probs));
% high = in.high.Ep1{x}.cell;
low = in.eqlow.Ep1;
high = in.eqhigh.Ep1;
n = length(low);
    for iJ = 1:n
        n1 = size(low{iJ}.psth,1);
        n2 = size(low{iJ}.psth,2);
        for iK = 1:n1
            temp1(iK,1:n2) = NaN;
            temp2(iK,1:n2) = NaN;
            if rem(iK,2) == 1
                temp1(iK,:) = low{iJ}.psth(iK,:);
            elseif rem(iK,2) == 0
                temp2(iK,:) = low{iJ}.psth(iK,:);
            end
        end
        sub1 = nanmean(nanmean(temp1,2));
        sub2 = nanmean(nanmean(temp2,2));
        lowsub(iJ,iL) = abs(sub1 - sub2);
%         clear sub1 sub2 temp1 temp2;
    end
    for iJ = 1:n
        n1 = size(high{iJ}.psth,1);
        n2 = size(high{iJ}.psth,2);
        for iK = 1:n1
            temp1(iK,1:n2) = NaN;
            temp2(iK,1:n2) = NaN;
            if rem(iK,2) == 1
                temp1(iK,:) = high{iJ}.psth(iK,:);
            elseif rem(iK,2) == 0
                temp2(iK,:) = high{iJ}.psth(iK,:);
            end
        end
        sub1 = nanmean(nanmean(temp1));
        sub2 = nanmean(nanmean(temp2));
        highsub(iJ,iL) = abs(sub1 - sub2);
%         clear sub1 sub2 temp1 temp2;
    end
end

lowsub = sort(lowsub,2);
highsub = sort(highsub,2);
clear low high safe iJ iL iK r n n1 n2;

for iJ = 1:length(in.safe.Ep1)
    safe(iJ,1) = nanmean(nanmean(in.safe.Ep1{iJ}.psth,2));
    eqlow(iJ,1) = nanmean(nanmean(in.eqlow.Ep1{iJ}.psth,2));
    eqhigh(iJ,1) = nanmean(nanmean(in.eqhigh.Ep1{iJ}.psth,2));
end
difflow = abs(nanmean(lowsub,2) - eqlow);
diffhigh = abs(nanmean(highsub,2) - eqhigh);
clear low high safe x;

control(1,:) = nanmean(lowsub);
control(2,:) = nanmean(highsub);
avg.difflow = nanmean(difflow);
avg.diffhigh = nanmean(diffhigh);
avg.control = nanmean(control);
avg.m_control = nanmean(avg.control);

p.low = 1-(length(find(avg.difflow > sort(avg.control)))/1000);
p.high = 1-(length(find(avg.diffhigh > sort(avg.control)))/1000);

end