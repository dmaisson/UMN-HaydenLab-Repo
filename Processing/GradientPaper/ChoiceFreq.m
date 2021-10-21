function output = ChoiceFreq(input)

for iJ = 1:length(input)
    for iK = 1:length(input{iJ}.vars)
        if input{iJ}.vars(iK,3) > input{iJ}.vars(iK,6)
            if input{iJ}.vars(iK,9) == 1
                x(iK,1) = 1;
            else
                x(iK,1) = 0;
            end
        elseif input{iJ}.vars(iK,6) > input{iJ}.vars(iK,3)
            if input{iJ}.vars(iK,9) == 0
                x(iK,1) = 1;
            else
                x(iK,1) = 0;
            end
        elseif input{iJ}.vars(iK,6) == input{iJ}.vars(iK,3)
            x(iK,1) = NaN;
        end
    end
    output(iJ,1) = nanmean(x);
    clear x
end

end
