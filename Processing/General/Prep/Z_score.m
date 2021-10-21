function [y] = Z_score(x)
%Z-Score

y = (x - nanmean(x(:))) ./ nanstd(x(:));

end

