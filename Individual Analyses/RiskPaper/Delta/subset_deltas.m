function out = subset_deltas(in,probs)
% first we imagine those neurons constitute a set P, of size S 
% (where S = number of neurons that encode value abstractly)

safe = in.safe.Ep1; %take the data from safe trials
n = length(safe); %find how many cells there are
S_range = (1:100)/100; %set the range for the size of S
eqlow = in.eqlow.Ep1; %take the data for cells from that prob bin
eqhigh = in.eqhigh.Ep1; %take the data for cells from that prob bin

for iK = 1:n %for the number of cells in the total set
    x = nanmean(safe{iK}.psth,2);
    mFRsafe(iK,1) = nanmean(x); %calculate the mFR across safe trials
    clear x;
    x = nanmean(eqlow{iK}.psth,2);
    mFReqlow(iK,1) = nanmean(x); %calc the mFR across equiv-low trials
    clear x;
    x = nanmean(eqhigh{iK}.psth,2);
    mFReqhigh(iK,1) = nanmean(x); %calc the mFR across equiv-high trials
end


    for iL = 1:1000
        x = randi(length(probs)); %pick a random prob bin
        pseudolow = in.low.Ep1{x}.cell; %take the data from that bin
        x = randi(length(probs)); %repeat
        pseudohigh = in.high.Ep1{x}.cell; %repeat
        for iK = 1:n %for the number of total neurons
            x = nanmean(pseudolow{iK}.psth,1);
            mFRpseudolow(iK,1) = nanmean(x); %calc the mFR for the random data
            clear x;
            x = nanmean(pseudohigh{iK}.psth,1);
            mFRpseudohigh(iK,1) = nanmean(x); %calc the mFR for the other
        end
        temp1(:,iL) = sort(abs(mFRsafe - mFRpseudolow)); %find the delta between rand selections
        temp2(:,iL) = sort(abs(mFRsafe - mFRpseudohigh)); %find the delta between rand selections
    end
    deltapseudolow = nanmean(temp1,2);
    deltapseudohigh = nanmean(temp2,2);
    
    for iM = 1:length(mFRsafe)
        low(iM,1) = abs(mFRsafe(iM) - mFReqlow(iM));
        low(iM,2) = iM;
        high(iM,1) = abs(mFRsafe(iM) - mFReqhigh(iM));
        high(iM,2) = iM;
    end
    deltalow = sort(low,1); %find the delta for safe-eqlow
    deltahigh = sort(high,1); %find the delta for safe-eqhigh
    %now set a comparison matrix for determining if deltas are meaningfully
    %small
    for iK=1:1000
        rprob = randi(length(probs)-1); %find a random prob
        y = in.low.Ep1{rprob}.cell;
        for iL = 1:n
            mFRrand(iL,1) = nanmean(nanmean(y{iL}.psth));
        end
        rand_low(:,iK) = abs(mFRsafe - mFRrand); %calculate diff
    end
    for iK=1:1000
        rprob = randi(length(probs)-1); %find a random prob
        y = in.high.Ep1{rprob}.cell;
        for iL = 1:n
            mFRrand(iL,1) = nanmean(nanmean(y{iL}.psth));
        end
        rand_high(:,iK) = abs(mFRsafe - mFRrand); %calculate diff
    end
    rand_low = sort(rand_low,2);
    rand_high = sort(rand_high,2);
    
