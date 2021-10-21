function [MuIn,sigrate] = Mutual_Information_TimeSeries_nonEq(input)

%% Starting variables
safeEp1 = input.safe.Ep1;
safeEp2 = input.safe.Ep2;
which_prob = randi(size(input.low.Ep1,1));
lowEp1 = input.low.Ep1{which_prob}.cell;
lowEp2 = input.low.Ep2{which_prob}.cell;
which_prob = randi(size(input.high.Ep1,1));
highEp1 = input.high.Ep1{which_prob}.cell;
highEp2 = input.high.Ep2{which_prob}.cell;
n = size(safeEp1,1);
clear low high x probs input;

for iJ = n:-1:1
    if size(safeEp1{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
    if size(safeEp2{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
    if size(lowEp1{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
    if size(lowEp2{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
    if size(highEp1{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
    if size(highEp2{iJ}.psth,1) < 1
        safeEp1(iJ) = [];
        safeEp2(iJ) = [];
        lowEp1(iJ) = [];
        lowEp2(iJ) = [];
        highEp1(iJ) = [];
        highEp2(iJ) = [];
    end
end
n = size(safeEp1,1);

%% Mutual information - Ep1
%control
for iK = 1:1000
    r1 = randi(n); % randomly select a neuron
    rseq = randperm(size(safeEp1{r1}.psth,2));
    r2 = randi(size(safeEp1{r1}.psth,1)); % randomly select a trial
    for iL = 1:size(rseq,2)
        x(iL,1) = safeEp1{r1}.psth(r2,iL);
    end
    r3 = randi(3); % randomly select a condition (safe,med,high)
    if r3 == 1
        r1 = randi(n); % randomly select a neuron
        rseq = randperm(size(safeEp1{r1}.psth,2));
        r2 = randi(size(safeEp1{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = safeEp1{r1}.psth(r2,iL);
        end
    elseif r3 == 2
        r1 = randi(n); % randomly select a neuron
        rseq = randperm(size(lowEp1{r1}.psth,2));
        r2 = randi(size(lowEp1{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = lowEp1{r1}.psth(r2,iL);
        end
    elseif r3 == 3
        r1 = randi(n); % randomly select a neuron
        rseq = randperm(size(highEp1{r1}.psth,2));
        r2 = randi(size(highEp1{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = highEp1{r1}.psth(r2,iL);
        end
    end
    % shuffle the timeseries
    mu_inf(iK) = MutualInformation(x,y); %calculate the mi between the two random column vectors
end
MuIn.Ep1.control.samples = sort(mu_inf); %sort the 1000 interations
MuIn.Ep1.control.avg = mean(mu_inf);
MuIn.Ep1.control.SEM = std(mu_inf)/sqrt(iK);

%safe_low
for iJ = 1:size(safeEp1,1) %for each neuron
    for iK = 1:1000
        s1 = size(safeEp1{iJ}.psth,1); 
        r1 = randi(s1); %randomly pick a trial
        s2 = size(lowEp1{iJ}.psth,1);
        r2 = randi(s2); %randomly pick another trial
        x = safeEp1{iJ}.psth(r1,:)';
        y = lowEp1{iJ}.psth(r2,:)';
        mu_inf(iK) = MutualInformation(x,y); %compute mi between random trials for same cell
    end
    MuIn.Ep1.safe_low.samples(iJ,:) = sort(mu_inf); %sort the mi results
    MuIn.Ep1.safe_low.avg(iJ,:) = mean(mu_inf); %calculate the average
    MuIn.Ep1.safe_low.SEM(iJ,:) = std(mu_inf)/sqrt(iK);
    rank = find(MuIn.Ep1.safe_low.avg(iJ,:) > MuIn.Ep1.control.samples); %find how many control mi.s are smaller
    if isempty(rank)
        MuIn.Ep1.safe_low.p(iJ,:) = 0;
    else
        MuIn.Ep1.safe_low.p(iJ,:) = length(rank)/iK; %compute the proportion of controls smaller than actual
    end
end

%safe_high
for iJ = 1:size(safeEp1,1)
    for iK = 1:1000
        s1 = size(safeEp1{iJ}.psth,1);
        r1 = randi(s1);
        s2 = size(highEp1{iJ}.psth,1);
        r2 = randi(s2);
        x = safeEp1{iJ}.psth(r1,:)';
        y = highEp1{iJ}.psth(r2,:)';
        mu_inf(iK) = MutualInformation(x,y);
    end
    MuIn.Ep1.safe_high.samples(iJ,:) = sort(mu_inf);
    MuIn.Ep1.safe_high.avg(iJ,:) = mean(mu_inf);
    MuIn.Ep1.safe_high.SEM(iJ,:) = std(mu_inf)/sqrt(iK);
    rank = find(MuIn.Ep1.safe_high.avg(iJ,:) > MuIn.Ep1.control.samples);
    if isempty(rank)
        MuIn.Ep1.safe_high.p(iJ,:) = 0;
    else
        MuIn.Ep1.safe_high.p(iJ,:) = length(rank)/iK;
    end
end

%% Epoch 2
%control
for iK = 1:1000
    r1 = randi(size(safeEp2,1)); % randomly select a neuron
    rseq = randperm(size(safeEp2{r1}.psth,2));
    r2 = randi(size(safeEp2{r1}.psth,1)); % randomly select a trial
    for iL = 1:size(rseq,2)
        x(iL,1) = safeEp2{r1}.psth(r2,iL);
    end
    r3 = randi(3); % randomly select a condition (safe,med,high)
    if r3 == 1
        r1 = randi(size(safeEp2,1)); % randomly select a neuron
        rseq = randperm(size(safeEp2{r1}.psth,2));
        r2 = randi(size(safeEp2{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = safeEp2{r1}.psth(r2,iL);
        end
    elseif r3 == 2
        r1 = randi(size(lowEp2,1)); % randomly select a neuron
        rseq = randperm(size(lowEp2{r1}.psth,2));
        r2 = randi(size(lowEp2{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = lowEp2{r1}.psth(r2,iL);
        end
    elseif r3 == 3
        r1 = randi(size(highEp2,1)); % randomly select a neuron
        rseq = randperm(size(highEp2{r1}.psth,2));
        r2 = randi(size(highEp2{r1}.psth,1)); % randomly select a trial
        for iL = 1:size(rseq,2)
            y(iL,1) = highEp2{r1}.psth(r2,iL);
        end
    end
    % shuffle the timeseries
    mu_inf(iK) = MutualInformation(x,y); %calculate the mi between the two random column vectors
end
MuIn.Ep2.control.samples = sort(mu_inf); %sort the 1000 interations
MuIn.Ep2.control.avg = mean(mu_inf);
MuIn.Ep2.control.SEM = std(mu_inf)/sqrt(iK);

%safe_low
for iJ = 1:size(safeEp2,1)
    for iK = 1:1000
        s1 = size(safeEp2{iJ}.psth,1);
        r1 = randi(s1);
        s2 = size(lowEp2{iJ}.psth,1);
        r2 = randi(s2);
        x = safeEp2{iJ}.psth(r1,:)';
        y = lowEp2{iJ}.psth(r2,:)';
        mu_inf(iK) = MutualInformation(x,y);
    end
    MuIn.Ep2.safe_low.samples(iJ,:) = sort(mu_inf);
    MuIn.Ep2.safe_low.avg(iJ,:) = mean(mu_inf);
    MuIn.Ep2.safe_low.SEM(iJ,:) = std(mu_inf)/sqrt(iK);
    rank = find(MuIn.Ep2.safe_low.avg(iJ,:) > MuIn.Ep2.control.samples);
    if isempty(rank)
        MuIn.Ep2.safe_low.p(iJ,:) = 0;
    else
        MuIn.Ep2.safe_low.p(iJ,:) = length(rank)/iK;
    end
end

%safe_high
for iJ = 1:size(safeEp2,1)
    for iK = 1:1000
        s1 = size(safeEp2{iJ}.psth,1);
        r1 = randi(s1);
        s2 = size(highEp2{iJ}.psth,1);
        r2 = randi(s2);
        x = safeEp2{iJ}.psth(r1,:)';
        y = highEp2{iJ}.psth(r2,:)';
        mu_inf(iK) = MutualInformation(x,y);
    end
    MuIn.Ep2.safe_high.samples(iJ,:) = sort(mu_inf);
    MuIn.Ep2.safe_high.avg(iJ,:) = mean(mu_inf);
    MuIn.Ep2.safe_high.SEM(iJ,:) = std(mu_inf)/sqrt(iK);
    rank = find(MuIn.Ep2.safe_high.avg(iJ,:) > MuIn.Ep2.control.samples);
    if isempty(rank)
        MuIn.Ep2.safe_high.p(iJ,:) = 0;
    else
        MuIn.Ep2.safe_high.p(iJ,:) = length(rank)/iK;
    end
end

f = find(MuIn.Ep1.safe_low.p >= 0.95);
sigrate.Ep1.safe_low = (length(f)/size(MuIn.Ep1.safe_low.p,1))*100;
f = find(MuIn.Ep1.safe_high.p >= 0.95);
sigrate.Ep1.safe_high = (length(f)/size(MuIn.Ep1.safe_high.p,1))*100;

f = find(MuIn.Ep2.safe_low.p >= 0.95);
sigrate.Ep2.safe_low = (length(f)/size(MuIn.Ep2.safe_low.p,1))*100;
f = find(MuIn.Ep2.safe_high.p >= 0.95);
sigrate.Ep2.safe_high = (length(f)/size(MuIn.Ep2.safe_high.p,1))*100;

end
