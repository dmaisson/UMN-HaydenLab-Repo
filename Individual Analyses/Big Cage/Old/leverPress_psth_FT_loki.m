%% read in data
addpath /mnt/scratch/_code/fieldtrip-20210212;
ft_defaults;

cd '/mnt/Processed_Data_2/Data_done_new';
eventSource = input('date (monk_YYYY-MM-DD_run_task): ');
cd(eventSource);
load('evt.mat');

spkSource = input('ephys source files: ');
cd(spkSource); cd mat/SPK/SPK;
spkFiles = dir('spk*'); 
numfiles = length(spkFiles);
cellsOrig = cell(numfiles,1);

[numbers, strings, raw] = xlsread...
    ('Yoda-SpikeSorting.xlsx',...
    'DailyArea');
date = input('date (char as MM/DD/YYYY): ');
for iJ = 2:size(strings,2)
    x = strings{2,iJ};
    if sum(date == x) == 10
        dateidx = iJ;
    end
end
arealabels = numbers(:,dateidx);

for k = 1:numfiles 
  cellsOrig{k,1} = load(spkFiles(k).name); 
  parts=strsplit(spkFiles(k).name, {'nt', 'ch1'});
  cellsOrig{k,2} = str2num(parts{2});
  cellsOrig{k,3} = arealabels(cellsOrig{k,2},1);
end

clearvars -except evt cellsOrig numfiles;

%% setup
% extract all feeder events timestamps and patchIDs
vars(:,1) = evt.patchID;
vars(:,2) = evt.eventcode;
vars(:,3) = evt.timestamp;

% extract lever press timestamps
leverPress = vars(vars(:,2) == 2,:);

%% psth
for ii = 1:numfiles
    spkCount(ii,1) = size(cellsOrig{ii}.spk.time{1},1);
    %make trials
    spk = cellsOrig{ii}.spk;
    fs = 30000;
    cfg.trl(:,1) = leverPress(:,3)-(fs*10);
    cfg.trl(:,2) = leverPress(:,3)+(fs*10);
    cfg.trl(:,3) = -(fs*10);
    cfg.trlunit = 'timestamps';
    cfg.timestampspersecond = fs;
    cfg.hdr = spk.hdr;
    spk = ft_spike_maketrials(cfg,spk);
    spk = rmfield(spk,'trialinfo');
    
    %psth and raster
    clear cfg;
    cfg.binsize = 0.5;
    cfg.outputunit = 'rate';
    cfg.spikechannel = 'all';
    cfg.vartriallen = 'yes';
    cfg.latency = 'maxperiod';
    cfg.keeptrials = 'yes';
    cfg.trials = 'all';
    psth = ft_spike_psth(cfg, spk);
    cfg.spikechannel = 'all';
    cfg.latency = 'maxperiod';
    cfg.linewidth = 1;
    cfg.cmapneurons = 'auto';
    cfg.spikelength = 1;
    cfg.trialborders = 'yes';
    cfg.plotselection = 'no';
    cfg.topplotsize = 0.7;
    cfg.topplotfunc = 'line';
    cfg.errorbars = 'no';
    cfg.interactive = 'yes';
    cfg.trials = 'all';
    cfg = ft_spike_plot_raster(cfg, spk, psth);
    saveas(figure(1),num2str(cellsOrig{ii,2}),'jpeg');
    close(figure(1));
    
    %gather data
    cell{ii,1}.leverPress = leverPress;
    cell{ii,1}.psth = psth;
    cell{ii,1}.cfg = cfg;
    cell{ii,2} = cellsOrig{ii,2};
    cell{ii,3} = cellsOrig{ii,3};
    cell{ii,4} = spkCount(ii,1);
    
end
clearvars -except cell spkSource spkCount;

%% plot population avg
figure;
for ii = 1:length(cell)
    for iJ = 1:size(cell{ii}.psth.trial,3)
        temp(:,iJ) = cell{ii}.psth.trial(:,:,iJ);
    end
    spkSec(ii,:) = nanmean(temp);
end
spkSec_pop = nanmean(spkSec);
xticks = linspace(cell{1}.psth.time(1),cell{1}.psth.time(end),size(spkSec_pop,2));
plot(xticks,smoothdata(spkSec_pop));
ylabel('spikes/sec');
xlabel('time (s)');
clearvars -except cell spkSource pop spkCount;

saveas(figure(1),'_levpressPSTH_pop','jpeg');

%% Spike Counts

spkCount_rates = (0:250:1000)';
spkCount_rates(:,2) = 0;
spkCount_rates(:,3) = 0;

for iJ = 1:size(spkCount_rates,1)
    if iJ < size(spkCount_rates,1)
        for iK = 1:size(spkCount,1)
            if (spkCount(iK,1) > spkCount_rates(iJ,1)) && (spkCount(iK,1) <= spkCount_rates(iJ+1,1))
                spkCount_rates(iJ,2) = spkCount_rates(iJ,2)+1;
            end
        end
    elseif iJ == size(spkCount_rates,1)
        for iK = 1:size(spkCount,1)
            if spkCount(iK,1) > spkCount_rates(iJ,1)
                spkCount_rates(iJ,2) = spkCount_rates(iJ,2)+1;
            end
        end
    end    
    spkCount_rates(iJ,3) = (spkCount_rates(iJ,2)/size(spkCount,1))*100;
end
clear spkCount iJ iK

%% save
clearvars -except spkSource cell spkCount_rates
save ('_levpressPSTH.mat','-v7.3');