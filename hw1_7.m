%% Question 7
clear;clc;
a = 5;
b = 100;
t = 0:0.1:10;
x = a*cos(t);
y = b*sin(t);
figure(1); plot(x,y);
figure(1); plot(x,y,'-*');
title('Points in an ellipse');
cc = cos(pi/3);
ss = sin(pi/3);
R = [ cc ss; -ss cc];
rpts = R*10;
figure(2); plot(rpts(1,:),rpts(2,:),'*-');
title('Points in a rotated ellipse');

[U,S,V] = svd(R)
atan(U(1,1)/U(2,1))*2/pi*180

