function [outimg] = affinewarp(sizevector,inimg,aparm)
% function [outimg] = affinewarp([sy sx],inimg,aparm);
% sx,sy - input image size
% inimg - input image
% aparm - affine parameters
sy = sizevector(1);
sx = sizevector(2);

outimg = zeros(sy,sx);
for i = 1:sx,
    for j = 1:sy;
        uu = aparm(1)*i + aparm(2)*j + aparm(3);
        vv = aparm(4)*i + aparm(5)*j + aparm(6);
        outimg(j,i) = bilinear(inimg,j+vv,i+uu);
    end;
end;