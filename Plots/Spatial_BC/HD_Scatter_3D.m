one_day = head_direction{40};
spikeTimes = OFC{11}.spikeTimes(:,1);
hold on;
polarscatter3(one_day.yaw,one_day.pitch,one_day.pitch_radius,'x','k','MarkerEdgeAlpha',0.1);

spike_yaw = NaN(size(one_day.yaw,1),1);
spike_pitch = NaN(size(one_day.yaw,1),1);
spike_pitch_radius = NaN(size(one_day.yaw,1),1);
cycles = (1:size(spike_pitch,1))';
cycles(end+1,1) = spike_pitch(end)+999;
for iA = 1:size(spike_pitch,1)
    for iB = 1:size(spikeTimes,1)
        if spikeTimes(iB,1) >= iA && spikeTimes(iB,1) < (iA+1)
            spike_pitch(iA,1) = one_day.pitch(iA,1);
            spike_pitch_radius(iA,1) = one_day.pitch_radius(iA,1);
            spike_yaw(iA,1) = one_day.yaw(iA,1);
        end
    end
end
polarscatter3(spike_yaw,spike_pitch,spike_pitch_radius,'o','r','LineWidth',1,'MarkerFaceColor', 'r');