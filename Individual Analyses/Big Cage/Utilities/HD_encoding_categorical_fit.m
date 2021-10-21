function output = HD_encoding_categorical_fit(set,binned_angle)

resSeries = set.resSeries;
degreeSeries = zeros(size(binned_angle.degree_times,1),size(resSeries,2));
eventTimes = binned_angle.degree_times;

for iA = 1:size(degreeSeries,1)
    times = eventTimes{iA,1};
    for iB = 1:size(times,2)
        degreeSeries(iA,times(1,iB)) = 1;
    end
    clear times
end
mdl = fitglm(degreeSeries',resSeries);
output.p_all = coefTest(mdl);
output.LogLikelihood = mdl.LogLikelihood;
output.Coefficients = mdl.Coefficients;
