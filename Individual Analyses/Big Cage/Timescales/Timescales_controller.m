for iA = 1:size(OFC,1)
    psth{iA,1} = SpikeTime_trialization(OFC{iA},0,4);
end

[timescales_spiketimesTrials] = Timescales(psth,20);

for iA = 1:size(OFC,1)
    psth{iA,1} = LeverEvent_trialization(OFC{iA},0,2);
end

[timescales_LeverPressTrials] = Timescales(psth,20);


psth = Epoch_trialization(OFC,0,2,100);

[timescales_epochs] = Timescales_epochs(psth,20);

for iA = 1:size(timescales_epochs.tau,1)
    taus(iA,1) = timescales_epochs.tau{iA};
end
plot(taus,'LineWidth',1);
ylabel('timescale (tau)');
xlabel('epoch (1-minute bins)');