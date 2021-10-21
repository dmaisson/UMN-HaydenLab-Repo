function data = delete_duplicate_days(data)
%This is a function that removes trial data from StagOps that has
%duplicates within the set

%   Sometimes, more than one neuron is recorded on a given day. This
%   results in having multiple copies of a single day's worth of trial
%   data. This function will remove those duplicates for an analysis that
%   is only concerned with behavior, and should therefore not be influenced
%   by overweightin a given day's choice behaviors simply for having
%   multiple cells from that session.

for iJ = length(data):-1:2
    if length(data{iJ}) == length(data{iJ-1})
        if sum(data{iJ}(1:10,1) == data{iJ-1}(1:10,1)) == 10
            data(iJ) = [];
        end
    end
end

end