function [var,spikes] = Setup_ancova(data,tokentask)

for iJ = 1:length(data)
    [var{iJ,1},spikes{iJ,1}] = PS_VarsSetup(data{iJ},tokentask);
end
clear iJ iK iL p tokentask;

end