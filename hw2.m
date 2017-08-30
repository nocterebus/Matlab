clear,clc;
%% Question 1
% fitting the Homography using SVD. Since V1 is the orthonormal null space
% of A, we can utilize that as H
% utilize equation Ah=0 and  h = linsolve(A,0)
A = [160 260 1 0 0 0 -192*160 -192*260 -192;...
     0 0 0 160 260 1 -304*160 -304*260 -304;...
     300 260 1 0 0 0 -344*300 -344*260 -344;...
     0 0 0 300 260 1 -336*300 -336*260 -336;...
     300 360 1 0 0 0 -343*300 -343*360 -343;...
     0 0 0 300 360 1 -478*300 -478*360 -478;...
     160 360 1 0 0 0 -191*160 -191*360 -191;...
     0 0 0 160 360 1 -512*160 -512*360 -512 ...
     ];
[U S V] = svd(A);%use the nullspace of A
H = V(:,end);
h = reshape(H,[3,3]);%for keepsake
imghp = imread('hpworld.png');
imghp = im2double(imghp);
figure(3);
imghp2 = homogwarp(imghp,imghp,H);%perform homography
imshow(imghp2)%display image
%% Question 2
%initialize images
img1 = imread('img1.png');
img1 = rgb2gray(img1);
img1 = double(img1);
img2 = imread('img2.png');
img2 = rgb2gray(img2);
img2 = double(img2);
figure(2);colormap('gray');
subplot(2,2,1);
imagesc(img1)
subplot(2,2,2);
imagesc(img2)

%figure(3);
%imagesc(img1)%take 4 points in img2
%[x1 y1] = ginput(4);%repeated 3 times to get 12 points
imgx11p = [1.417903225806452e+02;4.166290322580645e+02;8.398548387096776e+02;1.659209677419355e+03];
imgx12p = [2.114677419354839e+02;6.088870967741937e+02;1.176629032258065e+03;1.857919354838710e+03];
imgx13p = [1.125016129032258e+03;1.042435483870968e+03;1.163725806451613e+03;1.150822580645161e+03];
imgy11p = [3.998887530562348e+02;4.857078239608803e+02;4.302555012224940e+02;4.883484107579463e+02];
imgy12p = [7.814535452322740e+02;7.009156479217605e+02;8.078594132029340e+02;7.748520782396089e+02];
imgy13p = [5.728471882640588e+02;7.167591687041565e+02;7.088374083129586e+02;8.105000000000001e+02];
%set of points in first frame
img1p = [imgx11p imgy11p; imgx12p imgy12p; imgx13p imgy13p];

%figure(4);
%imagesc(img2)%take shifted 4 points in img2
%[x2 y2] = ginput (4);%repeated 3 times for the 12 points
imgx21p = [1.417903225806452e+02;4.140483870967743e+02;8.398548387096776e+02;1.660500000000000e+03];
imgx22p = [2.140483870967743e+02;6.101774193548388e+02;1.175338709677419e+03;1.856629032258064e+03];
imgx23p = [1.127596774193549e+03;1.041145161290323e+03;1.161145161290323e+03;1.153403225806452e+03];
imgy21p = [2.322114914425428e+02;3.206711491442543e+02;2.638985330073350e+02;3.193508557457213e+02];
imgy22p = [6.137762836185819e+02;5.332383863080686e+02;6.401821515892422e+02;6.098154034229830e+02];
imgy23p = [4.038496332518339e+02;5.490819070904646e+02;5.385195599022006e+02;6.415024449877751e+02];
%set of points in second frame
img2p = [imgx21p imgy21p; imgx22p imgy22p; imgx23p imgy23p];
%find uv vector
uv = img1p-img2p;
uv = uv.';
uv = reshape(uv,[24,1]);
%make A vector
AA = [img1p(1,:) 1 0 0 0; ...
      0 0 0 img1p(1,:) 1; ...
      img1p(2,:) 1 0 0 0; ...
      0 0 0 img1p(2,:) 1; ...
      img1p(3,:) 1 0 0 0; ...
      0 0 0 img1p(3,:) 1; ...
      img1p(4,:) 1 0 0 0; ...
      0 0 0 img1p(4,:) 1; ...
      img1p(5,:) 1 0 0 0; ...
      0 0 0 img1p(5,:) 1; ...
      img1p(6,:) 1 0 0 0; ...
      0 0 0 img1p(6,:) 1; ...
      img1p(7,:) 1 0 0 0; ...
      0 0 0 img1p(7,:) 1; ...
      img1p(8,:) 1 0 0 0; ...
      0 0 0 img1p(8,:) 1; ...
      img1p(9,:) 1 0 0 0; ...
      0 0 0 img1p(9,:) 1; ...
      img1p(10,:) 1 0 0 0; ...
      0 0 0 img1p(10,:) 1; ...
      img1p(11,:) 1 0 0 0; ...
      0 0 0 img1p(11,:) 1; ...
      img1p(12,:) 1 0 0 0; ...
      0 0 0 img1p(12,:) 1; ...
      ];
%utilize svd to find a,b,c,d,e,f
HH = pinv(AA)*uv;
img3 = affinewarp([1080 1920],img1,HH);
subplot(2,2,3);
imagesc(img3);
% shifetd from y = 867 -> 706
% for the pixel by pixel difference, i subtracted img3's value matrix from
% img2's value matrix. The result should have a gray area where the two
% images are similar, a negative of the image where there are new pixels
% introduced compared to img2, and a regular colored area where pixels are
% missing.
img4 = img2-img3;
subplot(2,2,4)
imagesc(img4);
%% Question 3
%code provided in slides
img = imread('phone.png');
img = rgb2gray(img);
[u,s,v] = svd(double(img));
[sx sy] = size(img);
N = 20;
R = zeros(sx,sy);%image size
for i = 1:N,
 R = R+u(:,i)*v(:,i)'*s(i,i);
end;
figure(1);colormap('gray');subplot(1,3,1);
imagesc(R);
N = 40;
R = zeros(sx,sy);
for i = 1:N,
 R = R + u(:,i)*v(:,i)'*s(i,i);
end;
subplot(1,3,2);
imagesc(R);
N = 80;
R = zeros(sx,sy);
for i = 1:N,
 R = R + u(:,i)*v(:,i)'*s(i,i);
end;
subplot(1,3,3);
imagesc(R);
% Note that 80 terms is enough to give a good visual effect, while 40 and
% 20 loses a significant amount of quality and causes more artifacts to appear.
% The storage requirement is 80*(1080+1920) = 240,000 as opposed to
% 1080*1920=2,073,600 resulting in 1,833,600 savings of memory
