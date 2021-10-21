if regressed == 1
    for iH = 1:size(sig,1)
        x = min(sig{iH,15}(:))*2;
        for iJ = 1:size(sig{iH,15},1)
            for iK = 1:size(sig{iH,15},2)
                if isnan(sig{iH,15}(iJ,iK))
                    gaus{iH,1}(iJ,iK) = x;
                else
                    gaus{iH,1}(iJ,iK) = sig{iH,15}(iJ,iK);
                end
            end
        end
        gaus{iH,2} = sig{iH,11};
        gaus{iH,1} = imgaussfilt(gaus{iH,1});
        clear x
    end
elseif regressed == 0
    for iH = 1:size(sig,1)
        x = min(sig{iH,2}(:))*2;
        for iJ = 1:size(sig{iH,2},1)
            for iK = 1:size(sig{iH,2},2)
                if isnan(sig{iH,2}(iJ,iK))
                    gaus{iH,1}(iJ,iK) = x;
                else
                    gaus{iH,1}(iJ,iK) = sig{iH,2}(iJ,iK);
                end
            end
        end
        gaus{iH,2} = sig{iH,11};
        gaus{iH,1} = imgaussfilt(gaus{iH,1});
        clear x
    end
end
% clearvars -except gaus

%%
r = randi(size(gaus,1));
p = pcolor(gaus{r});
title("cell: " + r + "; area: " + gaus{r,2});
set(p,'EdgeColor', 'none')
shading interp
colormap jet
h = colorbar;
ylabel(h,'spikes/second')