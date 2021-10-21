function Rsq = ANCOVAS(var,spikes)

% prep output variable
Rsq(1:size(var,2),1:size(spikes,2)) = 0;

% Run ANCOVAs
for iK = 1:size(var,2) %for each variable
    if iK < size(var,2)
        for iL = 1:size(spikes,2) %for each time bin
            [~,atab,~,~] = aoctool(var(:,iK),spikes(:,iL),...
                var(:,23),.05,'x','y','g','off');
            if atab{3,6}<.05
                Rsq(iK,iL) = ((atab{3,3})/(atab{2,3}+atab{3,3}+...
                    atab{4,3}+atab{5,3}));
            else
                Rsq(iK,iL) = 0;
            end
            clear atab ctab;
        end
    elseif iK == size(var,2)
        for iL = 1:size(spikes,2) %for each time bin
            [~,atab,~,~] = aoctool(var(:,iK),spikes(:,iL),...
                var(:,23),.05,'x','y','g','off','parallel lines');
            if atab{2,6}<.05
                Rsq(iK,iL) = ((atab{2,3})/(atab{2,3}+atab{3,3}+...
                    atab{4,3}));
            else
                Rsq(iK,iL) = 0;
            end
            clear atab ctab;
        end
    end
end

end