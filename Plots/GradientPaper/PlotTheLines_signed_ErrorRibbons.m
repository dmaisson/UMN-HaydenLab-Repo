%%
x = Results.data24.Epoch2.b.EV1;
y = Results.data24.Epoch2.b.EV2;

%%
[p,S] = polyfit(x,y,1);
xv = (-0.4:.01:0.4);
[y_ext,delta] = polyconf(p,xv,S);
figure
plot(x, y, '.k')
ylim([-0.4 0.4]);
hold on
plot(xv, y_ext, '-g')
patch([xv fliplr(xv)], [(y_ext+delta) fliplr((y_ext-delta))], 'g', 'FaceAlpha',0.1, 'EdgeColor','none')
hold off