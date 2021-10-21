function out = fit_lc(theta,y,doPlot)
% out = fit_cl(theta,y,doPlot)
%
% linear response, circular predictor

%{
A = 1;
mu = 3;
theta = 0:0.01:4*pi;
ph = pi;
y = mu + A*cos(theta-ph) + rand(size(theta));
%}


% prep
if isrow(theta); theta = theta'; end
X = [cos(theta), sin(theta)];

% fit
mdl = fitglm(X,y);

% get angle estimates
c = mdl.Coefficients.Estimate;
b1 = c(2);
b2 = c(3);

th = atan(b2./b1);
%A = b1 ./ cos(th);
A = sqrt(b1^2+b2^2);
    
% output
out = [];
% out.mdl = mdl;
out.B = mdl.Coefficients.Estimate;
out.Bse = mdl.Coefficients.SE;
out.Bt = mdl.Coefficients.tStat;
out.p = mdl.Coefficients.pValue;
out.p_all = coefTest(mdl);
out.logLike = mdl.LogLikelihood;
out.cname = {'int','cos','sin'};
out.A = A;
out.theta = th;

foo=1;

% plot?
if doPlot
    figure
    plot(theta,y,'k.')
    hold all
    
    t = linspace(min(theta),max(theta),100);
    xx = [cos(t);sin(t)]';
    yy = predict(mdl,xx);
    plot(t,yy,'r-','linewidth',2)
    
end