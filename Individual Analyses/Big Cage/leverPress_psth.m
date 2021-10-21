%% events prep
    
% extract all feeder events timestamps and patchIDs
vars(:,1) = evt.patchID;
vars(:,2) = evt.eventcode;
vars(:,3) = evt.timestamp;

% extract lever press timestamps
leverPress = vars(vars(:,2) == 2,:);

% convert timestamps to seconds (30k fs)
scale = 1000; %puts scale in seconds
% scale = 1; %puts scale in 1ms
leverPress(:,3) = leverPress(:,3)/(30*scale);

%create "trial" windows (start and stop timestampts for +/- 10sec)
window = 4; 
totalTime = window*2;
leverPress(:,4) = leverPress(:,3)-((1000/scale)*window);
leverPress(:,5) = leverPress(:,3)+((1000/scale)*window);

% isolated lever press timestamps by patch ID
patches = unique(leverPress(:,1));
for iJ = 1:length(patches)
    patchPress{iJ,1} = leverPress(leverPress(:,1) == patches(iJ),:);
end

clear evt vars iJ

%% spikes prep
for ii = 1:numfiles
% extract spike timestamps
spikeTimes = cellsOrig{ii}.spk.timestamp{1};

% converst spike timestamps to second (30k fs)
spikeTimes = spikeTimes/(30*scale);
clear spk

% group all spike timestamps within +/- 4 seconds of that lever press
% timestamp into a "trial"
for iJ = 1:size(leverPress,1)
    for iK = 1:size(spikeTimes,1)
        if (spikeTimes(iK,1) >= leverPress(iJ,4)) && ...
                (spikeTimes(iK,1) <= leverPress(iJ,5))
            trialSpikeTimes(iJ,iK) = spikeTimes(iK,1);
        else
            trialSpikeTimes(iJ,iK) = NaN;
        end
    end
end

% calculate FR into bins
for iJ = 1:size(leverPress,1)
    trialTimes(iJ,:) = linspace(leverPress(iJ,4),leverPress(iJ,5),...
        ((1000/scale)*totalTime));
end
psth = zeros(size(trialTimes,1),size(trialTimes,2));
for iJ = 1:size(psth,1) %for each "trial"
    for iK = 1:size(psth,2)-1 %for each 1ms bin
        for iL = 1:size(trialSpikeTimes,2) %for each spike timestamp
            if (trialSpikeTimes(iJ,iL) >= trialTimes(iJ,iK)) && ...
                    (trialSpikeTimes(iJ,iL) < trialTimes(iJ,iK+1)) %if the spike timestamp is greater than the ms bin and less than the next
                psth(iJ,iK) = psth(iJ,iK)+1; %add a spike counter to that ms bin
            end
        end
    end
end
clear iJ iK iL

% gather variables
cell{ii,1}.leverPress = leverPress;
cell{ii,1}.psth = psth;

end

%% plot average across "trials"
figure;
hold on;
for ii = 1:numfiles
    avg_psth = nanmean(cell{ii}.psth,1);

    % plot average FR across trials for each cell
    xticks = (-window:(scale/1000):(window-(scale/1000)));
    plot(xticks,smoothdata((avg_psth*10)));
    ylabel('spikes/sec');
    xlabel('time (s)');
    vline(0,0);
    clearvars -except cell window scale numfiles;
end

%% population
% avg "trial" avgs across cells
for ii = 1:numfiles
    avg_psth(ii,:) = nanmean(cell{ii}.psth,1);
end
avg_cells_psth = nanmean(avg_psth,1);

% plot population average
xticks = (-window:(scale/1000):(window-(scale/1000)));
plot(xticks,smoothdata((avg_cells_psth*10)));
ylabel('spikes/sec');
xlabel('time (s)');
vline(0,0);
