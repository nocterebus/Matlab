
clear;clc;
%this is to run the vlfeat library (from my computer) when starting this program
%run('C:\Users\Justen\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');
%% Load images
images = loadMNISTImages('train-images.idx3-ubyte');
labels = loadMNISTLabels('train-labels.idx1-ubyte');
images = single(images);
%% setup classes, 2000 images per class. 
%variables to help setup classes
l0 = 1; l1 = 1; l2 = 1; l3 = 1; l4 = 1; l5 = 1; l6 = 1; l7 = 1; l8 = 1; l9 = 1; 
timg0 = single(zeros(300,300,2000)); timg1 = single(zeros(300,300,2000)); 
timg2 = single(zeros(300,300,2000)); timg3 = single(zeros(300,300,2000)); 
timg4 = single(zeros(300,300,2000)); timg5 = single(zeros(300,300,2000)); 
timg6 = single(zeros(300,300,2000)); timg7 = single(zeros(300,300,2000)); 
timg8 = single(zeros(300,300,2000)); timg9 = single(zeros(300,300,2000)); 
N  = 1;


while (l0 <= 2000 || l1 <= 2000 || l2 <= 2000 || l3 <= 2000 || l4 <= 2000 || l5 <= 2000 || l6 <= 2000 || l7 <= 2000 || l8 <= 2000 || l9 <= 2000) && N < 60000
    if (labels(N) == 0 && l0 <= 2000) 
        timg0(:,:,l0) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l0 = l0+1;
        N = N+1;
    elseif (labels(N) == 1 && l1 <= 2000)
        timg1(:,:,l1) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l1 = l1+1;
        N = N+1;
    elseif (labels(N) == 2 && l2 <= 2000)
        timg2(:,:,l2) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l2 = l2+1;
        N = N+1;
    elseif (labels(N) == 3 && l3 <= 2000)
        timg3(:,:,l3) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l3 = l3+1;
        N = N+1;
    elseif (labels(N) == 4 && l4 <= 2000)
        timg4(:,:,l4) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l4 = l4+1;
        N = N+1;
    elseif (labels(N) == 5 && l5 <= 2000)
        timg5(:,:,l5) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l5 = l5+1;
        N = N+1;
    elseif (labels(N) == 6 && l6 <= 2000)
        timg6(:,:,l6) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l6 = l6+1;
        N = N+1;
    elseif (labels(N) == 7 && l7 <= 2000)
        timg7(:,:,l7) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l7 = l7+1;
        N = N+1;
    elseif (labels(N) == 8 && l8 <= 2000)
        timg8(:,:,l8) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l8 = l8+1;
        N = N+1;
    elseif (labels(N) == 9 && l9 <= 2000)
        timg9(:,:,l9) = imresize(reshape(images(:,N),[28,28]),[300,300]);
        l9 = l9+1;
        N = N+1;
    else
        N = N+1;
    end
end


%% Find descriptors of all classes. We will be using 50/50 splits 
%attempt to find all descriptors in all K classes, cluster to find bag of
%words. 
desc0 = [];
desc1 = [];
desc2 = [];
desc3 = [];
desc4 = [];
desc5 = [];
desc6 = [];
desc7 = [];
desc8 = [];
desc9 = [];
for x = 1:1000
    [f,d] = vl_sift(timg0(:,:,x));
    desc0 = [desc0 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg1(:,:,x));
    desc1 = [desc1 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg2(:,:,x));
    desc2 = [desc2 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg3(:,:,x));
    desc3 = [desc3 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg4(:,:,x));
    desc4 = [desc4 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg5(:,:,x));
    desc5 = [desc5 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg6(:,:,x));
    desc6 = [desc6 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg7(:,:,x));
    desc7 = [desc7 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg8(:,:,x));
    desc8 = [desc8 d];
end
for x = 1:1000
    [f,d] = vl_sift(timg9(:,:,x));
    desc9 = [desc9 d];
