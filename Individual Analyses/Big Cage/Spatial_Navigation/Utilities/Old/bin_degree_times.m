function degree_times = bin_degree_times(input,bin_size,two_directions)

if two_directions == 1
    degrees = (-180:bin_size:180-bin_size)';
    degrees(end+1,1) = 999;
    degree_times = cell(size(input,1),1);
    for iJ = 1:size(input,1) %for each session
        degree_times{iJ} = cell(size(degrees,1)-1,1);
        HD_degrees = rad2deg(input{iJ}.polar(:,1));
        for iK = 1:size(degrees,1) %for each set of 5-deg angle bins
            for iL = 1:size(HD_degrees,1) %for each head angle
                if HD_degrees(iL,1) >= degrees(iK,1) && ...
                        HD_degrees(iL,1) < degrees(iK+1,1) %if the head angle is greater than one degree bin and less than the next
                    degree_times{iJ,1}{iK,1}(iL,1) = iL; %save the index of that head angle
                else
                    degree_times{iJ,1}{iK,1}(iL,1) = NaN;
                end
            end
        end
        degree_times{iJ}(iK,:) = [];
    end
else
    degrees = (0:bin_size:180-bin_size)';
    degrees(end+1,1) = 999;
    degree_times = cell(size(input,1),1);
    for iJ = 1:size(input,1) %for each session
        degree_times{iJ} = cell(size(degrees,1)-1,1);
        HD_degrees = abs(rad2deg(input{iJ}.polar(:,1)));
        for iK = 1:size(degrees,1) %for each set of 5-deg angle bins
            for iL = 1:size(HD_degrees,1) %for each head angle
                if HD_degrees(iL,1) >= degrees(iK,1) && ...
                        HD_degrees(iL,1) < degrees(iK+1,1) %if the head angle is greater than one degree bin and less than the next
                    degree_times{iJ,1}{iK,1}(iL,1) = iL; %save the index of that head angle
                else
                    degree_times{iJ,1}{iK,1}(iL,1) = NaN;
                end
            end
        end
        degree_times{iJ}(iK,:) = [];
    end
end
% for iJ = 1:size(degree_times,1)
%     for iK = 1:size(degree_times{iJ},1)
%         for iL = size(degree_times{iJ}{iK},1):-1:1
%             if isnan(degree_times{iJ}{iK}(iL,1))
%                 degree_times{iJ}{iK}(iL,:) = [];
%             end
%         end
%     end
% end

end
