function [data] = VarPrep_MyResize_Habiba(start)
%% resize set
for iJ = 1:size(start,1)
    for iK = 1:size(start{iJ}.psth,1)
        if size(start{iJ}.psth,2) > 750 && size(start{iJ}.psth,2) < 1500
            data{iJ}.psth(iK,:) = FR_CollapseBins(start{iJ}.psth(iK,:),2);
        elseif size(start{iJ}.psth,2) == 1500
            temp{iJ}.psth(iK,:) = start{iJ}.psth(iK,201:1200);
            data{iJ}.psth(iK,:) = FR_CollapseBins(temp{iJ}.psth(iK,:),2);
        elseif size(start{iJ}.psth,2) == 750
            data{iJ}.psth(iK,:) = start{iJ}.psth(iK,101:600);
        end
    end
    data{iJ}.vars = start{iJ}.vars;
end
clear start temp
data = data';

%% Smooth (500ms sliding boxcar) and Z-score Firing Rate within a given set for each day
% for iL = 1:size(data,1)
%     for iJ = 1:size(data{iL}.psth,1)
%         data{iL}.psth(iJ,:) = Z_score(data{iL}.psth(iJ,:));
%     end
% end

%% recode the choice vars to 0 and 1
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,7) == 2 %right, old code
            data{iK}.vars(iL,7) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,8) == 2 %right, old code
            data{iK}.vars(iL,8) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,9) == 2 %second, old code
            data{iK}.vars(iL,9) = 0; %right, new coding
        end
    end
end
for iK = 1:length(data)
    for iL = 1:length(data{iK}.vars)
        if data{iK}.vars(iL,11) == 2 %second, old code
            data{iK}.vars(iL,11) = 0; %right, new coding
        end
    end
end

%% Z-Score the trial data
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,1) = Z_score(data{iL}.vars(:,1));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,2) = Z_score(data{iL}.vars(:,2));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,3) = Z_score(data{iL}.vars(:,3));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,4) = Z_score(data{iL}.vars(:,4));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,5) = Z_score(data{iL}.vars(:,5));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,6) = Z_score(data{iL}.vars(:,6));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,7) = Z_score(data{iL}.vars(:,7));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,8) = Z_score(data{iL}.vars(:,8));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,9) = Z_score(data{iL}.vars(:,9));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,10) = Z_score(data{iL}.vars(:,10));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,11) = Z_score(data{iL}.vars(:,11));
% end
% for iL = 1:size(data,1)
%     data{iL}.zvars(:,12) = Z_score(data{iL}.vars(:,12));
% end

end