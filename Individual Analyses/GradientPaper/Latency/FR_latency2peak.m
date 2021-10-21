function [output] = FR_latency2peak(input,token)
% Extract FR from mod rate and make pseudo-pop
for iJ = 1:length(input)
    if token == 0
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,205:229);
        start{iJ,1}.vars = input{iJ}.vars;
    elseif token == 1
        start{iJ,1}.E1FR = input{iJ}.psth(:,155:179);
        start{iJ,1}.E2FR = input{iJ}.psth(:,193:217);
        start{iJ,1}.vars = input{iJ}.vars;
    end
end
%clear trials with NaN FRs
for iJ = 1:length(start)
    for iK = length(start{iJ}.E1FR):-1:1
        if isnan(start{iJ}.E1FR(iK,1))
            start{iJ}.E1FR(iK,:) = [];
            start{iJ}.E2FR(iK,:) = [];
            start{iJ}.vars(iK,:) = [];
        end
    end
    for iK = length(start{iJ}.E2FR):-1:1
        if isnan(start{iJ}.E2FR(iK,1))
            start{iJ}.E1FR(iK,:) = [];
            start{iJ}.E2FR(iK,:) = [];
            start{iJ}.vars(iK,:) = [];
        end
    end
end     

%% correlate each time bin to
for iJ = 1:length(start)
    for iK = 1:size(start{iJ}.E1FR,2)
        [~,EV1corr(iJ,iK)] = corr(start{iJ}.E1FR(:,iK), start{iJ}.vars(:,3));
        [~,EV2corr(iJ,iK)] = corr(start{iJ}.E2FR(:,iK), start{iJ}.vars(:,6));
    end
end
for iJ = 1:size(EV1corr,1)
    x = find(EV1corr(iJ,:) < 0.05);
    if isempty(x)
        threshold(iJ,1) = 0;
    else
        threshold(iJ,1) = x(1,1);
    end
    x = find(EV2corr(iJ,:) < 0.05);
    if isempty(x)
        threshold(iJ,2) = 0;
    else
        threshold(iJ,2) = x(1,1);
    end
    threshold(iJ,1) = threshold(iJ,1)*50;
    threshold(iJ,2) = threshold(iJ,2)*50;
end

%%
% ADD a REMOVAL step for anything that isn't significantly
% correlated...(i.e. when threshold got set to 0 artificially)
% for iJ = size(threshold,1):-1:1
%     if threshold(iJ,1) == 0 || threshold(iJ,2) == 0
%         start(iJ) = [];
%     end
% end

%% find mean FR for each neuron across trials
for iJ = 1:length(start)
    x = start{iJ}.E1FR;
    E1FR(iJ,:) = nanmean(x,1); clear x;
    x = start{iJ}.E2FR;
    E2FR(iJ,:) = nanmean(x,1); clear x;
end

% find index of greatest among mean vectors
for iJ = 1:size(start,1)
    x = find(E1FR(iJ,:) == max(E1FR(iJ,:)));
    peak(iJ,1) = (x(1) * 50); clear x;
    x = find(E2FR(iJ,:) == max(E2FR(iJ,:)));
    peak(iJ,2) = (x(1) * 50);
end
% Calculate time in ms to go from threshold to peak firing
for iJ = 1:size(peak,1)
    out_T2Pk(iJ,1) = peak(iJ,1) - threshold(iJ,1);
    out_T2Pk(iJ,2) = peak(iJ,2) - threshold(iJ,2);
end
% Calculate time in ms to go from start to threshold
for iJ = 1:size(threshold,1)
    out_S2Pk(iJ,1) = threshold(iJ,1);
    out_S2Pk(iJ,2) = threshold(iJ,2);
end
% for iJ = size(out_S2Pk,1):-1:1
%     if out_S2Pk(iJ,1) == 0 || out_S2Pk(iJ,2) == 0
%         out_S2Pk(iJ,:) = [];
%     end
% end

output.T2Pk(:,1) = nanmean(out_T2Pk(:,1),1);
output.T2Pk(:,2) = (nanstd(out_T2Pk(:,1),1))/sqrt(length(out_T2Pk(:,1)));
output.T2Pk(:,3) = nanmean(out_T2Pk(:,2),1);
output.T2Pk(:,4) = (nanstd(out_T2Pk(:,2),1))/sqrt(length(out_T2Pk(:,2)));

output.S2T(:,1) = nanmean(out_S2Pk(:,1),1);
output.S2T(:,2) = (nanstd(out_S2Pk(:,1),1))/sqrt(length(out_S2Pk(:,1)));
output.S2T(:,3) = nanmean(out_S2Pk(:,2),1);
output.S2T(:,4) = (nanstd(out_S2Pk(:,2),1))/sqrt(length(out_S2Pk(:,2)));

clear input iJ Habiba E1FR E2FR;

end