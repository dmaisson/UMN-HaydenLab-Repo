% assorted criteria:
    % 6) significant spatial information
clearvars -except sig regressed

    % 1) firing rates outside of field is roughly 1/sec or lower
        % this might not work in regions in which firing rates are already
        % low
        
    % 2) firing rate across session is greater than 0.05 Hz
for iI = size(sig,1):-1:1
    if size(sig{iI,1},1)/6000 <= 0.05
        sig(iI,:) = [];
    end
end

    % 3) firing is bursty, with successively descending amplitudes
for iI = 1:size(sig,1)
    for iJ = 1:size(sig{iI,1},1)-1
        ISI{iI,1}(iJ,1) = sig{iI,1}(iJ+1,1) - sig{iI,1}(iJ,1);
    end
    x = ISI{iI};
    y = find(x < 1);
    for iJ = 1:size(y,1)-1
        ISI{iI,2}(iJ,1) = y(iJ+1) - y(iJ);
    end
    clear x y;
    bursty(iI,1) = 0;
    for iJ = 1:size(ISI{iI,2},1)
        if ISI{iI,2}(iJ,1) == 1
            bursty(iI,1) = bursty(iI,1) + 1;
        end
    end
    bursty(iI,2) = size(ISI{iI,2},1);
    bursty(iI,3) = bursty(iI,1)/bursty(iI,2);
end
for iI = size(sig,1):-1:1
    if bursty(iI,3) < 0.5
        sig(iI,:) = [];
    end
end
RateMaps
clearvars -except sig gaus regressed 

    % 4) firing is peak within the field
    % 5) firing rate is >= to 5-15% of the session max