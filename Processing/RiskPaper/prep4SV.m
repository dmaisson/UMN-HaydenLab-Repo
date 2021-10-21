function out = prep4SV(in)

for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,9) == 2
            in{iJ}.vars(iK,9) = 0;
        end
    end
    out{iJ,1} = in{iJ}.vars;
end