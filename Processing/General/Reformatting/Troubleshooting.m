%% which was first, order
for iJ = 1:size(OFC32_maya_switch,1)
%     if size(OFC11_Maya_order{iJ}.oldvars,1) == 707
    for iK = 1:size(OFC32_maya_switch{iJ}.vars,1)
        if OFC32_maya_switch{iJ}.vars(iK,2) == 3 
            OFC32_maya_switch{iJ}.vars(iK,2) = 0; 
        end
        if OFC32_maya_switch{iJ}.vars(iK,5) == 3 
            OFC32_maya_switch{iJ}.vars(iK,5) = 0; 
        end
    end
%     end
end
for iJ = 1:size(OFC32_maya_switch,1)
%     if size(OFC32_maya_switch{iJ}.vars,1) == 707
    for iK = 1:size(OFC32_maya_switch{iJ}.vars,1)
        if OFC32_maya_switch{iJ}.vars(iK,2) == 2 
            OFC32_maya_switch{iJ}.vars(iK,2) = 3;
        end
        if OFC32_maya_switch{iJ}.vars(iK,5) == 2 
            OFC32_maya_switch{iJ}.vars(iK,5) = 3;
        end
    end
%     end
end
for iJ = 1:size(OFC32_maya_switch,1)
%     if size(OFC32_maya_switch{iJ}.vars,1) == 707
    for iK = 1:size(OFC32_maya_switch{iJ}.vars,1)
        if OFC32_maya_switch{iJ}.vars(iK,2) == 1 %if it's "place marker"
            OFC32_maya_switch{iJ}.vars(iK,2) = 2; %make it a left
        end
        if OFC32_maya_switch{iJ}.vars(iK,5) == 1 %if it's "place marker"
            OFC32_maya_switch{iJ}.vars(iK,5) = 2; %make it a left
        end
    end
%     end
end
for iJ = 1:size(OFC32_maya_switch,1)
%     if size(OFC32_maya_switch{iJ}.vars,1) == 707
    for iK = 1:size(OFC32_maya_switch{iJ}.vars,1)
        if OFC32_maya_switch{iJ}.vars(iK,2) == 0 %if it's "place marker"
            OFC32_maya_switch{iJ}.vars(iK,2) = 1; %make it a left
        end
        if OFC32_maya_switch{iJ}.vars(iK,5) == 0 %if it's "place marker"
            OFC32_maya_switch{iJ}.vars(iK,5) = 1; %make it a left
        end
    end
%     end
end
%%
for iJ = 1:size(OFC32_maya_switch,1)
%     if size(OFC32_maya_switch{iJ}.vars,1) == 707
    for iK = 1:size(OFC32_maya_switch{iJ}.vars,1)
        OFC32_maya_switch{iJ}.vars(iK,3) = OFC32_maya_switch{iJ}.vars(iK,1) * OFC32_maya_switch{iJ}.vars(iK,2);
        OFC32_maya_switch{iJ}.vars(iK,6) = OFC32_maya_switch{iJ}.vars(iK,4) * OFC32_maya_switch{iJ}.vars(iK,5);
    end
%     end
end