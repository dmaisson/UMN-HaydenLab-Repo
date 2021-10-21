function output = canonical_corr_PCs(input)
X = input.safelow(:,1:3);
Y = input.lowsafe(:,1:3);
[output.safelow.A,output.safelow.B,output.safelow.r,output.safelow.U,output.safelow.V,output.safelow.stats] = canoncorr(X,Y);

X = input.safehigh(:,1:3);
Y = input.highsafe(:,1:3);
[output.safehigh.A,output.safehigh.B,output.safehigh.r,output.safehigh.U,output.safehigh.V,output.safehigh.stats] = canoncorr(X,Y);