%Which structure?
x = 1;
%Integration
currate.R(x,1) = R.Integ.E1.r;
currate.P(x,1) = R.Integ.E1.p;
%Integration 2
currate.R(x,2) = R.Integ.E2.r;
currate.P(x,2) = R.Integ.E2.p;
%Integration Cross-Epoch
currate.R(x,3) = R.Integ.cross.r;
currate.P(x,3) = R.Integ.cross.p;
%Inhibition - EV
currate.R(x,4) = R.Inhib.EV.r;
currate.P(x,4) = R.Inhib.EV.p;
%Inhibition - Prob
currate.R(x,5) = R.Inhib.prob.r;
currate.P(x,5) = R.Inhib.prob.p;
%Inhibition - Size
currate.R(x,6) = R.Inhib.size.r;
currate.P(x,6) = R.Inhib.size.p;
%Alignment
currate.R(x,7) = R.Align.r;
currate.P(x,7) = R.Align.p;
%WM
currate.R(x,8) = R.Add.WM.cor.pearson.r;
currate.P(x,8) = R.Add.WM.cor.pearson.p;