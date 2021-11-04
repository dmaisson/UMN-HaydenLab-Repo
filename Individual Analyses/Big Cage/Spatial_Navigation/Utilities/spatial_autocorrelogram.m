function autocorrelogram = spatial_autocorrelogram(binned_rates,x_axis)

x_shift = 0:x_axis-1;
y_shift = x_shift;
for iA = 1:size(x_shift,2)
    for iB = 1:size(y_shift,2)
        x = binned_rates;
        y = circshift(binned_rates,(x_shift(iA)),1);
        y = circshift(y,-1*(y_shift(iB)),2);
        a = x(1+x_shift(iA):end,1:end-y_shift(iB));
        b = y(1+x_shift(iA):end,1:end-y_shift(iB));
        a = a(:);
        b = b(:);
        upper_left(iA,iB) = corr(a,b);
        clear x y a b 
    end
end
upper_left = flip(upper_left,2);
clear iA iB
for iA = 1:size(x_shift,2)
    for iB = 1:size(y_shift,2)
        x = binned_rates;
        y = circshift(binned_rates,x_shift(iA),1);
        y = circshift(y,y_shift(iB),2);
        a = x(1+x_shift(iA):end,1+y_shift(iB):end);
        b = y(1+x_shift(iA):end,1+y_shift(iB):end);
        a = a(:);
        b = b(:);
        upper_right(iA,iB) = corr(a,b);
        clear x y a b 
    end
end
clear iA iB
for iA = 1:size(x_shift,2)
    for iB = 1:size(y_shift,2)
        x = binned_rates;
        y = circshift(binned_rates,-1*(x_shift(iA)),1);
        y = circshift(y,-1*(y_shift(iB)),2);
        a = x(1:end-x_shift(iA),1:end-y_shift(iB));
        b = y(1:end-x_shift(iA),1:end-y_shift(iB));
        a = a(:);
        b = b(:);
        lower_left(iA,iB) = corr(a,b);
        clear x y a b 
    end
end
lower_left = flip(lower_left,2);
lower_left = flip(lower_left,1);
clear iA iB
for iA = 1:size(x_shift,2)
    for iB = 1:size(y_shift,2)
        x = binned_rates;
        y = circshift(binned_rates,-1*(x_shift(iA)),1);
        y = circshift(y,(y_shift(iB)),2);
        a = x(1:end-x_shift(iA),1+y_shift(iB):end);
        b = y(1:end-x_shift(iA),1+y_shift(iB):end);
        a = a(:);
        b = b(:);
        lower_right(iA,iB) = corr(a,b);
        clear x y a b 
    end
end
lower_right = flip(lower_right,1);
clear iA iB

upper_half = cat(2,upper_left,upper_right);
lower_half = cat(2,lower_left,lower_right);
autocorrelogram = cat(1,lower_half,upper_half);
clearvars -except autocorrelogram

end