function [res] = residualize(TBest,data,m)

for iJ = 1:size(TBest,1)
    res{iJ,1} = data{iJ,1};
    for iK = 1:size(TBest,2)
        if TBest{iJ,iK} == m
            res{iJ,1} = [];
        end
    end
end

for iJ = length(res):-1:1
    if isempty(res{iJ})
        res(iJ) = [];
    end
end

end