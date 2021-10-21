xtick = (-1:.02:4.98);
y = (Raw.data14{126}.psth(:,200:499)).*50;
x = Raw.data14{126}.vars;
y1(1:size(y,1),1:size(y,2)) = NaN;
y2(1:size(y,1),1:size(y,2)) = NaN;
for iJ = 1:length(y)
    if x(iJ,3) > x(iJ,6)
        y1(iJ,:) = y(iJ,:);
    elseif x(iJ,6) >= x(iJ,3)
        y2(iJ,:) = y(iJ,:);
    end
end

for iJ = length(y1):-1:1
    if isnan(y1(iJ,1))
        y1(iJ,:) = [];
    end
    if isnan(y2(iJ,1))
        y2(iJ,:) = [];
    end
end

hold on;
plot(xtick,smooth(mean(y1,1)));
plot(xtick,smooth(mean(y2,1)));
ylim([0 10]);
vline(0);vline(1);vline(2);vline(2.3);
figure; spy(y,'k');
%%
y = Raw.data25{77}.psth(:,200:499);
x = Raw.data25{77}.vars;
y1(1:size(y,1),1:size(y,2)) = NaN;
y2(1:size(y,1),1:size(y,2)) = NaN;
for iJ = 1:length(y)
    if x(iJ,3) > x(iJ,6)
        y1(iJ,:) = y(iJ,:);
    elseif x(iJ,6) >= x(iJ,3)
        y2(iJ,:) = y(iJ,:);
    end
end

for iJ = length(y1):-1:1
    if isnan(y1(iJ,1))
        y1(iJ,:) = [];
    end
    if isnan(y2(iJ,1))
        y2(iJ,:) = [];
    end
end

hold on;
plot(xtick,smooth(mean(y1,1)));
plot(xtick,smooth(mean(y2,1)));
ylim([0 10]);
hold on;vline(0);vline(0.75);vline(1.5);vline(1.8);
figure; spy(y,'k');
%%
y = (FR_CollapseBins(Raw.data32{62}.psth(:,400:999),2)).*50;
x = Raw.data32{62}.vars;
y1(1:size(y,1),1:size(y,2)) = NaN;
y2(1:size(y,1),1:size(y,2)) = NaN;
for iJ = 1:length(y)
    if x(iJ,3) > x(iJ,6)
        y1(iJ,:) = y(iJ,:);
    elseif x(iJ,6) >= x(iJ,3)
        y2(iJ,:) = y(iJ,:);
    end
end

for iJ = length(y1):-1:1
    if isnan(y1(iJ,1))
        y1(iJ,:) = [];
    end
    if isnan(y2(iJ,1))
        y2(iJ,:) = [];
    end
end

hold on;
plot(xtick,smooth(mean(y1,1)));
plot(xtick,smooth(mean(y2,1)));
ylim([0 10]);
vline(0);vline(1);vline(2);vline(2.3);
figure; spy(y,'k');
%%
y = Raw.data24{65}.psth(:,200:499);
x = Raw.data24{65}.vars;
y1(1:size(y,1),1:size(y,2)) = NaN;
y2(1:size(y,1),1:size(y,2)) = NaN;
for iJ = 1:length(y)
    if x(iJ,3) > x(iJ,6)
        y1(iJ,:) = y(iJ,:);
    elseif x(iJ,6) >= x(iJ,3)
        y2(iJ,:) = y(iJ,:);
    end
end

for iJ = length(y1):-1:1
    if isnan(y1(iJ,1))
        y1(iJ,:) = [];
    end
    if isnan(y2(iJ,1))
        y2(iJ,:) = [];
    end
end

hold on;
plot(xtick,smooth(mean(y1,1)));
plot(xtick,smooth(mean(y2,1)));
ylim([0 10]);
hold on;vline(0);vline(0.75);vline(1.5);vline(1.8);
figure; spy(y,'k');