%%
start = Prepped.data14;

for iJ = 1:length(start)-1
    if iJ == 1
        x1 = cat(1,start{iJ}.vars,start{iJ+1}.vars);
        y1 = cat(1,start{iJ}.psth,start{iJ+1}.psth);
    else
        x1 = cat(1,x1,start{iJ+1}.vars);
        y1 = cat(1,y1,start{iJ+1}.psth);
    end
end
for iJ = 1:length(x1)
    x1(iJ,12) = 0;
end

epoch1 = 155;
epoch2 = 205;

% Pull FRs for given epoch
O1_end = epoch1 + 24;
O2_end = epoch2 + 24;
E1_FR = y1(:,epoch1:O1_end);
E2_FR = y1(:,epoch2:O2_end);

% average FR over time by collapsing across the bins
Ep11 = mean(E1_FR,2);
Ep21 = mean(E2_FR,2);

clear O1_end O2_end epoch1 epoch2 E1_FR E2_FR token y1 start iJ;

%%
start = Prepped.data25;
for iJ = 1:length(start)-1
    if iJ == 1
        x2 = cat(1,start{iJ}.vars,start{iJ+1}.vars);
        y2 = cat(1,start{iJ}.psth,start{iJ+1}.psth);
    else
        x2 = cat(1,x2,start{iJ+1}.vars);
        y2 = cat(1,y2,start{iJ+1}.psth);
    end
end
for iJ = 1:length(x2)
    x2(iJ,12) = 1;
end

epoch1 = 155;
epoch2 = 193;

% Pull FRs for given epoch
O1_end = epoch1 + 24;
O2_end = epoch2 + 24;
E1_FR = y2(:,epoch1:O1_end);
E2_FR = y2(:,epoch2:O2_end);

% average FR over time by collapsing across the bins
Ep12 = mean(E1_FR,2);
Ep22 = mean(E2_FR,2);

clear O1_end O2_end epoch1 epoch2 E1_FR E2_FR token y2 start iJ;

%%
start = Prepped.data32;
for iJ = 1:length(start)-1
    if iJ == 1
        x3 = cat(1,start{iJ}.vars,start{iJ+1}.vars);
        y3 = cat(1,start{iJ}.psth,start{iJ+1}.psth);
    else
        x3 = cat(1,x3,start{iJ+1}.vars);
        y3 = cat(1,y3,start{iJ+1}.psth);
    end
end
for iJ = 1:length(x3)
    x3(iJ,12) = 2;
end

epoch1 = 155;
epoch2 = 205;

% Pull FRs for given epoch
O1_end = epoch1 + 24;
O2_end = epoch2 + 24;
E1_FR = y3(:,epoch1:O1_end);
E2_FR = y3(:,epoch2:O2_end);

% average FR over time by collapsing across the bins
Ep13 = mean(E1_FR,2);
Ep23 = mean(E2_FR,2);

clear O1_end O2_end epoch1 epoch2 E1_FR E2_FR token y3 start iJ;

%%
start = Prepped.data24;
for iJ = 1:length(start)-1
    if iJ == 1
        x4 = cat(1,start{iJ}.vars,start{iJ+1}.vars);
        y4 = cat(1,start{iJ}.psth,start{iJ+1}.psth);
    else
        x4 = cat(1,x4,start{iJ+1}.vars);
        y4 = cat(1,y4,start{iJ+1}.psth);
    end
end
for iJ = 1:length(x4)
    x4(iJ,12) = 3;
end

epoch1 = 155;
epoch2 = 193;

% Pull FRs for given epoch
O1_end = epoch1 + 24;
O2_end = epoch2 + 24;
E1_FR = y4(:,epoch1:O1_end);
E2_FR = y4(:,epoch2:O2_end);

% average FR over time by collapsing across the bins
Ep14 = mean(E1_FR,2);
Ep24 = mean(E2_FR,2);

clear O1_end O2_end epoch1 epoch2 E1_FR E2_FR token y4 start iJ;

%%
x = cat(1,x1,x2);
x = cat(1,x,x3);
x = cat(1,x,x4);

Ep1 = cat(1,Ep11,Ep12);
Ep1 = cat(1,Ep1,Ep13);
Ep1 = cat(1,Ep1,Ep14);

Ep2 = cat(1,Ep21,Ep22);
Ep2 = cat(1,Ep2,Ep23);
Ep2 = cat(1,Ep2,Ep24);

clear x1 x2 x3 x4 Ep11 Ep12 Ep13 Ep14 Ep21 Ep22 Ep23 Ep24 start iJ;