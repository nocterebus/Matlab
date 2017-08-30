function [value] = bilinear(inimg,x,y)
% return inimg(x,y) using bilinear interpolation where x,y are real valued

[sx sy] = size(inimg);
x = max([x 1]);
x = min([x sx]);
y = max([y 1]);
y = min([y sy]);
x0 = max([floor(x) 1]);
x1 = min([(x0+1) sx]);
y0 = max([floor(y) 1]);
y1 = min([(y0+1) sy]);


valul = inimg(x0,y0);
valur = inimg(x1,y0);
valll = inimg(x0,y1);
vallr=inimg(x1,y1);

x0 = floor(x);
x1 = x0+1;
y0 = floor(y);
y1 = y0+1;


vala = (x-x0)*valur + (x1-x)*valul;
valb = (x-x0)*vallr + (x1-x)*valll;

value = (y-y0)*valb + (y1-y)*vala;