function [fitresult, gof] = createFit_sv(x, y)
%CREATEFIT(X,Y)
%  Create a fit.
%
%  Data for 'sv_Batman' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 23-Nov-2020 13:47:16


%% Fit: 'sv'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'a/(b+exp((b*x)-2))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.915735525189067 0.792207329559554];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'sv' );
% h = plot( fitresult, xData, yData );
% legend( h, 'y vs. x', 'sv', 'Location', 'NorthEast' );
% Label axes
% xlabel x
% ylabel y
% grid on


