figure
hold on
errorbar(classifier.accuracy(1,1:3),classifier.error(1,1:3));
errorbar(classifier.accuracy(2,1:3),classifier.error(2,1:3));
errorbar(classifier.accuracy(3,1:3),classifier.error(3,1:3));
errorbar(classifier.accuracy(4,1:3),classifier.error(4,1:3));
errorbar(classifier.accuracy(5,1:3),classifier.error(5,1:3));
errorbar(classifier.accuracy(6,1:3),classifier.error(6,1:3));
errorbar(classifier.accuracy(7,1:3),classifier.error(7,1:3));
errorbar(classifier.accuracy(8,1:3),classifier.error(8,1:3));
legend('Area13', 'Area11', 'Area14', 'Area25', 'Area32', 'PCC', 'VS', 'Area24');
hline(classifier.shuffle);
hline(1);
title('Side of First LvsR');