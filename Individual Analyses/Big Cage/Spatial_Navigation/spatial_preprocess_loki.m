%% read data
% do this using preproccess on Loki then import data_proc
parentdir = '/mnt/scratch/DM_spatial/';
cd '/mnt/scratch/DM_spatial/process_notransform'
x1Range = 'A1:CP1';
[~, strings, raw] = xlsread('Yoda-SpikeSorting.xlsx','DailyArea',x1Range);
read_xcell_areas
proc = dir('yo*');
for i = 1:size(proc,1)
    proc(i).drive = 4;
end

%%
for iG = 1:size(proc,1)
%% read data
cd '/mnt/scratch/DM_spatial/process_notransform'
load(proc(iG).name);
day = strsplit(proc(iG).name,'_proc');
day = day{1};

if proc(iG).drive == 1
spkparent = '/mnt/Processed_Data/Data_done_new/';
elseif proc(iG).drive == 2
spkparent = '/mnt/Processed_Data_2/Data_done_new/';
elseif proc(iG).drive == 3
spkparent = '/mnt/Processed_Data_3/Data_done_new/';
elseif proc(iG).drive == 4
spkparent = '/mnt/Processed_Data_4/Data_done_new/';
end
spkday = [spkparent day];
d = dir(spkday);
ephysfolder = d(end).name;
basedir = 'mat/SPK/';
spkFull = [spkday '/' ephysfolder '/' basedir];
cd(spkFull);
spkFiles = dir('spk*'); 
numfiles = length(spkFiles);
cellsOrig = cell(numfiles,1);

date = strsplit(day,'_');
date = date{2};
for iJ = 2:size(strings,2)
    s = strings{1,iJ};
    if sum(date == s) == 10
        dateidx = iJ;
    end
end
arealabels = YodaSpikeSortingS3(:,dateidx);

for k = 1:numfiles 
  cellsOrig{k,1} = load(spkFiles(k).name); 
  temp = strsplit(spkFiles(k).name, 'nt');
  parts = strsplit(temp{2}, 'ch1');
  cellsOrig{k,2} = str2num(parts{1});
  cellsOrig{k,3} = arealabels(cellsOrig{k,2},1);
end
clear temp

%% idenify timestamps for occupancy in spatial bins
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
    for iK = 1:size(div,2)-1 % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
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
        for iK = 1:size(div,2)-1 % check x coordinate
            if cell(iJ,2) >= div(1,iK) && cell(iJ,2) < div(1,iK+1)
                for iL = 1:size(div,2)-1 %check y coordinate
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
    for iK = 1:size(div,2)-1 % check x coordinate
        if com(iJ,1) >= div(1,iK) && com(iJ,1) < div(1,iK+1)
            for iL = 1:size(div,2)-1 %check y coordinate
                if com(iJ,3) >= div(1,iL) && com(iJ,3) < div(1,iL+1)
                    for iM = 1:size(div,2)-1 %check z coordinate
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
        for iK = 1:size(div,2)-1 % check x coordinate
            if cell(iJ,2) >= div(1,iK) && cell(iJ,2) < div(1,iK+1)
                for iL = 1:size(div,2)-1 %check y coordinate
                    if cell(iJ,3) >= div(1,iL) && cell(iJ,3) < div(1,iL+1)
                        for iM = 1:size(div,2)-1 %check z coordinate
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

%% save
day_save = strsplit(day, '_enviro');
day_save = [day_save{1} '_spatialCoding'];

cd '/mnt/scratch/DM_spatial'
save (day_save);

clearvars -except iG parentdir proc YodaSpikeSortingS3 strings

end