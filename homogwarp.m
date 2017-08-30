function [regimg] = homogwarp(unregimg,baseimg,homog);
% register image using a homography
% [regimg] = homogwarp(unregimg,baseimg,homog);

N1 = size(baseimg,1);
N2 = size(baseimg,2);
regimg = zeros(N1,N2);
unreg = double(unregimg);

% *very* slow to do it this way, use matrix operations instead of loop

for i = 1:N1,
    for j = 1:N2,
        % find match in unregimg
        
        X1 = (homog(1)*j + homog(2)*i + homog(3))/(homog(7)*j+homog(8)*i + homog(9));
        Y1 = (homog(4)*j + homog(5)*i + homog(6))/(homog(7)*j+homog(8)*i + homog(9));
        interpval = bilinear(unreg,Y1,X1);
        regimg(i,j) = interpval;
    end;
end;