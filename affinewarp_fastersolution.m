% this function is an alternative to warpimg.m and bilinear.m.
% It is interesting to compare the time it takes to run this vs. warpimg
% 
% this function uses much more matrix computations than warpimg and so is much faster
%
function [outimg] = affinewarp_fastersolution(sizevector,inimg,aparm);
% affine warp 
sy = sizevector(1);
sx = sizevector(2);

outimg = zeros(sy,sx);
sz = 1;


nx = 1:sx;
ny = 1:sy;
aax = aparm(1)*nx;
bby = aparm(2)*ny;
cc = aparm(3);
ddx = aparm(4)*nx;
eey = aparm(5)*ny;
ff = aparm(6);

temp1 = aax'*ones(1,sy);
temp2 = ones(1,sx)'*bby;
uuimg = temp1+temp2+cc;


temp1 = ddx'*ones(1,sy);
temp2 = ones(1,sx)'*eey;
vvimg = temp1+temp2+ff;

[xind yind] = meshgrid(1:sx,1:sy);
indices=zeros(sx,sy,2);
indices(:,:,1) = xind';
indices(:,:,2) = yind'; 
interpvalx = xind'+uuimg;
interpvaly = yind'+vvimg;
xx = max(interpvalx,ones(sx,sy));
xx = min(xx,sx*ones(sx,sy));

yy = max(interpvaly,ones(sx,sy));
yy = min(yy,sy*ones(sx,sy));


xx0 = max(floor(xx),ones(sx,sy));
xx1 = min((xx0+1),sx*ones(sx,sy));
yy0 = max(floor(yy),ones(sx,sy));
yy1 = min((yy0+1),sy*ones(sx,sy));



for k=1:sz,
    inimga = double(inimg(:,:,k))';
for i = 1:sx,
    for j = 1:sy
        x0 = xx0(i,j);y0=yy0(i,j);
        x1 = xx1(i,j);y1 = yy1(i,j);
        valul = inimga(x0,y0);
        valur = inimga(x1,y0);
        valll = inimga(x0,y1);
        vallr=inimga(x1,y1);
        
        x = xx(i,j);y = yy(i,j);
        x0 = floor(x);;
        x1 = x0+1;
        y0 = floor(y);
        y1 = y0+1;

        vala = (x-x0)*valur + (x1-x)*valul;
        valb = (x-x0)*vallr + (x1-x)*valll;

        value = (y-y0)*valb + (y1-y)*vala;
        outimg(j,i,k) = value;
    end;
end;
end;