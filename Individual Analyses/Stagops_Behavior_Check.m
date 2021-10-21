function output = Stagops_Behavior_Check(input)

input = input';
for iJ = 1:size(input,1)
    output.newData(iJ,1) = input{iJ}.prob1;
    output.newData(iJ,2) = input{iJ}.size1;
    output.newData(iJ,3) = input{iJ}.ev1;
    output.newData(iJ,4) = input{iJ}.prob2;
    output.newData(iJ,5) = input{iJ}.size1;
    output.newData(iJ,6) = input{iJ}.ev2;
    output.newData(iJ,7) = input{iJ}.firstLeft;
    output.newData(iJ,8) = input{iJ}.choseLeft;
    output.newData(iJ,9) = input{iJ}.chosen;
    output.newData(iJ,10) = input{iJ}.outcome;
end

evDiff = output.newData(:,3) - output.newData(:,6);

evDiff(:,2) = output.newData(:,9);

EV_diff_range = linspace(-240,240,20);
EV_diff_range(1,end+1) = 999;

output.EV_diff_bins = zeros(size(EV_diff_range,2),1);

for iJ = 1:size(evDiff,1) % for each trial
    for iK = 1:size(EV_diff_range,2)-1 % for each diff_bin
        if evDiff(iJ,1) >= EV_diff_range(1,iK) && evDiff(iJ,1) < EV_diff_range(1,iK+1) % if evDiff on that trial is within the range of bin x and bin x+1
            if evDiff(iJ,2) == 1 % check the choice that was made...if it was for choice 1
                output.EV_diff_bins(iK,1) = output.EV_diff_bins(iK,1) + 1; % add a counter
            end
        end
    end
end

output.EV_diff_bins(end,:) = [];
output.EV_diff_bins = (output.EV_diff_bins/iJ)*100;
EV_diff_range = EV_diff_range';
output.EV_diff_bins(:,2) = EV_diff_range(1:20,1);

figure;
plot(output.EV_diff_bins(:,2),output.EV_diff_bins(:,1));
hline(50); vline(0,0);
xlabel('EV1 - EV2');
ylabel('prob of choosing offer 1');
ylim([0 100]);

save('Behavior_summary','-v7.3');

end