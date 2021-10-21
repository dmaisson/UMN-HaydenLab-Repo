in = Area32;

c = 1;
d = 1;
for iJ = 1:length(in) %count through the cells
    if iJ == 1 %if it's cell #1
        out{c}.psth = in{iJ}.psth; %out 1 spikes are cell 1's
        out{c}.vars = in{iJ}.vars; %out 1 traisl vars are cell 1's
    else % if it's any cell thereafter
        if size(in{iJ}.psth,1) == size(in{iJ-1}.psth,1) %if the trial number matches previous
            d = d+1;
            out{c}.psth(:,:,d) = in{iJ}.psth; %drop the current spike into 3rd D behind prev
            c = c; %keep c the same
        else %if the number of trials DOESN'T match those for previous cell
            c = c+1; %increase the counter
            d = 1; %reset d
            out{c}.psth = in{iJ}.psth; %using that new counter, start a new struct entry
            out{c}.vars = in{iJ}.vars;
        end
    end
end
out = out';
