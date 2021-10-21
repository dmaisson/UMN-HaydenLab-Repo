function [out,SEM] = Classification_SV(input,iterations)

accuracy(1:iterations,1:5) = NaN;

parfor iJ = 1:iterations
    [outa,outb,outc,outd,oute] = Classifier_SV(input);
    out1(iJ,1) = outa;
    out2(iJ,1) = outb;
    out3(iJ,1) = outc;
    out4(iJ,1) = outd;
    out5(iJ,1) = oute;
end
accuracy(:,1) = out1;
accuracy(:,2) = out2;
accuracy(:,3) = out3;
accuracy(:,4) = out4;
accuracy(:,5) = out5;
out = mean(accuracy,1);
SEM = std(accuracy,0,1)/sqrt(length(accuracy));

end