function grid_score = gridness(autocorrelogram)

removed = autocorrelogram;
removed(removed(:) == 1) = NaN;

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
mins(1) = min(col_m);
col_m(col_m == mins) = NaN;
mins(2) = min(col_m);
inner_radius = round(mean(mins));

removed = autocorrelogram;
inner_bounds(1) = center1 - inner_radius;
inner_bounds(2) = center2 + inner_radius;
removed(inner_bounds(1):inner_bounds(2),inner_bounds(1):inner_bounds(2)) = NaN;
outer_bounds(1) = center1 - inner_radius*3;
outer_bounds(2) = center2 + inner_radius*3;
removed(1:outer_bounds(1),:) = NaN;
removed(outer_bounds(2):end,:) = NaN;
removed(:,1:outer_bounds(1)) = NaN;
removed(:,outer_bounds(2):end) = NaN;

rotations = [30 50 60 90 120];

for iA = 1:size(rotations,2)
    a = imrotate(removed,rotations(iA));
    a(a(:) == 0) = NaN;
    init = removed;
    size_diff = (abs(size(removed,1)-size(a,1)))/2;
    remainder = rem(size_diff,1);
    if remainder ~= 0
        size_diff = round(size_diff);
        add_rows(1:size_diff,1:size(init,1)) = NaN;
        init = cat(1,add_rows,init);
        init = cat(1,init,add_rows);
        add_cols(1:size(init,1),1:size_diff) = NaN;
        init = cat(2,add_cols,init);
        init = cat(2,init,add_cols);
        init(end,:) = [];
        init(:,end) = [];
    else
        add_rows(1:size_diff,1:size(init,1)) = NaN;
        init = cat(1,add_rows,init);
        init = cat(1,init,add_rows);
        add_cols(1:size(init,1),1:size_diff) = NaN;
        init = cat(2,add_cols,init);
        init = cat(2,init,add_cols);
    end
    rot_vect = a(:);
    init_vect = init(:);
    rot_vect(isnan(rot_vect(:))) = 0;
    init_vect(isnan(init_vect(:))) = 0;
    r(1,iA) = corr(init_vect,rot_vect);
    clear a init size_diff add_rows add_cols rot_vect init_vect remainder
end
rotations(2,:) = r; clear r
group1(:,1) = rotations(:,3); group1(:,2) = rotations(:,5);
group2(:,1:2) = rotations(:,1:2); group2(:,3) = rotations(:,4); clear rotations
group1_min = min(group1(2,:)); group2_max = (max(group2(2,:)));
grid_score = group1_min - group2_max;

end