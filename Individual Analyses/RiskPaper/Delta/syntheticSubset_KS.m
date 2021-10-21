function out = syntheticSubset_KS(in,iterations)

low = in.deltalow_subset;
high = in.deltahigh_subset;
cont_low = in.deltapseudolow_subset;
cont_high = in.deltapseudohigh_subset;
S_range = (1:100)/100;
for iJ = 1:size(S_range,2)
    pos_cont_m(iJ,1) = nanmean(in.pos_cont{iJ});
end

%%%% Medium-stakes %%%%
for iI = 1:iterations
    for iJ = 1:size(S_range,2)
        for iK = 1:size(low{iJ},1)
            r1 = randi(4);
            if r1 == 1
                set1{iJ,1}(iK,1) = low{iJ}(iK,1);
            elseif r1 == 2
                set1{iJ,1}(iK,1) = high{iJ}(iK,1);
            elseif r1 == 3
                set1{iJ,1}(iK,1) = cont_low{iJ}(iK,1);
            elseif r1 == 4
                set1{iJ,1}(iK,1) = cont_high{iJ}(iK,1);
            end
        end
        m_set1(iJ,iI) = nanmean(set1{iJ});
        sem_set1(iJ,iI) = nanstd(set1{iJ})/sqrt(size(low{iJ},1));
    end
    [~,out.synth_low(iI,1)] = kstest2(m_set1(:,iI),in.avg.low);
end
x = find(out.synth_low > 0.05);
out.p.synth_low = 1-(size(x,1)/iterations);
out.synth_low_m = nanmean(m_set1,2);
out.synth_low_sem = nanmean(sem_set1,2);
clear m_set1 sem_set1

%%%% High-stakes %%%%
for iI = 1:iterations
    for iJ = 1:size(S_range,2)
        for iK = 1:size(low{iJ},1)
            r1 = randi(4);
            if r1 == 1
                set1{iJ,1}(iK,1) = low{iJ}(iK,1);
            elseif r1 == 2
                set1{iJ,1}(iK,1) = high{iJ}(iK,1);
            elseif r1 == 3
                set1{iJ,1}(iK,1) = cont_low{iJ}(iK,1);
            elseif r1 == 4
                set1{iJ,1}(iK,1) = cont_high{iJ}(iK,1);
            end
        end
        m_set1(iJ,iI) = nanmean(set1{iJ});
        sem_set1(iJ,iI) = nanstd(set1{iJ})/sqrt(size(low{iJ},1));
    end
    [~,out.synth_high(iI,1)] = kstest2(m_set1(:,iI),in.avg.high);
end
x = find(out.synth_high > 0.05);
out.p.synth_high = 1-(size(x,1)/iterations);
out.synth_high_m = nanmean(m_set1,2);
out.synth_high_sem = nanmean(sem_set1,2);
clear m_set1 sem_set1

%%%% Positive-control %%%%
for iI = 1:iterations
    for iJ = 1:size(S_range,2)
        for iK = 1:size(low{iJ},1)
            r1 = randi(4);
            if r1 == 1
                set1{iJ,1}(iK,1) = low{iJ}(iK,1);
            elseif r1 == 2
                set1{iJ,1}(iK,1) = high{iJ}(iK,1);
            elseif r1 == 3
                set1{iJ,1}(iK,1) = cont_low{iJ}(iK,1);
            elseif r1 == 4
                set1{iJ,1}(iK,1) = cont_high{iJ}(iK,1);
            end
        end
        m_set1(iJ,1) = nanmean(set1{iJ});
    end
    [~,out.synth_posCont(iI,1)] = kstest2(m_set1,pos_cont_m);
end
x = find(out.synth_posCont <= 0.05);
out.p.synth_posCont = 1-(size(x,1)/iterations);