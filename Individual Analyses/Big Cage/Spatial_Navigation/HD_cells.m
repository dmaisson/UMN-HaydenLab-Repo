%% Prep
% angle binning
% bin_size = 5;
% for iA = 1:size(OFC,1)
%     binned_angle{iA,1} = spikes2degreebins_resSeries(OFC{iA,1},head_direction,bin_size);
% end

% categorical angle tuning
% for iA = 1:size(OFC,1)
%     categorical{iA,1} = HD_encoding_categorical_fit(OFC{iA},binned_angle{iA,1});
%     sigs(iA,1) = categorical{iA}.p_all;
% end
% sig_rate = (size(find(sigs<0.05),1)/iA)*100;
% sig_idx = find(sigs<0.05);
% for iA = 1:size(sig_idx,1)
%     x = categorical{iA,1}.Coefficients.pValue(2:end,:);
%     sig_angle{iA,1}{1,1} = x(x < 0.05);
%     sig_angle{iA,1}{2,1} = find(x < 0.05);
%     clear x
% end
% for iA = size(sig_angle,1):-1:1
%     if isempty(sig_angle{iA,1}{1})
%         sig_angle(iA,:) = [];
%         sig_idx(iA,:) = [];
%     end
% end
% sig_rate = (size(sig_angle,1)/size(categorical,1))*100;

% angle_specificity
for iA = 1:size(OFC,1)
    HD_tuning_GLM{iA,1} = HD_tuning_glm(OFC{iA},head_direction);
    sigs(iA,1) = HD_tuning_GLM{iA}.p_all;
end

sig_rate = (size(find(sigs<0.05),1)/iA)*100;
sig_idx = find(sigs<0.05);

%%
% for iA = 1:numel(sig_idx)
%     sigs_output{iA,1} = binned_angle{sig_idx(iA,1)};
%     binned_rate(iA,:) = sigs_output{iA,1}.binned_rate;
% end
% 
% degrees = deg2rad(wrapTo180(linspace(0+bin_size,360,360/bin_size)));
% ddegrees = diff(degrees(1:2));
% for i=1:size(binned_rate,1)
%   
%   spk = binned_rate(i,:);
%   
%   % circular mean angle
%   des_stats(i,1) = circ_mean(spk,degrees,2);
%   % circular standard deviation
%   [des_stats(i,2), ~] = circ_std(degrees,spk,ddegrees,2);
% end
% 
% %% plot
% pick  = randperm(size(binned_rate,1));
% figure
% for j = 1:3
%   subplot(1,3,j)
%   sigma = des_stats(pick(j),2);
%   spk = imgaussfilt(binned_rate(pick(j),:),2);
%   % compute and plot mean resultant vector length and direction
%   mw = max(spk);
%   r = circ_r(degrees,spk,ddegrees) * mw;
%   phi = des_stats(pick(j),1);
%   hold on;
%   zm = r*exp(i*phi');
% %   plot([0 real(zm)], [0, imag(zm)],'r','linewidth',1.5)
%   
%   % plot the tuning function of the three neurons 
%   polar([degrees degrees(1)], [spk spk(:,1)],'k')
%   
%   % draw a unit circle
%   zz = exp(i*linspace(0, 2*pi, 101)) * mw;
%   plot(real(zz),imag(zz),'k:')
%   plot([-mw mw], [0 0], 'k:', [0 0], [-mw mw], 'k:')
% 
%   formatSubplot(gca,'ax','square','box','off','lim',[-mw mw -mw mw])
% %   set(gca,'xtick',[])
% %   set(gca,'ytick',[])
% 
% end