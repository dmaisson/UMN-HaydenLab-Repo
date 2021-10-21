function [data] = VarPrep(start)

%resize set
for iJ = 1:size(start,1)
    for iK = 1:size(start{iJ}.psth,1)
        if size(start{iJ}.psth,2) == 1000
            data{iJ}.psth(iK,:) = imresize(start{iJ}.psth(iK,:),0.5);
        elseif size(start{iJ}.psth,2) == 1500
            temp{iJ}.psth(iK,:) = start{iJ}.psth(iK,201:1200);
            data{iJ}.psth(iK,:) = imresize(temp{iJ}.psth(iK,:),0.5);
        elseif size(start{iJ}.psth,2) == 750
            data{iJ}.psth(iK,:) = start{iJ}.psth(iK,101:600);
        end
    end
    data{iJ}.vars = start{iJ}.vars;
end
clear start temp
data = data';
% % Z-score Firing Rate within a given set for each day
% for iL = 1:size(data,1)
%     data{iL}.psth = Z_score(data{iL}.psth);
% end
% % recode the choice vars to 0 and 1
% for iK = 1:length(data)
%     for iL = 1:length(data{iK}.vars)
%         if data{iK}.vars(iL,7) == 2 %right, old code
%             data{iK}.vars(iL,7) = 0; %right, new coding
%         end
%     end
% end
% for iK = 1:length(data)
%     for iL = 1:length(data{iK}.vars)
%         if data{iK}.vars(iL,8) == 2 %right, old code
%             data{iK}.vars(iL,8) = 0; %right, new coding
%         end
%     end
% end
% for iK = 1:length(data)
%     for iL = 1:length(data{iK}.vars)
%         if data{iK}.vars(iL,9) == 2 %right, old code
%             data{iK}.vars(iL,9) = 0; %right, new coding
%         end
%     end
% end
% 
% % Z-Score the trial data
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

end