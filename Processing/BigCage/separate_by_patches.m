function patches = separate_by_patches(input)

for iJ = 1:size(input,1)
    x = unique(input{iJ}.evt.patchID);
    y = size(x,1);
    if y == 1
        patches.one{iJ,1} = input{iJ};
    elseif y == 2
        patches.two{iJ,1} = input{iJ};
    elseif y == 3
        patches.three{iJ,1} = input{iJ};
    elseif y == 4
        patches.four{iJ,1} = input{iJ};
    end
end
try
    for iJ = size(patches.one,1):-1:1
        if isempty(patches.one{iJ})
            patches.one(iJ,:) = [];
        end
    end
catch
    patches.one = [];
end
try
    for iJ = size(patches.two,1):-1:1
        if isempty(patches.two{iJ})
            patches.two(iJ,:) = [];
        end
    end
catch
    patches.two = [];
end
try
    for iJ = size(patches.three,1):-1:1
        if isempty(patches.three{iJ})
            patches.three(iJ,:) = [];
        end
    end
catch
    patches.three = [];
end
try
    for iJ = size(patches.four,1):-1:1
        if isempty(patches.four{iJ})
            patches.four(iJ,:) = [];
        end
    end
catch
    patches.four = [];
end

end