function output = HD_encoding_convolution(set,output)

resSeries = set.resSeries;
degreeSeries = zeros(size(output.degree_times,1),size(resSeries,2));
eventTimes = output.degree_times;
kernel = output.angle_kernel;

% for iA = 1:size(degreeSeries,1)
%     times = eventTimes{iA,1};
%     for iB = 1:size(times,2)
%         degreeSeries(iA,times(1,iB)) = 1;
%     end
%     degree_kernel = kernel{iA,1};
%     temp = conv(degreeSeries(iA,:),degree_kernel);
%     degreeSeries(iA,:) = temp(1,1:size(degreeSeries(iA,:),2));
%     clear temp times degree_kernel
% end
for iA = 1:size(degreeSeries,1)
    times = eventTimes{iA,1};
    for iB = 1:size(times,2)
        degreeSeries(iA,times(1,iB)) = 1;
    end
    clear times
end
mdl = fitglm(degreeSeries',resSeries);