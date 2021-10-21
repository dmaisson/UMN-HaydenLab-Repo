function [O1_FR] = EpochIsolation(data,O1_start,bin)
% Epoch = start of offer or reward + 500ms(i.e. 25 bins @ 20ms/bin)
% Epoch = start of offer or reward + 500ms(i.e. 50 bins @ 10ms/bin)
% Epoch = start of offer or reward + 500ms(i.e. 500 bins @ 1ms/bin)

if bin == 20
O1_end = O1_start + 24;
elseif bin == 10
O1_end = O1_start + 49;
elseif bin == 1
O1_end = O1_start + 499;
end

for iL = 1:length(data)
    O1_FR{iL} = data{iL}.psth(:,O1_start:O1_end);
end

O1_FR = O1_FR';

end

