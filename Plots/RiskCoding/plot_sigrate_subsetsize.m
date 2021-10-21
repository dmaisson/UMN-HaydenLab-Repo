function [sigrate,ks] = plot_sigrate_subsetsize(in)

subset.subject1 = in.subject1.subset;
subset.subject2 = in.subject2.subset;

%%
for iJ = 1:length(subset.subject1.p)
    if isempty(subset.subject1.p{iJ})
        sigrate.low(iJ,1) = NaN;
        sigrate.high(iJ,1) = NaN;
        sigrate.pseudolow(iJ,1) = NaN;
        sigrate.pseudohigh(iJ,1) = NaN;
    else
    sigrate.low(iJ,1) = (sum(subset.subject1.p{iJ}.low(:,2))/length(subset.subject1.p{iJ}.low))*100;
    sigrate.high(iJ,1) = (sum(subset.subject1.p{iJ}.high(:,2))/length(subset.subject1.p{iJ}.high))*100;
    sigrate.pseudolow(iJ,1) = (sum(subset.subject1.p{iJ}.pseudolow(:,2))/length(subset.subject1.p{iJ}.pseudolow))*100;
    sigrate.pseudohigh(iJ,1) = (sum(subset.subject1.p{iJ}.pseudohigh(:,2))/length(subset.subject1.p{iJ}.pseudohigh))*100;
    end
    
    if isempty(subset.subject2.p{iJ})
        sigrate.low(iJ,2) = NaN;
        sigrate.high(iJ,2) = NaN;
        sigrate.pseudolow(iJ,2) = NaN;
        sigrate.pseudohigh(iJ,2) = NaN;
    else
    sigrate.low(iJ,2) = (sum(subset.subject2.p{iJ}.low(:,2))/length(subset.subject2.p{iJ}.low))*100;
    sigrate.high(iJ,2) = (sum(subset.subject2.p{iJ}.high(:,2))/length(subset.subject2.p{iJ}.high))*100;
    sigrate.pseudolow(iJ,2) = (sum(subset.subject2.p{iJ}.pseudolow(:,2))/length(subset.subject2.p{iJ}.pseudolow))*100;
    sigrate.pseudohigh(iJ,2) = (sum(subset.subject2.p{iJ}.pseudohigh(:,2))/length(subset.subject2.p{iJ}.pseudohigh))*100;
    end
end

sigrate.avg.low = nanmean(sigrate.low,2);
sigrate.avg.high = nanmean(sigrate.high,2);
sigrate.avg.pseudolow = nanmean(sigrate.pseudolow,2);
sigrate.avg.pseudohigh = nanmean(sigrate.pseudohigh,2);

sigrate.avg.avglow = nanmean(sigrate.avg.low);
sigrate.avg.semlow = nanstd(sigrate.avg.low)/sqrt(length(sigrate.avg.low));

sigrate.avg.avghigh = nanmean(sigrate.avg.high);
sigrate.avg.semhigh = nanstd(sigrate.avg.high)/sqrt(length(sigrate.avg.high));

sigrate.avg.avgpseudolow = nanmean(sigrate.avg.pseudolow);
sigrate.avg.sempseudolow = nanstd(sigrate.avg.pseudolow)/sqrt(length(sigrate.avg.pseudolow));

sigrate.avg.avgpseudohigh = nanmean(sigrate.avg.pseudohigh);
sigrate.avg.sempseudohigh = nanstd(sigrate.avg.pseudohigh)/sqrt(length(sigrate.avg.pseudohigh));

subplot 121
hold on
plot(sigrate.avg.low,'Linewidth',2);
plot(sigrate.avg.pseudolow,'Linewidth',2);

subplot 122
hold on
plot(sigrate.avg.high,'Linewidth',2);
plot(sigrate.avg.pseudohigh,'Linewidth',2);

[~,ks.low] = kstest2(sigrate.avg.low,sigrate.avg.pseudolow);
[~,ks.high] = kstest2(sigrate.avg.high,sigrate.avg.pseudohigh);

end