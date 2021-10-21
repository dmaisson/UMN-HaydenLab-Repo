function out = plot_population_tuning(data,token)

%% separate trials
for iJ = 1:size(data,1)
    for iK = 1:size(data{iJ}.vars,1)
        if data{iJ}.vars(iK,3) >= data{iJ}.vars(iK,6)
            ep1{iJ,1}(iK,:) = Z_score(data{iJ}.psth(iK,100:299));
            ep2{iJ,1}(iK,1:200) = NaN;
        elseif data{iJ}.vars(iK,6) >= data{iJ}.vars(iK,3)
            ep2{iJ,1}(iK,:) = Z_score(data{iJ}.psth(iK,100:299));
            ep1{iJ,1}(iK,1:200) = NaN;
        end
    end
end

%% Calculate mFR across time, collapsed across all trials for all neurons
for iJ = 1:size(data,1)
    ep1_avg(iJ,:) = abs(nanmean(ep1{iJ}));
    ep2_avg(iJ,:) = abs(nanmean(ep2{iJ}));
end

ep1_pop_avg = FR_CollapseBins(nanmean(ep1_avg),5);
ep2_pop_avg = FR_CollapseBins(nanmean(ep2_avg),5);
ep1_pop_SEM = FR_CollapseBins((nanstd(ep1_avg)/sqrt(length(ep1_avg))),5);
ep2_pop_SEM = FR_CollapseBins((nanstd(ep2_avg)/sqrt(length(ep1_avg))),5);

out.ep1_pop_avg = ep1_pop_avg;
out.ep2_pop_avg = ep2_pop_avg;
out.ep1_pop_sem = ep1_pop_SEM;
out.ep2_pop_sem = ep2_pop_SEM;

%% plot
x = -1:0.1:2.9;

figure;
hold on;
sempos = ep1_pop_avg + ep1_pop_SEM;
semneg = ep1_pop_avg - ep1_pop_SEM;
plot(x,smoothdata(ep1_pop_avg),'Linewidth',2);
plot(x,smoothdata(sempos),'Linewidth',1);
plot(x,smoothdata(semneg),'Linewidth',1);
sempos = ep2_pop_avg + ep2_pop_SEM;
semneg = ep2_pop_avg - ep2_pop_SEM;
plot(x,smoothdata(ep2_pop_avg),'Linewidth',2);
plot(x,smoothdata(sempos),'Linewidth',1);
plot(x,smoothdata(semneg),'Linewidth',1);
xlabel('times (s)');
ylabel('mean firing rate (spikes/second)');
if token == 0
    vline(0,0);
    vline(1,0);
    vline(2,0);
elseif token == 1
    vline(0,0);
    vline(0.75,0);
    vline(1.5,0);
end

end