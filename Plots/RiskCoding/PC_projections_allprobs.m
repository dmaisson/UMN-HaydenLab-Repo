function [out_safe,out_low,out_high] = PC_projections_allprobs(in)
% run PCA first to get projected matrices
n = size(in,1);
for iI = 1:n
x = in{iI}.projected1.safelow(1:25,:);
y = in{iI}.projected1.safelow(26:50,:);
for iJ = 1:size(x,1)
    temp(1,:) = x(iJ,:);
    temp(2,:) = y(iJ,:);
    projectsafe(iJ,:) = nanmean(temp);
    clear temp;
end
clear x y iJ;

% x = in{iI}.projected2.safelow(1:25,:);
% y = in{iI}.projected2.safelow(26:50,:);
x = in{iI}.projected1.lowsafe(1:25,:);
y = in{iI}.projected1.lowsafe(26:50,:);
for iJ = 1:size(x,1)
    temp(1,:) = x(iJ,:);
    temp(2,:) = y(iJ,:);
    projectlow(iJ,:) = nanmean(temp);
    clear temp;
end
clear x y iJ;

% x = in{iI}.projected2.safehigh(1:25,:);
% y = in{iI}.projected2.safehigh(26:50,:);
x = in{iI}.projected1.highsafe(1:25,:);
y = in{iI}.projected1.highsafe(26:50,:);
for iJ = 1:size(x,1)
    temp(1,:) = x(iJ,:);
    temp(2,:) = y(iJ,:);
    projecthigh(iJ,:) = nanmean(temp);
    clear temp;
end
clear x y iJ;

out_safe{iI,1} = smoothdata(projectsafe);
out_low{iI,1} = smoothdata(projectlow);
out_high{iI,1} = smoothdata(projecthigh);
end

figure;
for iI = 1:size(out_safe,1)
    hold on;
    plot3(out_safe{iI}(:,1),out_safe{iI}(:,2),out_safe{iI}(:,3),'k','Linewidth',2);
    plot3(out_low{iI}(:,1),out_low{iI}(:,2),out_low{iI}(:,3),'b','Linewidth',2);
%     scatter3(out_safe{iI}(:,1),out_safe{iI}(:,2),out_safe{iI}(:,3),'k');
%     scatter3(out_low{iI}(:,1),out_low{iI}(:,2),out_low{iI}(:,3),'b');
%     plot(out_safe{1}(:,1),out_safe{1}(:,2),'k','Linewidth',2);
%     plot(out_low{iI}(:,1),out_low{iI}(:,2),'b','Linewidth',2);
end
figure;
for iI = 1:size(out_safe,1)
    hold on;
    plot3(out_safe{iI}(:,1),out_safe{iI}(:,2),out_safe{iI}(:,3),'k','Linewidth',2);
    plot3(out_high{iI}(:,1),out_high{iI}(:,2),out_high{iI}(:,3),'g','Linewidth',2);
end

end