function [currate] = currate_mod(R)

%Integration
currate.R.format(1,1) = R.Integ.E1.r.format;
currate.P.format(1,1) = R.Integ.E1.p.format;
%Integration 2
currate.R.format(1,2) = R.Integ.E2.r.format;
currate.P.format(1,2) = R.Integ.E2.p.format;
%Integration Cross-Epoch
currate.R.format(1,3) = R.Integ.cross.r.format;
currate.P.format(1,3) = R.Integ.cross.p.format;
%Inhibition - EV
currate.R.format(1,4) = R.Inhib.EV.r.format;
currate.P.format(1,4) = R.Inhib.EV.p.format;
%Inhibition - Prob
currate.R.format(1,5) = R.Inhib.prob.r.format;
currate.P.format(1,5) = R.Inhib.prob.p.format;
%Inhibition - Size
currate.R.format(1,6) = R.Inhib.size.r.format;
currate.P.format(1,6) = R.Inhib.size.p.format;
%Alignment
currate.R.format(1,7) = R.Align.r.format;
currate.P.format(1,7) = R.Align.p.format;
%WM
currate.R.format(1,8) = R.WM.r.format;
currate.P.format(1,8) = R.WM.p.format;

%% Pop
%Integration
currate.R.pop(1,1) = R.Integ.E1.r.pop;
currate.P.pop(1,1) = R.Integ.E1.p.pop;
%Integration 2
currate.R.pop(1,2) = R.Integ.E2.r.pop;
currate.P.pop(1,2) = R.Integ.E2.p.pop;
%Integration Cross-Epoch
currate.R.pop(1,3) = R.Integ.cross.r.pop;
currate.P.pop(1,3) = R.Integ.cross.p.pop;
%Inhibition - EV
currate.R.pop(1,4) = R.Inhib.EV.r.pop;
currate.P.pop(1,4) = R.Inhib.EV.p.pop;
%Inhibition - Prob
currate.R.pop(1,5) = R.Inhib.prob.r.pop;
currate.P.pop(1,5) = R.Inhib.prob.p.pop;
%Inhibition - Size
currate.R.pop(1,6) = R.Inhib.size.r.pop;
currate.P.pop(1,6) = R.Inhib.size.p.pop;
%Alignment
currate.R.pop(1,7) = R.Align.r.pop;
currate.P.pop(1,7) = R.Align.p.pop;
%WM
currate.R.pop(1,8) = R.WM.r.pop;
currate.P.pop(1,8) = R.WM.p.pop;

end