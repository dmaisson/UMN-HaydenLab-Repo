function fano = fano_factor_epochs(input,token)
% one determines the variance and the mean of binned spike counts across 
% trials. Per bin and neuron, one FF is obtained.

for iJ = 1:length(input)
    if token == 0
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,205:229);
    elseif token == 1
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,193:217);
    end
    start{iJ,1}.E1FR = FR_CollapseBins(start{iJ,1}.E1FR,5);
    start{iJ,1}.E2FR = FR_CollapseBins(start{iJ,1}.E2FR,5);
end

for iJ = 1:size(start,1) % for each neuron
    for iK = 1:size(start{iJ}.E1FR,2) % for each time bin
        x = start{iJ}.E1FR(:,iK);
        y = var(x);
        z = nanmean(x);
        if token == 0
        fano.ep1(iJ,iK) = y/z;
        elseif token == 1
        fano.ep1(iJ,iK) = (y/z)/50;
        end
        clear x y z;
        x = start{iJ}.E2FR(:,iK);
        y = var(x);
        z = nanmean(x);
        if token == 0
        fano.ep2(iJ,iK) = y/z;
        elseif token == 1
        fano.ep2(iJ,iK) = (y/z)/50;
        end
        clear x y z;
    end
end

% for iJ = 1:length(fano.ep1)
    fano.ep1_m = nanmean(fano.ep1,1);
    fano.ep1_SEM = nanstd(fano.ep1,1)/sqrt(size(fano.ep1,1));
    fano.ep2_m = nanmean(fano.ep2,1);
    fano.ep2_SEM = nanstd(fano.ep2,1)/sqrt(size(fano.ep2,1));
% end

% fano_m(1,1) = nanmean(fano_ep1(:,1));
% fano_sem(1,1) = nanstd(fano_ep1(:,1))/sqrt(length(fano_ep1(:,1)));
% fano_m(1,2) = nanmean(fano_ep2(:,1));
% fano_sem(1,2) = nanstd(fano_ep2(:,1))/sqrt(length(fano_ep2(:,1)));

end