function [h,p] = test_ks(start,compare)
input = start.modrate.rate;
shuffled = compare.shufflemod.shuffled;

[h(1),p(1)] = kstest2(input.EV1,shuffled);
[h(2),p(2)] = kstest2(input.EV2,shuffled);
[h(3),p(3)] = kstest2(input.Side1,shuffled);
[h(4),p(4)] = kstest2(input.SideC,shuffled);

end