function CI = confidence_interval(in,alpha)
% input must be a column vector
% alpha is the confidence interval

x_mean = nanmean(in);
sd = nanstd(in);
n = size(in,1);

CI(:,1) = x_mean - alpha*(sd);%/sqrt(n));
CI(:,2) = x_mean + alpha*(sd);%/sqrt(n));