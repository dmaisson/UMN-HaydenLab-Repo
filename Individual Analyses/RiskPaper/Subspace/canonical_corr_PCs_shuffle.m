function output = canonical_corr_PCs_shuffle(input,iterations)
for iI = 1:iterations
    seq1 = randperm(size(input.safemat,1));
    seq2 = randperm(size(input.safemat,2));
    for iJ = 1:size(input.safemat,1)
        for iK = 1:size(input.safemat,2)
            temp = input.safemat;
            safemat(iJ,iK) = temp(seq1(iJ),seq2(iK));
        end
    end
    clear seq1 seq2 temp iJ iK;
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
    
    cov_safe = cov(safemat');
    pc_safe = pcacov(cov_safe);%,'Algorithm','eig');
    clear safemat cov_safe;
    cov_low = cov(lowmat');
    pc_low = pcacov(cov_low);%,'Algorithm','eig');
    clear lowmat cov_low;
    cov_high = cov(highmat');
    pc_high = pcacov(cov_high);%,'Algorithm','eig');
    clear highmat cov_high;

    X = pc_safe(:,1:3);
    Y = pc_low(:,1:3);
    [~,~,r] = canoncorr(X,Y);
    safelow_r(iI) = r(1);
    clear Y stats clear low_pc;

    Y = pc_high(:,1:3);
    [~,~,r] = canoncorr(X,Y);
    safehigh_r(iI) = r(1);
    clear X Y stats clear high_pc safe_pc;
end
output.safelow_shuffle = sort(safelow_r);
output.safehigh_shuffle = sort(safehigh_r);
