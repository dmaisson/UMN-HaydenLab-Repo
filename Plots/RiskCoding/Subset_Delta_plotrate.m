for iJ = 1:length(in)
    n = size(in{iJ}.low,1);
    ratelow(iJ,1) = (sum(in{iJ}.low(:,2))/n)*100;
    ratehigh(iJ,1) = (sum(in{iJ}.high(:,2))/n)*100;
    temp(iJ,1) = (sum(in{iJ}.pseudolow(:,2))/n)*100;
    temp(iJ,2) = (sum(in{iJ}.pseudohigh(:,2))/n)*100;
end
ratepseudo = nanmean(temp,2);

for iJ = 5:length(in)
    if ratepseudo(iJ,1) == 100
        ratepseudo(iJ,1) = 0;
    end
end

hold on;
plot(ratelow,'Linewidth',2);
plot(ratehigh,'Linewidth',2);
plot(ratepseudo,'Linewidth',2);
legend('low','high','pseudo');
xlabel('size of S (% of total cells)');
ylabel('proportion of significant deltas (%)')