function [output] = myshuffle(data)
%% Bootstrapping with replacement
for iJ = 1:size(data,1)
    output{iJ}.psth(1:size(data{iJ}.psth,1),1:size(data{iJ}.psth,2)) = NaN;
    output{iJ}.vars(1:size(data{iJ}.vars,1),1:size(data{iJ}.vars,2)) = NaN;
end
output = output';

for iJ = 1:size(data,1) %for each cell
    for iK = 1:size(data{iJ}.vars,1) %for each trial
        x = randi(size(data{iJ}.vars,1)); %pick a random trial number
        for iL = 1:size(data{iJ}.vars,2) %for each variable
            y = randi(size(data{iJ}.vars,2));
            output{iJ}.vars(iK,iL) = data{iJ}.vars(x,y);
            clear y;
        end
        clear x;
    end  
    output{iJ}.psth = data{iJ}.psth;
end
end