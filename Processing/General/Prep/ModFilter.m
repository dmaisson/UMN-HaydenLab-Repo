function [check,p] = ModFilter(spikes,trial)

p(1:size(trial,2),1:size(spikes,2)) = 0;

for iJ = 1:size(spikes,2)
    for iK = 1:size(trial,2)
        [~,~,z] = glmfit(spikes(:,iJ),trial(:,iK));
        p(iK,iJ) = z.p(2);
        clear z;            
    end
end

check(1:size(trial,2),1:size(spikes,2)) = 0;
for iJ = 1:size(spikes,2)
    for iK = 1:size(trial,2)
        if p(iK,iJ) <= 0.001
            check = [iK,iJ];
            break
        elseif isnan(p(iK,iJ))
            p(iK,iJ) = 999;
        elseif p(iK,iJ) > 0.001
            check = 0;
        end
    end
end

end