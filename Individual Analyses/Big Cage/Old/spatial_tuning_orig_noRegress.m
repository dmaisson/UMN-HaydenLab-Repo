%% read in data
data = dir('yo*');
numfiles = length(data);
load('area_lookup.mat');
for k = 1:numfiles
  temp = load(data(k).name); 
  temp2 = strsplit(data(k).name, 'yo_');
  temp3 = strsplit(temp2{2}, '_01');
  day = temp3{1};
  for j = 1:size(temp.neuron,1)
    temp.neuron{j,8} = day;
    temp.neuron{j,9} = temp.cellsOrig{j,2};
    temp.neuron{j,10} = temp.cellsOrig{j,3}{1,1};
    for L = 1:size(area_lookup,1)
        if temp.neuron{j,10} == area_lookup{L,2}
            temp.neuron{j,11} = area_lookup{L,1};
        elseif temp.neuron{j,10} == 0
            temp.neuron{j,11} = 'unknown';
        end
    end
    temp.neuron{j,12} = temp.XY_mat;
    temp.neuron{j,13} = temp.XYZ_mat;
  end
  if k == 1
      cells = temp.neuron;
  else
      cells = cat(1,cells,temp.neuron);
  end
  clear temp temp2 temp3 j day
end

clearvars -except cells

%% find significant place cells (significant spatial tuning) - 2D
% information = sum_across_bins((probability of being in bin i)*((mFR in
% bin i)/(mFR of cell))*log2*((mFR in
% bin i)/(mFR of cell))

% formally:
% prob_i = prob of being in bin i (i.e. % of time spent in bin)
for iI = 1:size(cells,1)
    XY_mat = cells{iI,12};
    prob_i = XY_mat./sum(XY_mat(:));
    % mFR_i = mean firing rate in bin i
    FRs = cells{iI,2};
    mFR_i = Z_score(FRs);
    % mFR = overal; mean firing rate for the neuron
    mFR = nanmean(FRs(:));
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
    cells{iI,4} = sum(info_in_bin(:));
    cells{iI,14} = info_in_bin;
    iI
end

% shuffle
for iH = 1:size(cells,1)
    XY_mat = cells{iH,12};
    prob_i = XY_mat./sum(XY_mat(:));
    for iI = 1:1000
        % mFR_i = mean firing rate in bin i
        FRs = cells{iH,2};
        mFR_i = Z_score(FRs);
        % mFR = overal; mean firing rate for the neuron
        mFR = nanmean(FRs(:));
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
    cells{iH,5} = nanmean(shuffle);
    shuffle_sorted = sort(shuffle);
    rank = find(cells{iH,4} > shuffle_sorted);
    cells{iH,6} = size(rank,1)/10;
    if cells{iH,6} >= 95
        cells{iH,7} = 1;
    else
        cells{iH,7} = 0;
    end
    iH
end
clearvars -except cells

%% rate of sig spatial
for iJ = 1:size(cells,1)
    x(iJ,1) = cells{iJ,7};
end
rate_sig = (sum(x)/size(x,1))*100; clear x;

%% isolate spatial sig
for iJ = 1:size(cells,1)
    for iK = 1:size(cells,2)
        if cells{iJ,7} == 1
            sig{iJ,iK} = cells{iJ,iK};
        end
    end
end
for iJ = size(sig,1):-1:1
    if isempty(sig{iJ,1})
        sig(iJ,:) = [];
    end
end
clear iJ iK;

%% histogram by region
for iJ = 1:size(sig)
    y(iJ,1) = sig{iJ,10};
end
hist(y,30);

%% save
save('all_cells_NOTregressed','-v7.3');