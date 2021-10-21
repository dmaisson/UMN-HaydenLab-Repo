for iJ = 1:size(cleanOFC32,1)
    for iK = 1:size(cleanOFC32{iJ}.psth,1)
        if size(cleanOFC32{iJ}.psth,2) < 1500
            cleanOFC32{iJ}.newpsth(iK,:) = cleanOFC32{iJ}.psth(iK,1:1000);
        else
            cleanOFC32{iJ}.newpsth = cleanOFC32{iJ}.psth;
        end
    end
end
for iJ = 1:size(cleanOFC32,1)
    cleanOFC32{iJ}.psth = cleanOFC32{iJ}.newpsth;
end