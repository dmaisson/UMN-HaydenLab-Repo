for iA = 1:size(OFC,1)
    psth{iA,1} = SpikeTime_trialization(OFC{iA},0,4);
end

[timescales_spiketimesTrials] = Timescales(psth,20);

for iA = 1:size(OFC,1)
    psth{iA,1} = LeverEvent_trialization(OFC{iA},0,2);
end

[timescales_LeverPressTrials] = Timescales(psth,20);

%%
for iA = 1:size(OFC,1)
    days{iA,1} = OFC{iA}.day;
end
days = unique(days);

for iA = 1:size(days,1)
    for iB = 1:size(OFC,1)
        if sum(days{iA} == OFC{iB}.day) == 10
            days{iA,2}{iB,1} = OFC{iB};
        end
    end
    for iB = size(days{iA,2},1):-1:1
        if isempty(days{iA,2}{iB,1})
            days{iA,2}(iB,:) = [];
        end
    end
    lfp = 0; trial_length = 2; epochs = 30; res = 0;
    psth{iA,1} = Epoch_trialization(days{iA,2},lfp,trial_length,epochs,res);
    lagmax = 10; plt = 0;
    timescales_epochs{iA,1} = Timescales_epochs(psth{iA,1},lagmax,plt);
end

for iA = 1:size(timescales_epochs,1)
    for iB = 1:size(timescales_epochs{iA}.tau,1)
        taus(iA,iB) = timescales_epochs{iA}.tau{iB};
    end
end
plot(taus,'LineWidth',1);
ylabel('timescale (tau)');
xlabel('epoch (1-minute bins)');