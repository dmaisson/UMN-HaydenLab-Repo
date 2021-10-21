cleanOFC24 = [];
%% spikes
set = spikes3;
if isempty(cleanOFC24)
    for iL = 1:size(set,2)
        for iK = 1:size(set,1)
            for iJ = 1:size(set,3)
                cleanOFC24{iL}.psth(iK,iJ) = set(iK,iL,iJ);
            end
        end
    end
elseif ~isempty(cleanOFC24)
    c = length(cleanOFC24);
    for iL = 1:size(set,2)
        for iK = 1:size(set,1)
            for iJ = 1:size(set,3)
                cleanOFC24{iL+c}.psth(iK,iJ) = set(iK,iL,iJ);
            end
        end
    end
end

%% reorient
cleanOFC24 = cleanOFC24';
%% vars
for iL = 1:length(cleanOFC24)
    cleanOFC24{iL}.vars = [];
end

%% vars fill
for iL = 41:60
    if isempty(cleanOFC24{iL}.vars)
        cleanOFC24{iL}.vars = vars{3};
    end
end
