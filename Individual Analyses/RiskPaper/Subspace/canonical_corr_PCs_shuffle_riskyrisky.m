function output = canonical_corr_PCs_shuffle_riskyrisky(input,iterations)
for iI = 1:iterations
    seq1 = randperm(size(input.lowmat,1));
    seq2 = randperm(size(input.lowmat,2));
    for iJ = 1:size(input.lowmat,1)
        for iK = 1:size(input.lowmat,2)
            temp = input.lowmat;
            lowmat(iJ,iK) = temp(seq1(iJ),seq2(iK));
        end
    end
    clear seq1 seq2 temp iJ iK;
    seq1 = randperm(size(input.highmat,1));
    seq2 = randperm(size(input.highmat,2));
    for iJ = 1:size(input.highmat,1)
        for iK = 1:size(input.highmat,2)
            temp = input.highmat;
            highmat(iJ,iK) = temp(seq1(iJ),seq2(iK));
        end
    end
    clear seq1 seq2 temp iJ iK;
    
    cov_low = cov(lowmat');
    pc_low = pcacov(cov_low);%,'Algorithm','eig');
    clear lowmat cov_low;
    cov_high = cov(highmat');
    pc_high = pcacov(cov_high);%,'Algorithm','eig');
    clear highmat cov_high;

    X = pc_low(:,1:3);
    Y = pc_high(:,1:3);
    [~,~,r] = canoncorr(X,Y);
    lowhigh_r(iI) = r(1);
    clear Y stats clear low_pc;
end
output.safelow_shuffle = sort(lowhigh_r);
