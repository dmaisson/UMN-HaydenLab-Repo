function [out,SEM] = Classification_multi_EVbins(input,token,iterations)

accuracy(1:iterations,1:3) = NaN;

parfor iJ = 1:iterations
    out = regress_SVM_EVbins(input,token);
    out1(iJ,1) = out(1,1);
    out2(iJ,1) = out(1,2);
    out3(iJ,1) = out(1,3);
end
accuracy(:,1) = out1;
accuracy(:,2) = out2;
accuracy(:,3) = out3;
out = mean(accuracy,1);
SEM = std(accuracy,0,1)/sqrt(length(accuracy));

end