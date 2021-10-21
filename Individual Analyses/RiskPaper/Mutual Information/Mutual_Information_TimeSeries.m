function [MuIn,sigrate] = Mutual_Information_TimeSeries(input)

%% Starting variables
safeEp1 = input.safe.Ep1;
safeEp2 = input.safe.Ep2;
lowEp1 = input.eqlow.Ep1;
lowEp2 = input.eqlow.Ep1;
highEp1 = input.eqhigh.Ep1;
highEp2 = input.eqhigh.Ep2;
n = length(safeEp1);
clear low high x probs input;

%% Mutual information - Ep1
%control
    for iK = 1:1000
        r2 = randi(size(safeEp1,1)); %pick a random cell
        r5 = randi(size(safeEp1,1)); %pick another random cell 
        r3 = randi(3); %randomly pick a condition
        if r3 == 1 %if condition is safe
            s = size(safeEp1{r2}.psth,1); 
            r1 = randi(s); %pick a random trial number
            rseq = randperm(size(safeEp1{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = safeEp1{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        elseif r3 == 2
            s = size(lowEp1{r2}.psth,1);
            r1 = randi(s);
            rseq = randperm(size(lowEp1{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = lowEp1{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        elseif r3 == 3
            s = size(highEp1{r2}.psth,1);
            r1 = randi(s);
            rseq = randperm(size(highEp1{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = highEp1{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        end
        r6 = randi(3); %randomly pick another condition
        if r6 == 1
            s = size(safeEp1{r5}.psth,1);
            r4 = randi(s); %pick a random trial
            rseq = randperm(size(safeEp1{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = safeEp1{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        elseif r6 == 2
            s = size(lowEp1{r5}.psth,1);
            r4 = randi(s);
            rseq = randperm(size(lowEp1{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = lowEp1{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        elseif r6 == 3
            s = size(highEp1{r5}.psth,1);
            r4 = randi(s);
            rseq = randperm(size(highEp1{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = highEp1{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        end
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
        r2 = randi(size(safeEp2,1)); %pick a random cell
        r5 = randi(size(safeEp2,1)); %pick another random cell 
        r3 = randi(3); %randomly pick a condition
        if r3 == 1 %if condition is safe
            s = size(safeEp2{r2}.psth,1); 
            r1 = randi(s); %pick a random trial number
            rseq = randperm(size(safeEp2{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = safeEp2{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        elseif r3 == 2
            s = size(lowEp2{r2}.psth,1);
            r1 = randi(s);
            rseq = randperm(size(lowEp2{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = lowEp2{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        elseif r3 == 3
            s = size(highEp2{r2}.psth,1);
            r1 = randi(s);
            rseq = randperm(size(highEp2{r2}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                x(iJ,:) = highEp2{r2}.psth(r1,iJ); %set one column vector to that random trial
            end
        end
        r6 = randi(3); %randomly pick another condition
        if r6 == 1
            s = size(safeEp2{r5}.psth,1);
            r4 = randi(s); %pick a random trial
            rseq = randperm(size(safeEp2{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = safeEp2{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        elseif r6 == 2
            s = size(lowEp2{r5}.psth,1);
            r4 = randi(s);
            rseq = randperm(size(lowEp2{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = lowEp2{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        elseif r6 == 3
            s = size(highEp2{r5}.psth,1);
            r4 = randi(s);
            rseq = randperm(size(highEp2{r5}.psth,2)); %shuffle the time axis in the selected timeseries
            for iJ = 1:size(rseq,2)
                y(iJ,:) = highEp2{r5}.psth(r4,iJ); %set one column vector to that random trial
            end
        end
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
