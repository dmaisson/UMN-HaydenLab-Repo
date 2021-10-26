for iA = 1:size(OFC,1)
    psth{iA,1} = SpikeTime_trialization(OFC{iA},0,4);
end

[timescales_spiketimesTrials] = Timescales(psth,20);

for iA = 1:size(OFC,1)
    psth{iA,1} = LeverEvent_trialization(OFC{iA},0,2);
end

[timescales_LeverPressTrials] = Timescales(psth,20);