function f = PC_projections(in)
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

x = in{iI}.projected2.safelow(1:25,:);
y = in{iI}.projected2.safelow(26:50,:);
for iJ = 1:size(x,1)
    temp(1,:) = x(iJ,:);
    temp(2,:) = y(iJ,:);
    projectlow(iJ,:) = nanmean(temp);
    clear temp;
end
clear x y iJ;

x = in{iI}.projected2.safehigh(1:25,:);
y = in{iI}.projected2.safehigh(26:50,:);
for iJ = 1:size(x,1)
    temp(1,:) = x(iJ,:);
    temp(2,:) = y(iJ,:);
    projecthigh(iJ,:) = nanmean(temp);
    clear temp;
end
clear x y iJ;

projectsafe = smoothdata(projectsafe);
projectlow = smoothdata(projectlow);
projecthigh = smoothdata(projecthigh);

f{1} = figure;
grid on
hold on
plot3(projectsafe(:,1),projectsafe(:,2),projectsafe(:,3),'bk','Linewidth',2);
plot3(projectlow(:,1),projectlow(:,2),projectlow(:,3),'Linewidth',2);
% scatter3(projectedsafe(:,1),projectedsafe(:,2),projectedsafe(:,3),'k','Linewidth',2);
% scatter3(projectedlow(:,1),projectedlow(:,2),projectedlow(:,3),'b','Linewidth',2);
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

f{2} = figure;
grid on
hold on
plot3(projectsafe(:,1),projectsafe(:,2),projectsafe(:,3),'bk','Linewidth',2);
plot3(projecthigh(:,1),projecthigh(:,2),projecthigh(:,3),'Linewidth',2);
% scatter3(projectedsafe(:,1),projectedsafe(:,2),projectedsafe(:,3),'k','Linewidth',2);
% scatter3(projectedhigh(:,1),projectedhigh(:,2),projectedhigh(:,3),'g','Linewidth',2);
xlabel('PC1');
ylabel('PC2');
zlabel('PC3');

end