end
%cluster all descriptors to find bag of K visual words. we'll use K = 30
desc0 = single(desc0);
desc1 = single(desc1);
desc2 = single(desc2);
desc3 = single(desc3);
desc4 = single(desc4);
desc5 = single(desc5);
desc6 = single(desc6);
desc7 = single(desc7);
desc8 = single(desc8);
desc9 = single(desc9);
alldesc = [desc0 desc1 desc2 desc3 desc4 desc5 desc6 desc7 desc8 desc9];
K = 30 ;
[centers, assignments] = vl_kmeans(alldesc, K);
%centers is the bag of words
%% Make class centroids utilizing histograms
%find nearest neighbor for descriptors in each training image and save the
%result for each class.

%class0 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg0(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 0. (center of cloud of class0 histograms),
%not the actual concentration of total collection ofpoints
center0 = vl_kmeans(H, 1);

%class1 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg1(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 1.
center1 = vl_kmeans(H, 1);

%class2 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg2(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 2.
center2 = vl_kmeans(H, 1);

%class3 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg3(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 3.
center3 = vl_kmeans(H, 1);

%class4 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg4(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 4.
center4 = vl_kmeans(H, 1);

%class5 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg5(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 5.
center5 = vl_kmeans(H, 1);

%class6 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg6(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 6.
center6 = vl_kmeans(H, 1);

%class7 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg7(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 7.
center7 = vl_kmeans(H, 1);

%class8 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg8(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 8.
center8 = vl_kmeans(H, 1);

%class9 center
H = [];
for im = 1:1000
    [f,d] = vl_sift(timg9(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%create a center for the class 9.
center9 = vl_kmeans(H, 1);

classcenters = [center0 center1 center2 center3 center4 center5 center6 center7 center8 center9];
%based off histograms from words, not descriptors
%% Test images
%zero
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg0(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%unlike before, now we're taking the histograms obtained and finding the
%closest centroid they are located to to determine class
classification0 = knnsearch(classcenters',H');
%one
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg1(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification1 = knnsearch(classcenters',H');
%two
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg2(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification2 = knnsearch(classcenters',H');
%three
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg3(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification3 = knnsearch(classcenters',H');
%four
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg4(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification4 = knnsearch(classcenters',H');
%five
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg5(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification5 = knnsearch(classcenters',H');
%six
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg6(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification6 = knnsearch(classcenters',H');
%seven
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg7(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification7 = knnsearch(classcenters',H');
%eight
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg8(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification8 = knnsearch(classcenters',H');
%nine
H = [];
for im = 1001:2000
    [f,d] = vl_sift(timg9(:,:,im));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,10);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
classification9 = knnsearch(classcenters',H');

%% Find percent error (confusion matrix)
cmatrix = zeros(10,10);
%zeros
for in = 1:1000
   if classification0(in) == 1
        cmatrix(1,1) = cmatrix(1,1) + 1;
   elseif classification0(in) == 2
       cmatrix(1,2) = cmatrix(1,2) + 1;
   elseif classification0(in) == 3
       cmatrix(1,3) = cmatrix(1,3) + 1;
   elseif classification0(in) == 4
       cmatrix(1,4) = cmatrix(1,4) + 1;
   elseif classification0(in) == 5
       cmatrix(1,5) = cmatrix(1,5) + 1;
   elseif classification0(in) == 6
       cmatrix(1,6) = cmatrix(1,6) + 1;
   elseif classification0(in) == 7
       cmatrix(1,7) = cmatrix(1,7) + 1;
   elseif classification0(in) == 8
       cmatrix(1,8) = cmatrix(1,8) + 1;
   elseif classification0(in) == 9
       cmatrix(1,9) = cmatrix(1,9) + 1;
   elseif classification0(in) == 10
       cmatrix(1,10) = cmatrix(1,10) + 1;
   end
end
%ones
for in = 1:1000
   if classification1(in) == 1
        cmatrix(2,1) = cmatrix(2,1) + 1;
   elseif classification1(in) == 2
       cmatrix(2,2) = cmatrix(2,2) + 1;
   elseif classification1(in) == 3
       cmatrix(2,3) = cmatrix(2,3) + 1;
   elseif classification1(in) == 4
       cmatrix(2,4) = cmatrix(2,4) + 1;
   elseif classification1(in) == 5
       cmatrix(2,5) = cmatrix(2,5) + 1;
   elseif classification1(in) == 6
       cmatrix(2,6) = cmatrix(2,6) + 1;
   elseif classification1(in) == 7
       cmatrix(2,7) = cmatrix(2,7) + 1;
   elseif classification1(in) == 8
       cmatrix(2,8) = cmatrix(2,8) + 1;
   elseif classification1(in) == 9
       cmatrix(2,9) = cmatrix(2,9) + 1;
   elseif classification1(in) == 10
       cmatrix(2,10) = cmatrix(2,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification2(in) == 1
        cmatrix(3,1) = cmatrix(3,1) + 1;
   elseif classification2(in) == 2
       cmatrix(3,2) = cmatrix(3,2) + 1;
   elseif classification2(in) == 3
       cmatrix(3,3) = cmatrix(3,3) + 1;
   elseif classification2(in) == 4
       cmatrix(3,4) = cmatrix(3,4) + 1;
   elseif classification2(in) == 5
       cmatrix(3,5) = cmatrix(3,5) + 1;
   elseif classification2(in) == 6
       cmatrix(3,6) = cmatrix(3,6) + 1;
   elseif classification2(in) == 7
       cmatrix(3,7) = cmatrix(3,7) + 1;
   elseif classification2(in) == 8
       cmatrix(3,8) = cmatrix(3,8) + 1;
   elseif classification2(in) == 9
       cmatrix(3,9) = cmatrix(3,9) + 1;
   elseif classification2(in) == 10
       cmatrix(3,10) = cmatrix(3,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification3(in) == 1
        cmatrix(4,1) = cmatrix(4,1) + 1;
   elseif classification3(in) == 2
       cmatrix(4,2) = cmatrix(4,2) + 1;
   elseif classification3(in) == 3
       cmatrix(4,3) = cmatrix(4,3) + 1;
   elseif classification3(in) == 4
       cmatrix(4,4) = cmatrix(4,4) + 1;
   elseif classification3(in) == 5
       cmatrix(4,5) = cmatrix(4,5) + 1;
   elseif classification3(in) == 6
       cmatrix(4,6) = cmatrix(4,6) + 1;
   elseif classification3(in) == 7
       cmatrix(4,7) = cmatrix(4,7) + 1;
   elseif classification3(in) == 8
       cmatrix(4,8) = cmatrix(4,8) + 1;
   elseif classification3(in) == 9
       cmatrix(4,9) = cmatrix(4,9) + 1;
   elseif classification3(in) == 10
       cmatrix(4,10) = cmatrix(4,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification4(in) == 1
        cmatrix(5,1) = cmatrix(5,1) + 1;
   elseif classification4(in) == 2
       cmatrix(5,2) = cmatrix(5,2) + 1;
   elseif classification4(in) == 3
       cmatrix(5,3) = cmatrix(5,3) + 1;
   elseif classification4(in) == 4
       cmatrix(5,4) = cmatrix(5,4) + 1;
   elseif classification4(in) == 5
       cmatrix(5,5) = cmatrix(5,5) + 1;
   elseif classification4(in) == 6
       cmatrix(5,6) = cmatrix(5,6) + 1;
   elseif classification4(in) == 7
       cmatrix(5,7) = cmatrix(5,7) + 1;
   elseif classification4(in) == 8
       cmatrix(5,8) = cmatrix(5,8) + 1;
   elseif classification4(in) == 9
       cmatrix(5,9) = cmatrix(5,9) + 1;
   elseif classification4(in) == 10
       cmatrix(5,10) = cmatrix(5,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification5(in) == 1
        cmatrix(6,1) = cmatrix(6,1) + 1;
   elseif classification5(in) == 2
       cmatrix(6,2) = cmatrix(6,2) + 1;
   elseif classification5(in) == 3
       cmatrix(6,3) = cmatrix(6,3) + 1;
   elseif classification5(in) == 4
       cmatrix(6,4) = cmatrix(6,4) + 1;
   elseif classification5(in) == 5
       cmatrix(6,5) = cmatrix(6,5) + 1;
   elseif classification5(in) == 6
       cmatrix(6,6) = cmatrix(6,6) + 1;
   elseif classification5(in) == 7
       cmatrix(6,7) = cmatrix(6,7) + 1;
   elseif classification5(in) == 8
       cmatrix(6,8) = cmatrix(6,8) + 1;
   elseif classification5(in) == 9
       cmatrix(6,9) = cmatrix(6,9) + 1;
   elseif classification5(in) == 10
       cmatrix(6,10) = cmatrix(6,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification6(in) == 1
        cmatrix(7,1) = cmatrix(7,1) + 1;
   elseif classification6(in) == 2
       cmatrix(7,2) = cmatrix(7,2) + 1;
   elseif classification6(in) == 3
       cmatrix(7,3) = cmatrix(7,3) + 1;
   elseif classification6(in) == 4
       cmatrix(7,4) = cmatrix(7,4) + 1;
   elseif classification6(in) == 5
       cmatrix(7,5) = cmatrix(7,5) + 1;
   elseif classification6(in) == 6
       cmatrix(7,6) = cmatrix(7,6) + 1;
   elseif classification6(in) == 7
       cmatrix(7,7) = cmatrix(7,7) + 1;
   elseif classification6(in) == 8
       cmatrix(7,8) = cmatrix(7,8) + 1;
   elseif classification6(in) == 9
       cmatrix(7,9) = cmatrix(7,9) + 1;
   elseif classification6(in) == 10
       cmatrix(7,10) = cmatrix(7,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification7(in) == 1
        cmatrix(8,1) = cmatrix(8,1) + 1;
   elseif classification7(in) == 2
       cmatrix(8,2) = cmatrix(8,2) + 1;
   elseif classification7(in) == 3
       cmatrix(8,3) = cmatrix(8,3) + 1;
   elseif classification7(in) == 4
       cmatrix(8,4) = cmatrix(8,4) + 1;
   elseif classification7(in) == 5
       cmatrix(8,5) = cmatrix(8,5) + 1;
   elseif classification7(in) == 6
       cmatrix(8,6) = cmatrix(8,6) + 1;
   elseif classification7(in) == 7
       cmatrix(8,7) = cmatrix(8,7) + 1;
   elseif classification7(in) == 8
       cmatrix(8,8) = cmatrix(8,8) + 1;
   elseif classification7(in) == 9
       cmatrix(8,9) = cmatrix(8,9) + 1;
   elseif classification7(in) == 10
       cmatrix(8,10) = cmatrix(8,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification8(in) == 1
        cmatrix(9,1) = cmatrix(9,1) + 1;
   elseif classification8(in) == 2
       cmatrix(9,2) = cmatrix(9,2) + 1;
   elseif classification8(in) == 3
       cmatrix(9,3) = cmatrix(9,3) + 1;
   elseif classification8(in) == 4
       cmatrix(9,4) = cmatrix(9,4) + 1;
   elseif classification8(in) == 5
       cmatrix(9,5) = cmatrix(9,5) + 1;
   elseif classification8(in) == 6
       cmatrix(9,6) = cmatrix(9,6) + 1;
   elseif classification8(in) == 7
       cmatrix(9,7) = cmatrix(9,7) + 1;
   elseif classification8(in) == 8
       cmatrix(9,8) = cmatrix(9,8) + 1;
   elseif classification8(in) == 9
       cmatrix(9,9) = cmatrix(9,9) + 1;
   elseif classification8(in) == 10
       cmatrix(9,10) = cmatrix(9,10) + 1;
   end
end
%zeros
for in = 1:1000
   if classification9(in) == 1
        cmatrix(10,1) = cmatrix(10,1) + 1;
   elseif classification9(in) == 2
       cmatrix(10,2) = cmatrix(10,2) + 1;
   elseif classification9(in) == 3
       cmatrix(10,3) = cmatrix(10,3) + 1;
   elseif classification9(in) == 4
       cmatrix(10,4) = cmatrix(10,4) + 1;
   elseif classification9(in) == 5
       cmatrix(10,5) = cmatrix(10,5) + 1;
   elseif classification9(in) == 6
       cmatrix(10,6) = cmatrix(10,6) + 1;
   elseif classification9(in) == 7
       cmatrix(10,7) = cmatrix(10,7) + 1;
   elseif classification9(in) == 8
       cmatrix(10,8) = cmatrix(10,8) + 1;
   elseif classification9(in) == 9
       cmatrix(10,9) = cmatrix(10,9) + 1;
   elseif classification9(in) == 10
       cmatrix(10,10) = cmatrix(10,10) + 1;
   end
end

cmatrix = cmatrix./1000