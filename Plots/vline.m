function vline(XX,x);
YY=get(gca,'ylim');
ll=line([XX XX],[YY(1) YY(2)])
if x == 1
set(ll,'color',input('What color?'))
else
set(ll,'color','k')
end