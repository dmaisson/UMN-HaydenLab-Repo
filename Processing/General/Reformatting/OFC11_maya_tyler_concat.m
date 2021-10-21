for iL = 1:size(maya,1)
    maya{iL}.psth = maya{iL}.psth;
    maya{iL}.psth = [];
end

for iL = 1:size(maya,1)
    for iK = 1:size(maya{iL}.oldpsth,1)
        maya{iL}.psth(iK,:) = maya{iL}.oldpsth(iK,200:1199);
    end
end
   
for iK = 1:53
    maya{85+iK}.vars = OFC11_maya_pumbaa{iK}.vars;
    maya{85+iK}.psth = OFC11_maya_pumbaa{iK}.psth;
end