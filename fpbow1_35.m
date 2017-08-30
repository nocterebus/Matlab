clear;clc;
%this is to run the vlfeat library (from my computer) when starting this program
%run('C:\Users\Justen\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');
%% Load images
%images from class x
ic1 = imageDatastore('101_ObjectCategories\selectedimg\butterfly');
ic2 = imageDatastore('101_ObjectCategories\selectedimg\crab');
ic3 = imageDatastore('101_ObjectCategories\selectedimg\cup');
ic4 = imageDatastore('101_ObjectCategories\selectedimg\laptop');
ic5 = imageDatastore('101_ObjectCategories\selectedimg\pizza');
ic6 = imageDatastore('101_ObjectCategories\selectedimg\revolver');
ic7 = imageDatastore('101_ObjectCategories\selectedimg\soccer_ball');
ic8 = imageDatastore('101_ObjectCategories\selectedimg\starfish');
ic9 = imageDatastore('101_ObjectCategories\selectedimg\umbrella');
ic10 = imageDatastore('101_ObjectCategories\selectedimg\watch');

%number of clusters
K = 77;
%% set up classes, 70 images per class.
%fill arrays with images from class x of size 70 (smallest class size)
Nimg = 70;
%initial arrays

aic1 = single(zeros(300,300,Nimg)); aic2 = single(zeros(300,300,Nimg)); aic3 = single(zeros(300,300,Nimg));
aic4 = single(zeros(300,300,Nimg)); aic5 = single(zeros(300,300,Nimg)); aic6 = single(zeros(300,300,Nimg));
aic7 = single(zeros(300,300,Nimg)); aic8 = single(zeros(300,300,Nimg)); aic9 = single(zeros(300,300,Nimg));
aic10 = single(zeros(300,300,Nimg));

for N = 1:Nimg
    temp = im2single(imresize(readimage(ic1,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic1(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic2,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic2(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic3,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic3(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic4,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic4(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic5,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic5(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic6,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic6(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic7,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic7(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic8,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic8(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic9,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic9(:,:,N) = temp;
    
    temp = im2single(imresize(readimage(ic10,N),[300,300]));
    %only rgb to gray if in color
    if size(temp,3) == 3
        temp = rgb2gray(temp);
    end
    aic10(:,:,N) = temp;
    
end
%% Find descriptors of all classes. We will be using 50/50 splits
%find all descriptors in all X classes, cluster to find bag of K words

desc1 = [];
desc2 = [];
desc3 = [];
desc4 = [];
desc5 = [];
desc6 = [];
desc7 = [];
desc8 = [];
desc9 = [];
desc10 = [];


for N = 1:35
    [f,d] = vl_sift(aic1(:,:,N));
    desc1 = [desc1 single(d)];
    
    [f,d] = vl_sift(aic2(:,:,N));
    desc2 = [desc2 single(d)];
    
    [f,d] = vl_sift(aic3(:,:,N));
    desc3 = [desc3 single(d)];
    
    [f,d] = vl_sift(aic4(:,:,N));
    desc4 = [desc4 single(d)];

    [f,d] = vl_sift(aic5(:,:,N));
    desc5 = [desc5 single(d)];
    
    [f,d] = vl_sift(aic6(:,:,N));
    desc6 = [desc6 single(d)];
    
    [f,d] = vl_sift(aic7(:,:,N));
    desc7 = [desc7 single(d)];
    
    [f,d] = vl_sift(aic8(:,:,N));
    desc8 = [desc8 single(d)];
    
    [f,d] = vl_sift(aic9(:,:,N));
    desc9 = [desc8 single(d)];
    
    [f,d] = vl_sift(aic10(:,:,N));
    desc10 = [desc10 single(d)];
end
alldesc = [desc1 desc2 desc3 desc4 desc5 desc6 desc7 desc8 desc9 desc10];
%centers is the bag of K words
[centers, assignments] = vl_kmeans(alldesc, K);
%% Make class centroids utilizing histograms
%find nearest neighbor for descriptors in each training image and save the
%result for each class.
center1 = [];
center2 = [];
center3 = [];
center4 = [];
center5 = [];
center6 = [];
center7 = [];
center8 = [];
center9 = [];
center10 = [];

%class1 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic1(:,:,N));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,K);%histogram of IDX with K bins(K words)
    v = h.Values;%this produces a row that shows "how much" of each word is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];%H will be the average histogram for the class
end
%create a center for the class 1.
center1 = vl_kmeans(H, 1);

%class2 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic2(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center2 = vl_kmeans(H, 1);

%class3 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic3(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center3 = vl_kmeans(H, 1);

%class4 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic4(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center4 = vl_kmeans(H, 1);

%class5 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic5(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center5 = vl_kmeans(H, 1);

%class6 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic6(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center6 = vl_kmeans(H, 1);

%class7 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic7(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center7 = vl_kmeans(H, 1);

%class8 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic8(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center8 = vl_kmeans(H, 1);

%class9 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic9(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center9 = vl_kmeans(H, 1);

%class10 center
H = [];
for N = 1:(35)
    [f,d] = vl_sift(aic10(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
center10 = vl_kmeans(H, 1);

%all class average histograms based off bag of words
classcenters = [center1 center2 center3 center4 center5 center6 center7 center8 center9 center10];
%% Test images

%one
H = [];
for N = 36:70
    [f,d] = vl_sift(aic1(:,:,N));%find image descriptors
    IDX = knnsearch(centers',d');%returns centroid the descriptors belong to
    h = histogram(IDX,K);%histogram of IDX
    v = h.Values;%this produces a row that shows "how much" of each centroid is in the image
    v = v';%transpose to put into H. A centroid for H is to be created afterwards
    H = [H v];
end
%what class center does each image belong to
classification1 = knnsearch(classcenters',H');

%two
H = [];
for N = 36:70
    [f,d] = vl_sift(aic2(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification2 = knnsearch(classcenters',H');

%three
H = [];
for N = 36:70
    [f,d] = vl_sift(aic3(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification3 = knnsearch(classcenters',H');

%tfour
H = [];
for N = 36:70
    [f,d] = vl_sift(aic4(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification4 = knnsearch(classcenters',H');

%five
H = [];
for N = 36:70
    [f,d] = vl_sift(aic5(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification5 = knnsearch(classcenters',H');

%six
H = [];
for N = 36:70
    [f,d] = vl_sift(aic6(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification6 = knnsearch(classcenters',H');

%seven
H = [];
for N = 36:70
    [f,d] = vl_sift(aic7(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification7 = knnsearch(classcenters',H');

%eight
H = [];
for N = 36:70
    [f,d] = vl_sift(aic8(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification8 = knnsearch(classcenters',H');

%nine
H = [];
for N = 36:70
    [f,d] = vl_sift(aic9(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification9 = knnsearch(classcenters',H');

%ten
H = [];
for N = 36:70
    [f,d] = vl_sift(aic10(:,:,N));
    IDX = knnsearch(centers',d');
    h = histogram(IDX,K);
    v = h.Values;
    v = v';
    H = [H v];
end
classification10 = knnsearch(classcenters',H');

%% Confusion Matrix
known = ones(1,350);
for X = 0:9
    known((X*35)+1:(X+1)*35) = X+1;
end
tested = [classification1' classification2' classification3' classification4' classification5' classification6' classification7' classification8' classification9' classification10'];
[C,order] = confusionmat(known,tested)