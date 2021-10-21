function [auto,decay,tau] = BC_timescales_spikeAligned(area)

for iJ = 1:size(area,1)
    spikeSeries(iJ,:) = area{iJ,1}.spikeSeries;
end

%% Timescales - original spikeSeries
% Correlation between data @ time i and itself @ time j
Fs = 30;
bin_size = (1/Fs)*1000; %current bin size in ms
max_lag = round(360/bin_size); % in number of bins
lag(:,1) = (1:max_lag); % 20ms - 360ms
window = (Fs*60)*10;
windows = size(spikeSeries,2)/window;
last_window = 1;
for iI = 1:windows
    curr_window = window*iI;
    curr_series = spikeSeries(:,last_window:curr_window);
    for iJ = 1:size(lag,1) % for each difference in time between bins (from 40-360ms)
        for iK = 1:(size(curr_series,2)-lag(iJ)) % for each bin
            temp(:,iK) = corr(curr_series(:,iK),curr_series(:,iK+lag(iJ))); % correlate bin i and bin j, where i and j are separate by a time distance defined by lag
        end
        auto(iI,iJ) = nanmean(temp,2);
    end
    last_window = curr_window+1;
end
lag(1:(lag(end)),1) = (33.3:33.3:(lag(end)*33.3));
x0 = [1 0 0];
decay_fun = fittype( @(A,b,B,x) (A*(exp((x*b))+B)) );
for iJ = 1:size(auto,1)
    decay{iJ,1} = fit(lag,auto(iJ,:)',decay_fun, 'StartPoint', x0);
    A = decay{iJ}.A;
    b = decay{iJ}.b;
    B = decay{iJ}.B;
    tau(iJ,1) = 1/((-1)*b);
end
clearvars -except data resSeries spikeSeries tau auto decay;
