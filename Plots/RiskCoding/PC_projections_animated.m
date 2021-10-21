%// Sample x and y values assumed for demo.
x = projectsafe(:,1);
y = projectsafe(:,2);
z = projectsafe(:,3);

a = projectlow(:,1);
b = projectlow(:,2);
c = projectlow(:,3);

l = projecthigh(:,1);
m = projecthigh(:,2);
n = projecthigh(:,3);

%// Plot starts here
figure
hold on
grid on
view(80,10)
%// Set x and y limits of the plot
if min(x) < min(a) == 0
    if min(a) < min(l)
        xmin = min(a);
    else
        xmin = min(l);
    end
else
    if min(x) < min(l)
        xmin = min(x);
    else
        xmin = min(l);
    end
end
if max(x) > max(a) == 0
    if max(a) > max(l)
        xmax = max(a);
    else
        xmax = max(l);
    end
else
    if max(x) > max(l)
        xmax = max(x);
    else
        xmax = max(l);
    end
end

if min(y) < min(b) == 0
    if min(b) < min(m)
        ymin = min(b);
    else
        ymin = min(m);
    end
else
    if min(y) < min(m)
        ymin = min(y);
    else
        ymin = min(m);
    end
end
if max(y) > max(b) == 0
    if max(b) > max(m)
        ymax = max(b);
    else
        ymax = max(m);
    end
else
    if max(y) > max(m)
        ymax = max(y);
    else
        ymax = max(m);
    end
end

if min(z) < min(c) == 0
    if min(c) < min(n)
        zmin = min(c);
    else
        zmin = min(n);
    end
else
    if min(z) < min(n)
        zmin = min(z);
    else
        zmin = min(n);
    end
end
if max(z) > max(c) == 0
    if max(c) > max(n)
        zmax = max(c);
    else
        zmax = max(n);
    end
else
    if max(z) > max(n)
        zmax = max(z);
    else
        zmax = max(n);
    end
end
xlim([xmin xmax])
ylim([ymin ymax])
zlim([zmin zmax])

%// Plot point by point
for k = 1:numel(x)
%     axes1 = axes('Parent',figure1);
%     hold(axes1,'on');
%     view(axes1,[54.8403979073516 19.4307198126906]);
    plot3(x(1:k),y(1:k),z(1:k),'k','Linewidth',2) %// Choose your own marker here
    plot3(a(1:k),b(1:k),c(1:k),'b','Linewidth',2) %// Choose your own marker here
    plot3(l(1:k),m(1:k),n(1:k),'g','Linewidth',2) %// Choose your own marker here
    xlabel('PC1');
    ylabel('PC2');
    zlabel('PC3');

    %// MATLAB pauses for 0.001 sec before moving on to execue the next 
    %%// instruction and thus creating animation effect
    pause(0.0001);     


    % draw stuff

    frame = getframe(gcf);
    img =  frame2im(frame);
    [img,cmap] = rgb2ind(img,128);
    if k == 1
        imwrite(img,cmap,'animation.gif','gif','LoopCount',Inf,'DelayTime',0.0001);
    else
        imwrite(img,cmap,'animation.gif','gif','WriteMode','append','DelayTime',0.0001);
    end
end