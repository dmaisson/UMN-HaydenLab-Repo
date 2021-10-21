function [x,y,z] = clean_xyz(in,floor)

x = in(:,1);
y = in(:,3);
z = in(:,3);

x = x(z >= floor);
y = y(z >= floor);
z = z(z >= floor);


% x = x(y >= walls(1));
% x = x(y <= walls(2));
% z = z(y >= walls(1));
% z = z(y <= walls(2));
% y = y(y >= walls(1));
% y = y(y <= walls(2));
% 
% y = y(x >= walls(1));
% y = y(x <= walls(2));
% z = z(x >= walls(1));
% z = z(x <= walls(2));
% x = x(x >= walls(1));
% x = x(x <= walls(2));
