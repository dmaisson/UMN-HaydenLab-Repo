n=length(VS);
for iJ = 1:n
    for iK = 1:length(VS{iJ}.vars)
        if VS{iJ}.vars(iK,2) < 1
            if VS{iJ}.vars(iK,2) == 0.15
                VS{iJ}.vars(iK,2) = 1;
            elseif VS{iJ}.vars(iK,2) == 0.18
                VS{iJ}.vars(iK,2) = 2;
            elseif VS{iJ}.vars(iK,2) == 0.21
                VS{iJ}.vars(iK,2) = 3;
            end
            if VS{iJ}.vars(iK,5) == 0.15
                VS{iJ}.vars(iK,5) = 1;
            elseif VS{iJ}.vars(iK,5) == 0.18
                VS{iJ}.vars(iK,5) = 2;
            elseif VS{iJ}.vars(iK,5) == 0.21
                VS{iJ}.vars(iK,5) = 3;
            end
        end
    end
end
%%
n=length(VS);
for iJ = 1:n
    for iK = 1:length(VS{iJ}.vars)
        if VS{iJ}.vars(iK,2) == 1
            VS{iJ}.vars(iK,1) = 1;
        end
        if VS{iJ}.vars(iK,5) == 1
            VS{iJ}.vars(iK,4) = 1;
        end
    end
end
%%
n=length(VS);
for iJ = 1:n
    for iK = 1:length(VS{iJ}.vars)
    VS{iJ}.vars(iK,3) = VS{iJ}.vars(iK,1) * VS{iJ}.vars(iK,2);
    VS{iJ}.vars(iK,6) = VS{iJ}.vars(iK,4) * VS{iJ}.vars(iK,5);
    end
end