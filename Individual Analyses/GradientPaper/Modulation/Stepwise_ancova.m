function [res,Count,Rate,m] = Stepwise_ancova(data,tokentask)

[var,spikes] = Setup_ancova(data,tokentask);

% ANCOVAs
for iJ = 1:length(data)%for each cell
    Rsq{iJ,1} = ANCOVAS(var{iJ},spikes{iJ});
end
clear iJ;

% Flags and counts
[OBest,TBest,Count,Rate,m] = FindBestRsq(Rsq);

[res] = residualize(TBest,data,m);

end