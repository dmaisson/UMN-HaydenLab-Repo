%% read data
spkFiles = dir('spk*'); 
numfiles = length(spkFiles);
cellsOrig = cell(numfiles,1);

[numbers, strings, raw] = xlsread('Yoda-SpikeSorting.xlsx','DailyArea');
date = input('date (char as MM/DD/YYYY): ');
for iJ = 2:size(strings,2)
    x = strings{1,iJ};
    if sum(date == x) == 10
        dateidx = iJ;
    end
end
arealabels = numbers(:,dateidx);

for k = 1:numfiles 
  cellsOrig{k,1} = load(spkFiles(k).name); 
  temp = strsplit(spkFiles(k).name, 'nt');
  parts = strsplit(temp{2}, 'ch1');
  cellsOrig{k,2} = str2num(parts{1});
  cellsOrig{k,3} = arealabels(cellsOrig{k,2},1);
end

clearvars -except evt cellsOrig numfiles;

%% calculate center of mass
% do this using preproccess on Loki then import data_proc
proc = dir('yo*');
load(proc(2).name);

% idenify timestamps for occupancy in spatial bins
com = data_proc.com;
len = 180000 - size(com,1);
if len > 0
    for iJ = size(com,1):size(com,1)+len
        com(iJ,:) = NaN;
    end
end
x = com(:,1);
y = com(:,3);
z = com(:,2);

move_Times = ((0:size(com,1)-1)/30)'; %time in seconds

%% map spike timestamps onto location x,y
for iJ = 1:size(cellsOrig,1)
    neuron{iJ,1} = cellsOrig{iJ}.spk.timestamp{1}/30000;
    for iK = 1:size(neuron{iJ,1},1)
        for iL = 1:size(move_Times,1)-1
            if (neuron{iJ,1}(iK,1) > move_Times(iL,1)) && (neuron{iJ,1}(iK,1) < move_Times(iL+1,1))
                temp(iL,1) = 1;
            else
                temp(iL,1) = NaN;
            end
        end
        idx = find(~isnan(temp));
        if isempty(idx)
            neuron{iJ,1}(iK,2) = NaN;
            neuron{iJ,1}(iK,3) = NaN;
            neuron{iJ,1}(iK,4) = NaN;
        else
            neuron{iJ,1}(iK,2) = x(idx);
            neuron{iJ,1}(iK,3) = y(idx);
            neuron{iJ,1}(iK,4) = z(idx);
        end
    end
end

%% bin 2D space into Xcm^2
tile_size = 10;
axisxmin = -4;
axismax = 4;
axis_segments = tile_size+1;
div = linspace(axisxmin, axismax, axis_segments);
div(end+1) = axismax+1;
XY_mat = zeros(tile_size+1);

% number of frames spent in each spatial bin
for iJ = 1:size(com,1)
    for iK = 1:size(div,2) % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2) %check y coordinate
                if com(iJ,3) >= div(1,iL) && com(iJ,3) < div(1,iL+1)
                    XY_mat(iK,iL) = XY_mat(iK,iL) + 1; % add a frame counter
                end
            end
        end
    end
end

XY_mat = XY_mat./30; % amount of time (s) spent in a given spatial bin

% spatial_bins = cell([((length(x_div)-1)^2) 1]);
for iI = 1:size(neuron,1)
    cell_mat = zeros(tile_size+1);
    cell = neuron{iI};
    for iJ = 1:size(cell,1)
        for iK = 1:size(div,2) % check x coordinate
            if cell(iJ,2) >= div(1,iK) && cell(iJ,2) < div(1,iK+1)
                for iL = 1:size(div,2) %check y coordinate
                    if cell(iJ,3) >= div(1,iL) && cell(iJ,3) < div(1,iL+1)
                        cell_mat(iK,iL) = cell_mat(iK,iL) + 1; % add a frame counter
                    end
                end
            end
        end
    end

    rate_mat = cell_mat./XY_mat;
    for iJ = 1:size(rate_mat,1)
        for iK = 1:size(rate_mat,2)
            if isnan(rate_mat(iJ,iK))
                rate_mat(iJ,iK) = 0;
            end
        end
    end
    neuron{iI,2} = rate_mat;
    space_mat{iI,1} = XY_mat;
    space_mat{iI,2} = cell_mat;
end

%% 3D place field
for iI = 1:tile_size+1
    XYZ_mat(:,:,iI) = zeros(tile_size+1);
end

% number of frames spent in each spatial bin
for iJ = 1:size(com,1)
    for iK = 1:size(div,2) % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2) %check y coordinate
                if com(iJ,3) >= div(1,iL) && com(iJ,3) < div(1,iL+1)
                    for iM = 1:size(div,2) %check z coordinate
                        if com(iJ,2) >= div(1,iM) && com(iJ,2) < div(1,iM+1)
                            XYZ_mat(iK,iL,iM) = XYZ_mat(iK,iL,iM) + 1; % add a frame counter
                        end
                    end
                end
            end
        end
    end
