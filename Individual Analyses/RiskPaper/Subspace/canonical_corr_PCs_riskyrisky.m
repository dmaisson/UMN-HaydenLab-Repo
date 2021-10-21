function output = canonical_corr_PCs_riskyrisky(input)
X = input.lowhigh(:,1:3);
Y = input.highlow(:,1:3);
[output.A,output.B,output.r,output.U,output.V,output.stats] = canoncorr(X,Y);