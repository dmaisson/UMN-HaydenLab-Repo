n1 = 85;
n2 = length(data) - n1;
for iJ = 1:n1
    subject1{iJ,1}.vars = data{iJ}.vars;
    subject1{iJ,1}.psth = data{iJ}.psth;
end
for iJ = 1:n2
    subject2{iJ,1}.vars = data{n1+iJ}.vars;
    subject2{iJ,1}.psth = data{n1+iJ}.psth;
end
clear n1 n2 data iJ;