for iJ = 1:length(S_range) %for the total range of S sizes (from 1%-100%)
    %now pick the number of cells corresponding to the stipulated size of S
    S_current{iJ,1} = round(n*S_range(iJ));
    for iK = 1:S_current{iJ,1}
        deltalow_subset{iJ,1}(iK,:) = deltalow(iK,1);
        deltahigh_subset{iJ,1}(iK,:) = deltahigh(iK,1);
        deltapseudolow_subset{iJ,1}(iK,:) = deltapseudolow(iK,:);
        deltapseudohigh_subset{iJ,1}(iK,:) = deltapseudohigh(iK,:);
        rand_low_subset{iJ,1}(iK,:) = rand_low(iK,:);
        rand_high_subset{iJ,1}(iK,:) = rand_high(iK,:);
    end
    
    %now determine if the delta in the subset is meaningfully small
    for iK = 1:S_current{iJ,1}
        y = find(deltalow_subset{iJ,1}(iK,:) < rand_low_subset{iJ,1}(iK,:));
        if isempty(y)
            p{iJ,1}.low(iK,1) = 1;
        else
            p{iJ,1}.low(iK,1) = y(1,1)/1000;
        end
        clear y;
        if round(p{iJ,1}.low(iK,1),2) < 0.05
            p{iJ,1}.low(iK,2) = 1;
        else
            p{iJ,1}.low(iK,2) = 0;
        end
    end
    for iK = 1:S_current{iJ,1}
        y = find(deltapseudolow_subset{iJ,1}(iK,:) < rand_low_subset{iJ,1}(iK,:));
        if isempty(y)
            p{iJ,1}.pseudolow(iK,1) = 1;
        else
            p{iJ,1}.pseudolow(iK,1) = y(1,1)/1000;
        end
        clear y;
        if round(p{iJ,1}.pseudolow(iK,1),2) < 0.05
            p{iJ,1}.pseudolow(iK,2) = 1;
        else
            p{iJ,1}.pseudolow(iK,2) = 0;
        end
    end
    
    for iK = 1:S_current{iJ,1}
        y = find(deltahigh_subset{iJ,1}(iK,:) < rand_high_subset{iJ,1}(iK,:));
        if isempty(y)
            p{iJ,1}.high(iK,1) = 1;
        else
            p{iJ,1}.high(iK,1) = y(1,1)/1000;
        end
        clear y;
        if round(p{iJ,1}.high(iK,1),2) < 0.05
            p{iJ,1}.high(iK,2) = 1;
        else
            p{iJ,1}.high(iK,2) = 0;
        end
    end
    for iK = 1:S_current{iJ,1}
        y = find(deltapseudohigh_subset{iJ,1}(iK,:) < rand_high_subset{iJ,1}(iK,:));
        if isempty(y)
            p{iJ,1}.pseudohigh(iK,1) = 1;
        else
            p{iJ,1}.pseudohigh(iK,1) = y(1,1)/1000;
        end
        clear y;
        if round(p{iJ,1}.pseudohigh(iK,1),2) < 0.05
            p{iJ,1}.pseudohigh(iK,2) = 1;
        else
            p{iJ,1}.pseudohigh(iK,2) = 0;
        end
    end
end
for iJ = 1:length(S_current)
    avg.low(iJ,1) = nanmean(deltalow_subset{iJ});
    avg.pslow(iJ,1) = nanmean(deltapseudolow_subset{iJ});
    avg.high(iJ,1) = nanmean(deltahigh_subset{iJ});
    avg.pshigh(iJ,1) = nanmean(deltapseudohigh_subset{iJ});
    
    sem.low(iJ,1) = nanstd(deltalow_subset{iJ})/sqrt(length(deltalow_subset{iJ}));
    sem.pslow(iJ,1) = nanstd(deltapseudolow_subset{iJ})/sqrt(length(deltapseudolow_subset{iJ}));
    sem.high(iJ,1) = nanstd(deltahigh_subset{iJ})/sqrt(length(deltahigh_subset{iJ}));
    sem.pshigh(iJ,1) = nanstd(deltapseudohigh_subset{iJ}/sqrt(length(deltapseudohigh_subset{iJ})));
end

%% plot subpops
figure;
subplot 121
hold on;
plot(avg.low,'Linewidth',2);
x = avg.low + sem.low;
y = avg.low - sem.low;
plot(x,'b');
plot(y,'b');
plot(avg.pslow,'r','Linewidth',2);
x = avg.pslow + sem.pslow;
y = avg.pslow - sem.pslow;
plot(x,'r');
plot(y,'r');

subplot 122
hold on;
plot(avg.high,'Linewidth',2);
x = avg.high + sem.high;
y = avg.high - sem.high;
plot(x,'b');
plot(y,'b');
plot(avg.pshigh,'r','Linewidth',2);
x = avg.pshigh + sem.pshigh;
y = avg.pshigh - sem.pshigh;
plot(x,'r');
plot(y,'r');

%% sig test
[~,ks.low] = kstest2(avg.low, avg.pslow);
[~,ks.high] = kstest2(avg.high, avg.pshigh);

%% store output
out.avg = avg;
out.sem = sem;
out.ks = ks;
out.p = p; %save output
out.S = S_current;
out.deltalow_subset = deltalow_subset;
out.deltahigh_subset = deltahigh_subset;
out.deltapseudolow_subset = deltapseudolow_subset;
out.deltapseudohigh_subset = deltapseudohigh_subset;

end
