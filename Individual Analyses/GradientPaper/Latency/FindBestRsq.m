function [OBest,TBest,Count,Rate,m] = FindBestRsq(Rsq)

for iJ = 1:length(Rsq)
    for iL = 1:size(Rsq{iJ},2)
        TBest{iJ,iL} = 0;
    end
    OBest{iJ,1} = 0;
    OBest{iJ,2} = 0;
    c{iJ,1} = 0;
end

for iJ = 1:length(Rsq) % for each neuron
    for iK = 1:size(Rsq{iJ},2) % for each time bin
        for iL = 1:size(Rsq{iJ},1) % for each variable
            if sum(Rsq{iJ}(:,iK)) == 0
                TBest{iJ,iK} = 0;
            elseif Rsq{iJ}(iL,iK) > c{iJ} % for that neuron, in that time bin, if that variable's explanation is greater than the current hightest
                c{iJ} = Rsq{iJ}(iL,iK); % change the current-highest place holder to that value
                TBest{iJ,iK} = iL; % identify the var num of that R-sqd value
                OBest{iJ,1} = iL;
                OBest{iJ,2} = iK;
            end
        end
    end
end
clear iJ iK iL c;

Count(1:size(Rsq{1},1),1:size(Rsq{1},2)) = 0;

% isolate each column, then use max() to see if Best{}(1) == max()
for iJ = 1:size(TBest,1) % for each neuron
    for iK = 1:size(TBest,2) % for each time bin
        for iL = 1:size(Count,1) % for each var
            if TBest{iJ,iK} == iL %if that neuron's best explainer in that time is the current var in the count
                Count(iL,iK) = Count(iL,iK) + 1; % add a count for that var
            end
        end
    end
end
Count = Count';
Rate = (Count/length(Rsq))*100;
clear iJ iK iL c;

mv = Count(Count == max(max(Count,[],1)));
mc(1:size(Count,1),1:size(Count,2)) = 0;
if length(mv) == 1
    for iJ = 1:size(Count,1)
        for iK = 1:size(Count,2)
            if Count(iJ,iK) == mv(1)
                m = iK;
            end
        end
    end
elseif length(mv) > 1
    for iJ = 1:size(Count,1)
        for iK = 1:size(Count,2)
            if Count(iJ,iK) == mv(1)
                mc(:,iK) = Count(:,iK);
            end
        end
    end
    avg = mean(mc,1);
    m = find(avg == max(avg));
    if length(m) > 1
        m = m(1);
    end
end

end