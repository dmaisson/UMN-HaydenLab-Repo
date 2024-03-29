function [grid_score,rotations] = gridness(autocorrelogram)

% make a circle for reference to build annulus
s = size(autocorrelogram,1);
x = linspace(-(s/2),(s/2),s);
y = linspace(-(s/2),(s/2),s);
% x = -110:110;
% y = -110:110;
[xx yy] = meshgrid(x,y);
u = zeros(size(xx));
u((xx.^2+yy.^2)<(s/2)^2)=1;   % radius 100, center at the origin
% hard boundary
% figure(1)
% imagesc(u)
clear x xx y yy s

% take out the peak correlation coefficients (primary reason is remove the
% center peak)
removed = autocorrelogram;
removed(removed(:) == 1) = NaN;

% Identify where the next highest value is (now that the peak = 1 is gone)
for iA = 1:size(removed,1)
    col_m = max(removed(:,iA));
    col_m_idx{iA,1} = find(removed(:,iA) == col_m);
    clear temp col_m
end

maxes = zeros(iA);
for iA = 1:size(col_m_idx,1)
    for iB = 1:numel(col_m_idx{iA})
        maxes(iA,col_m_idx{iA,1}(iB)) = 1;
    end
end
clear col_m_idx;

% identify where the closest remaining peaks are, relative to center
center1 = size(autocorrelogram,1)/2;
center2 = center1+1;
dist = zeros(iA);
for iA = 1:size(dist,1)
    for iB = 1:size(dist,2)
        if maxes(iA,iB) == 1
            a = abs(center1 - iA);
            b = abs(center1 - iB);
            temp(1) = (sqrt(a.^2 + b.^2))/2;
            clear a b
            a = abs(center2 - iA);
            b = abs(center2 - iB);
            temp(2) = (sqrt(a.^2 + b.^2))/2;
            clear a b
            dist(iA,iB) = mean(temp);
            if abs(center1 - iA) < 4 && abs(center1 - iB) < 4
                dist(iA,iB) = 0;
            end
            if abs(center2 - iA) < 4 && abs(center2 - iB) < 4
                dist(iA,iB) = 0;
            end
        end
    end
end
dist(dist(:) == 0) = NaN;

for iA = 1:size(removed,1)
    col_m(iA,1) = min(dist(:,iA));
end

% using distance from center, identify the inner_radius of the annulus 
mins(1) = min(col_m);
col_m(col_m == mins) = NaN;
mins(2) = min(col_m);
inner_radius = round(mean(mins));

% reference the circle created at the beginner, but remove inner circle
s = size(autocorrelogram,1);
x = linspace(-(s/2),(s/2),s);
y = linspace(-(s/2),(s/2),s);
[xx yy] = meshgrid(x,y);
placement = zeros(size(xx));
placement = (xx.^2+yy.^2)<inner_radius^2;
% hard boundary
clear x xx y yy s
u(placement(:) == 1) = 0;

removed = autocorrelogram;
removed(u(:) ~= 1) = NaN;

rotations = (0:5:360);

for iA = 1:size(rotations,2)
    a = imrotate(removed,rotations(iA));
    a(a(:) == 0) = NaN;
    init = removed;
    rot_vect = a(:);
    init_vect = init(:);
    smaller = min([size(rot_vect(~isnan(rot_vect)),1) size(init_vect(~isnan(init_vect)),1)]);
%     bigger = max([size(rot_vect(~isnan(rot_vect)),1) size(init_vect(~isnan(init_vect)),1)]);
    rot_vect = rot_vect(~isnan(rot_vect));
    init_vect = init_vect(~isnan(init_vect));
%     rot_vect(end:bigger,1) = 0;
%     init_vect(end:bigger,1) = 0;
    r(1,iA) = corr(init_vect(1:smaller),rot_vect(1:smaller));
%     r(1,iA) = corr(init_vect,rot_vect);
    clear a init size_diff add_rows add_cols rot_vect init_vect remainder smaller
end
rotations(2,:) = r; clear r
group1 = [30,50,90]; group2 = [60,120];
for iA = 1:numel(group1)
    pos = find(rotations(1,:) == group1(1,iA));
    group1(2,iA) = rotations(2,pos);
    clear pos
end
for iA = 1:numel(group2)
    pos = find(rotations(1,:) == group2(1,iA));
    group2(2,iA) = rotations(2,pos);
    clear pos
end

group1_max = max(group1(2,:)); group2_min = (min(group2(2,:)));
grid_score = group2_min - group1_max;

end