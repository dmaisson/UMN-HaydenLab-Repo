set = subject1;%'check some days'

for iJ = 1:size(set,1)
    for iK = 1:length(set{iJ}.vars)
        x{iJ}.vars(iK,1) = set{iJ}.vars(iK,3) - set{iJ}.vars(iK,6);
%         x{iJ}.vars(iK,1) = set{iJ}.oldvars(iK,3) - set{iJ}.oldvars(iK,4);
%         x{iJ}.vars(iK,1) = set{iJ}.oldvars(iK,6) - set{iJ}.oldvars(iK,7);
%         x{iJ}.vars(iK,1) = (set{iJ}.oldvars(iK,3) * set{iJ}.oldvars(iK,6)) - (set{iJ}.oldvars(iK,4) * set{iJ}.oldvars(iK,7));
        if set{iJ}.vars(iK,9) == 1
            y{iJ}.vars(iK,1) = 1;
        else
            y{iJ}.vars(iK,1) = 0;
        end
        z(iJ) = corr(x{iJ}.vars,y{iJ}.vars);
    end
end
x = x';
y = y';
z = z';
hold on;
plot(z)
% legend('Area11','Area13','Area14','Area24','Area32','PCC','VS');
xlabel('Cell Number'); ylabel('R of EV1-EV2 and P(Choose Offer1)');