n = size(OFC_HDvars{1}.degreeSeries,1);
s = 180000;
Fs = 30;
n = size(OFC_HDvars{1}.degreeSeries,1);
yt = OFC_HDvars{1}.resSeries';
xt{1} = OFC_HDvars{1}.degreeSeries';
for iA = 1:n
    xt{iA,1} = OFC_HDvars{1}.degreeSeries(iA,:)';
end

degree = linspace(6,360,n);
degree = degree - ((360/n)/2);
for iA = 1:n
    prs.varname{1,iA} = degree(1,iA);
    prs.vartype{1,iA} = '1Dcirc';
    prs.basistype{1,iA} = [];
    prs.nbins{1,iA} = n;
    if iA == 1
        prs.binrange{1,iA} = [(degree(1,iA) - degree(1,iA))+((360/n)/2);degree(1,iA)+((360/n)/2)];
    else
        prs.binrange{1,iA} = [degree(1,iA-1)+((360/n)/2); degree(1,iA)+((360/n)/2)];
    end    
end
prs.nfolds = 1;
prs.dt = 1/Fs;
prs.filtwidth = prs.dt*2;
prs.linkfunc = 'identity';
prs.lamba = 0;
prs.alpha = 0.05;
prs.varchoose(1,1:n) = 0;
prs.method = 'Forward';

models = BuildGAM(xt,yt,prs);