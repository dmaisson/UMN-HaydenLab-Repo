function out = Preselect_ANCOVA(in,tokentask)

rate = 0;
for iJ = 1:length(in)
    [var{iJ,1},spikes{iJ,1}] = PS_VarsSetup(in{iJ},tokentask);
    [check{iJ,1},p{iJ,1}] = ModFilter(spikes{iJ,1},var{iJ,1});
    if check{iJ,1} ~= 0
        rate = rate+1;
    end
end

out = in;
for iJ = length(in):-1:1
    if check{iJ} == 0
        out(iJ) = [];
    end
end

end