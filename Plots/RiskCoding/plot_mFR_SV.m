function avg = plot_mFR_SV(in,sv)
probs = 0:0.05:1; probs(7) = 0.3;

%% Separate data by epoch, offer type, and prob range
% get rid of all trils on which prob = 0
for iJ = 1:length(in)
    for iK = length(in{iJ}.vars):-1:1
        if in{iJ}.vars(iK,2) == 0 || in{iJ}.vars(iK,5) == 0
            in{iJ}.vars(iK,:) = [];
            in{iJ}.psth(iK,:) = [];
        end
    end
end
% create an empty set of matrices
for iJ = 1:length(probs)-1
    for iK = 1:length(in)
        safe{iK,1}.psth(1:10,1:75) = NaN;
        templow{iJ,1}.cell{iK,1}.psth(1:10,1:75) = NaN;
        temphigh{iJ,1}.cell{iK,1}.psth(1:10,1:75) = NaN;
    end
end

% fill the empty matrices with data from the trials and spikes
for iJ = 1:length(in)
    for iK = 1:length(in{iJ}.vars)
        if in{iJ}.vars(iK,2) == 1
            % 1. safe offers
            safe{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,125:199);
        elseif in{iJ}.vars(iK,2) == 2
            % 2. risky offers with low stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    templow{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,125:199);
                end
            end
        elseif in{iJ}.vars(iK,2) == 3
            % 3. risky offers with high stakes
            for iL = 1:length(probs)-1
                if in{iJ}.vars(iK,1) > probs(iL) && ...
                        in{iJ}.vars(iK,1) < probs(iL+1) %if prob is in range
                    temphigh{iL,1}.cell{iJ,1}.psth(iK,:) = in{iJ}.psth(iK,125:199);
                end
            end
        end
    end
end

if sv.high == 0
    sv.high = 0.05;
end
svlow = interp1(probs,probs,sv.low,'nearest');
svhigh = interp1(probs,probs,sv.high,'nearest');
x = find(svlow == probs);
low = templow{x}.cell;
x = find(svhigh == probs);
high = temphigh{x}.cell;
clear x templow temphigh svlow svhigh probs iJ iK iL sv;

%% Calc mean FR
for iJ = 1:length(safe)
    avg{iJ}.safe = smoothdata(nanmean(safe{iJ}.psth)*50);
    avg{iJ}.low = smoothdata(nanmean(low{iJ}.psth)*50);
    avg{iJ}.high = smoothdata(nanmean(high{iJ}.psth)*50);
end
clear safe low high iJ;

%%
x = -0.5:0.02:0.98;

figure;
hold on;
plot(x,avg{1}.safe,'Linewidth',2);
plot(x,avg{1}.low,'Linewidth',2);
plot(x,avg{1}.high,'Linewidth',2);
vline(0,0);
vline(0.4,0);
xlabel('time (s)');
ylabel('mean firing rate (spikes/s');
legend('safe offer', 'low risk offer','high risk offer');

figure;
hold on;
plot(x,avg{2}.safe,'Linewidth',2);
plot(x,avg{2}.low,'Linewidth',2);
plot(x,avg{2}.high,'Linewidth',2);
vline(0,0);
vline(0.4,0);
xlabel('time (s)');
ylabel('mean firing rate (spikes/s');
legend('safe offer', 'low risk offer','high risk offer');

end

