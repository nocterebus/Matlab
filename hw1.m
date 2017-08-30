clear;clc;
%% Question 1
A = [4.19,2.2,5.51;5.20,10.11,-8.24;1.33,4.8,-6.52];
%%%%%%%%%%%%%%%%%%r = rank(A)%determines number of linearly independent columns
%% Question 2
AA = [0,1;1,1;1.8,1;3,1;3.8,1;5,1];%x
b = [1;3.2;5;7.2;9.3;11.1];%y
%%%%%%%%%%%%%%%%%%p = inv(AA.'*AA)*AA.'*b
%% Question 6
%knowns are e(1:255,1:50) and ec(y,x) 
%f(1:255,1:50) can be solved for but by dividing each element of ec by e
%as stated in the hint, we can use a subset of the white region
%to estimate the remainder of f utilizing LLSE
[ec,map] = imread('cguitar.tif');
ec = im2double(ec);
%%%%%%%%%%%%%%%%%%%%imshow(ec)
e = ec;
for x = 1:50
    for y = 1:255
        e(y,x) = 1; 
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%figure
%%%%%%%%%%%%%%%%%%%%%%%%%%imshow(e);
%then select a subset of e and ec to determine f
esub = e(1:255,1:50);
ecsub = ec(1:255,1:50);
%divide elements of ec by e to determine coefficients of f
f = ecsub./esub;%should be equal to ecsub since esub is just 1's
%f = xa + yb + c from x (1:50) and y(1:255)
%turn f into a single vector F in XP = F and set up X = [abc]
%let's use a subspace of F (10 points in f)
F = zeros(10,1);
ONE = ones(10,1);
X = zeros(10,2);
for xy= 1:10
        X(xy,1) = xy*5;%x
        X(xy,2) = xy*25;%y
        F(xy) = f(xy*25,xy*5);%F(y,1) = f(y,x)
end
X = [X ONE];
%alter first row in both matrices to allow for invertability of X.'*X
%if i don't do this i keep getting inf values
X (1,1) = 7;
X (1,2) = 12;
F (1) = f(12,7);
P = inv(X.'*X)*X.'*F;%%%%%%%%%%%%%%%%%%
%take P and apply for full set of f
f = zeros(511,205);
for x = 1:205
    for y = 1:511
        f(y,x) = [x,y,1]*P;
    end
end
%perform element division to solve for e
e = ec./f;
%%%%%%%%%%%%%%%%%%%%%figure
%%%%%%%%%%%%%%%%%%%%%imshow(e)
