function [L] = Latency_Siegel_SimpleReg(data,start,duration)
% %% Compute Omega^2 as measure of max information based on Regression output
% R = OmegaSq(data,155,20);
% % maybe don't need this and just do a sliding window and see which window
% % has the highest W2? (i.e. time bin at whihc information is at maximum)
%% Simple regression on whole set to get betas for window W2s
[R] = Wrapper_SimpleReg_Zvars_latency(data,155,20);

%% Use W2 to determine how long each structure's cells take to get to half
% 100 ms sweeping window: by 20ms increments. 

window = [start:start+duration];
for iJ = 1:size(window,2)
    R.latency{iJ} = OmegaSq_Sliding(data,R,window(iJ),4,1);
end
for iJ = 1:size(window,2)
L.latency.E1(1,iJ) = R.latency{iJ}.slide.W2.E1EV1;
L.latency.E1(2,iJ) = R.latency{iJ}.slide.W2.E1Size1;
L.latency.E1(3,iJ) = R.latency{iJ}.slide.W2.E1Prob1;
L.latency.E1(4,iJ) = R.latency{iJ}.slide.W2.E1Side1;
L.latency.E1(5,iJ) = R.latency{iJ}.slide.W2.E1Choice;
end
for iJ = 1:size(window,2)
L.max.E1EV1 = max(L.latency.E1(1,:));
L.max.E1Size1 = max(L.latency.E1(2,:));
L.max.E1Prob1 = max(L.latency.E1(3,:));
L.max.E1Side1 = max(L.latency.E1(4,:));
L.max.E1Choice = max(L.latency.E1(5,:));
end
clear window

window = [start+50:start+50+duration]; %for Habiba this should be start+33
for iJ = 1:size(window,2)
    R.latency{iJ} = OmegaSq_Sliding(data,R,window(iJ),4,2);
end
for iJ = 1:size(window,2)
L.latency.E2(1,iJ) = R.latency{iJ}.slide.W2.E2EV1;
L.latency.E2(2,iJ) = R.latency{iJ}.slide.W2.E2Size1;
L.latency.E2(3,iJ) = R.latency{iJ}.slide.W2.E2Prob1;
L.latency.E2(4,iJ) = R.latency{iJ}.slide.W2.E2EV2;
L.latency.E2(5,iJ) = R.latency{iJ}.slide.W2.E2Size2;
L.latency.E2(6,iJ) = R.latency{iJ}.slide.W2.E2Prob2;
L.latency.E2(7,iJ) = R.latency{iJ}.slide.W2.E2Side1;
L.latency.E2(8,iJ) = R.latency{iJ}.slide.W2.E2Choice;
end
for iJ = 1:size(window,2)
L.max.E2EV1 = max(L.latency.E2(1,:));
L.max.E2Size1 = max(L.latency.E2(2,:));
L.max.E2Prob1 = max(L.latency.E2(3,:));
L.max.E2EV2 = max(L.latency.E2(4,:));
L.max.E2Size2 = max(L.latency.E2(5,:));
L.max.E2Prob2 = max(L.latency.E2(6,:));
L.max.E2Side1 = max(L.latency.E2(7,:));
L.max.E2Choice = max(L.latency.E2(8,:));
end

window = [start+100:start+100+duration]; % for Habiba, start+66:start+66+66
for iJ = 1:size(window,2)
    R.latency{iJ} = OmegaSq_Sliding(data,R,window(iJ),4,3);
end
for iJ = 1:size(window,2)
L.latency.E3(1,iJ) = R.latency{iJ}.slide.W2.E3EV1;
L.latency.E3(2,iJ) = R.latency{iJ}.slide.W2.E3EV2;
L.latency.E3(3,iJ) = R.latency{iJ}.slide.W2.E3Side1;
L.latency.E3(4,iJ) = R.latency{iJ}.slide.W2.E3Choice;
end
for iJ = 1:size(window,2)
L.max.E3EV1 = max(L.latency.E3(1,:));
L.max.E3EV2 = max(L.latency.E3(2,:));
L.max.E3Side1 = max(L.latency.E3(3,:));
L.max.E3Choice = max(L.latency.E3(4,:));
end
clear R window iJ start duration
end