for iJ = 1:length(subject1)
    subject1{iJ}.psth = Z_score(subject1{iJ}.psth);
end
for iJ = 1:length(subject2)
    subject2{iJ}.psth = Z_score(subject2{iJ}.psth);
end
clear iJ;