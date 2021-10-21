% data = cleanOFC11;
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,7) == 2 %right, old code
            data{iK}.vars(iL,7) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,8) == 2 %right, old code
            data{iK}.vars(iL,8) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,9) == 2 %right, old code
            data{iK}.vars(iL,9) = 0; %right, new coding
        end
    end
end
