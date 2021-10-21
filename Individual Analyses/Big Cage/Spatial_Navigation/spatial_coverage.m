function [coverage,proportion] = spatial_coverage(input)

n = size(input,1);
for iJ = 1:n
    [~,I] = max(input{iJ}.plotting_rates(:));
    peakFR_idx(iJ,1) = I(1);
end
coverage = zeros(11);
for iJ = 1:n
    x = peakFR_idx(iJ);
    coverage(x) = coverage(x)+1;
end

coverage = (coverage./n)*100;
figure;
pcolor(coverage)
shading interp
colormap jet
colorbar

x = size(coverage(:)); %total size of the occupancy matrix
y = size(coverage(coverage(:) == 0),1); %number of elements with no tuning
z = x(1)-y(1); %number of elements WITH tuning
proportion = (z/x(1))*100;

end