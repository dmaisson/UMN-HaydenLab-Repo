function [P,S,Pp,Sp] = correlations_class(factor,epoch)

[P,Pp] = corr(factor(:,epoch),factor(:,6),'Type','Pearson');
[S,Sp] = corr(factor(:,epoch),factor(:,6),'Type','Spearman');

end