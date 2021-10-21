%Which structure?
x = 1;
%Integration
currateR_p(x,1) = R.Figure3.Integ.cor.pearson.r;
currateP_p(x,1) = R.Figure3.Integ.cor.pearson.p;
%Integration 2
currateR_p(x,2) = R.Add.Integ2.cor.pearson.r;
currateP_p(x,2) = R.Add.Integ2.cor.pearson.p;
%Integration Cross
currateR_p(x,3) = R.Add.XInteg.cor.pearson.r;
currateP_p(x,3) = R.Add.XInteg.cor.pearson.p;
%Inhibition
currateR_p(x,4) = R.Figure4.Inhib.cor.pearson.r;
currateP_p(x,4) = R.Figure4.Inhib.cor.pearson.p;
%Alignment
currateR_p(x,5) = R.Figure4.Align.cor.pearson.r;
currateP_p(x,5) = R.Figure4.Align.cor.pearson.p;
%WM
currateR_p(x,6) = R.Add.WM.cor.pearson.r;
currateP_p(x,6) = R.Add.WM.cor.pearson.p;
%% Save
clearvars -except currate
cd 'C:\Users\david\Desktop'
save ('currate.mat','-v7.3');