function [sig_neuron,sig_rate,sig_neuron_3D,sig_rate3D] = isolate_sig_info(input)

for iJ = 1:size(input,1)
    if input{iJ,1}.Info_pvalue >= 0.95
        sig(iJ,1) = 1;
    else
        sig(iJ,1) = 0;
    end
    if input{iJ,1}.Info_pvalue3D >= 0.95
        sig_3D(iJ,1) = 1;
    else
        sig_3D(iJ,1) = 0;
    end
end
sig_rate = (sum(sig)/size(sig,1))*100;
sig_rate3D = (sum(sig_3D)/size(sig_3D,1))*100;

for iJ = 1:size(input,1)
    if sig(iJ,1) == 1
        sig_neuron{iJ,1} = input{iJ,1};
    end
end
for iJ = size(sig,1):-1:1
    if isempty(sig_neuron{iJ,1})
        sig_neuron(iJ,:) = [];
    end
end

if sig_rate3D < 100
    for iJ = 1:size(input,1)
        if sig_3D(iJ,1) == 1
            sig_neuron_3D{iJ,1} = input{iJ,1};
        end
    end
    for iJ = size(sig_3D,1):-1:1
        if isempty(sig_neuron_3D{iJ,1})
            sig_neuron_3D(iJ,:) = [];
        end
    end
else
    sig_neuron_3D = 'all';
end