end

XYZ_mat = XYZ_mat./30; % amount of time (s) spent in a given spatial bin

% spatial_bins = cell([((length(x_div)-1)^2) 1]);
for iI = 1:size(neuron,1)
    for iN = 1:tile_size+1
        cell_mat_3D(:,:,iN) = zeros(tile_size+1);
    end
    cell = neuron{iI};
    for iJ = 1:size(cell,1) %for each spike time
        for iK = 1:size(div,2) % check x coordinate
            if cell(iJ,2) >= div(1,iK) && cell(iJ,2) < div(1,iK+1)
                for iL = 1:size(div,2) %check y coordinate
                    if cell(iJ,3) >= div(1,iL) && cell(iJ,3) < div(1,iL+1)
                        for iM = 1:size(div,2) %check z coordinate
                            if cell(iJ,4) >= div(1,iM) && cell(iJ,4) < div(1,iM+1)
                                cell_mat_3D(iK,iL,iM) = cell_mat_3D(iK,iL,iM) + 1; % add a frame counter
                            end
                        end
                    end
                end
            end
        end
    end

    rate_mat_3D = cell_mat_3D./XYZ_mat;
    for iJ = 1:size(rate_mat_3D,1)
        for iK = 1:size(rate_mat_3D,2)
            for iL = 1:size(rate_mat_3D,3)
                if isnan(rate_mat_3D(iJ,iK,iL))
                    rate_mat_3D(iJ,iK,iL) = 0;
                end
            end
        end
    end
    neuron{iI,3} = rate_mat_3D;
end

%% find significant place cells (significant spatial tuning) - 2D
% information = sum_across_bins((probability of being in bin i)*((mFR in
% bin i)/(mFR of cell))*log2*((mFR in
% bin i)/(mFR of cell))

% formally:
% prob_i = prob of being in bin i (i.e. % of time spent in bin)
prob_i = XY_mat./sum(XY_mat(:));
for iI = 1:size(neuron,1)
    % mFR_i = mean firing rate in bin i
    mFR_i = neuron{iI,2};
    % mFR = overal; mean firing rate for the neuron
    mFR = mean(neuron{iI,2}(:));
    for iJ = 1:size(mFR_i,1)
        for iK = 1:size(mFR_i,2)
            info_in_bin(iJ,iK) = prob_i(iJ,iK)*(mFR_i(iJ,iK)/mFR)*log2(mFR_i(iJ,iK)/mFR);
            if isnan(info_in_bin(iJ,iK))
                info_in_bin(iJ,iK) = 0;
            end
        end
    end
% so:
% information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
    neuron{iI,4} = sum(info_in_bin(:));
end

% shuffle
for iH = 1:size(neuron,1)
    prob_i = XY_mat./sum(XY_mat(:));
    for iI = 1:10000
        % mFR_i = mean firing rate in bin i
        mFR_i = neuron{iH,2};
        % mFR = overal; mean firing rate for the neuron
        mFR = mean(neuron{iH,2}(:));
        rand1 = randi(size(prob_i,1));
        rand2 = randi(size(prob_i,2));
        for iJ = 1:size(mFR_i,1)
            for iK = 1:size(mFR_i,2)
                info_in_bin(iJ,iK) = prob_i(rand1,rand2)*(mFR_i(iJ,iK)/mFR)*log2(mFR_i(iJ,iK)/mFR);
                if isnan(info_in_bin(iJ,iK))
                    info_in_bin(iJ,iK) = 0;
                end
            end
        end
    % so:
    % information = sum_across_bins(prob_i*(mFR_i/mFR)*log2(mFR_i/mFR))
        shuffle(iI,1) = sum(info_in_bin(:));
    end
    neuron{iH,5} = nanmean(shuffle);
    shuffle_sorted = sort(shuffle);
    rank = find(neuron{iH,4} > shuffle_sorted);
    neuron{iH,6} = size(rank,1)/100;
    if neuron{iH,6} >= 95
        neuron{iH,7} = 1;
    else
        neuron{iH,7} = 0;
    end
end

clearvars -except neuron cellsOrig com space_mat area_label;
save ('spatial_tuning_results.mat');

%% plot sample neuron
p = pcolor(neuron{39,2});
colormap jet
set(p,'EdgeColor','none')
shading interp
title('Neuron: 98; OFC');

% plot 3D
figure; hold on;
sample = neuron{6,3};
for iJ = 1:size(sample,3)
    surf(sample(:,:,iJ))
end
colormap jet
shading interp
