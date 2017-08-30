clear; clc;
%this is to run the vlfeat library (from my computer) when starting this program
%run('C:\Users\Justen\Documents\MATLAB\vlfeat-0.9.20-bin\vlfeat-0.9.20\toolbox\vl_setup');
%% Question 1 CAMERA CALIBRATION
%Estimating the camera parameters as from estimateCameraParameters
%Mathworks Documentation, along with previous lab code (obtained from
%Camera Calibration App)

%Create a set of calibration images.
images = imageSet(fullfile(toolboxdir('vision'),'visiondata',...
            'calibration','fishEye'));
%utilizing 28 checkerboard images from the previous project
imageFileNames = {'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0090.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0091.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0092.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0093.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0094.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0095.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0096.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0100.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0101.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0102.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0103.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0105.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0106.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0107.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0108.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0109.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0110.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0111.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0112.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0113.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0116.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0117.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0118.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0119.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0120.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0122.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0123.jpg',...
    'C:\Users\Justen\Documents\MATLAB\CHECKER\DSC_0124.jpg',...
    };

% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Generate world coordinates of the corners of the squares
squareSize = 8.100000e+00;  % in units of 'mm'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', []);

% View reprojection errors
h1=figure(1); showReprojectionErrors(cameraParams, 'BarGraph');

% Visualize pattern locations
h2=figure(2); showExtrinsics(cameraParams, 'CameraCentric');

% Display parameter estimation errors
%displayErrors(estimationErrors, cameraParams);

%display intrinsic camera parameter matrix K
intrinsMatK = cameraParams.IntrinsicMatrix
%% Question 2-3 Image Capture and Feature Matching
img1 = imread('C:\Users\Justen\Documents\MATLAB\mug1.jpg');
img1 = rgb2gray(img1);
img2 = imread('C:\Users\Justen\Documents\MATLAB\mug2.jpg');
img2 = rgb2gray(img2);
img3 = imread('C:\Users\Justen\Documents\MATLAB\mug3.jpg');
img3 = rgb2gray(img3);
img4 = imread('C:\Users\Justen\Documents\MATLAB\mug4.jpg');
img4 = rgb2gray(img4);

%%initialize points of interest
points1 = detectMinEigenFeatures(img1);
%betweemn img 1 and 2
%image1
figure(3);subplot(1,2,1);
pointimage1 = insertMarker(img1, points1.Location, '+', 'Color', 'red');
imshow(pointimage1);
%trackpoints
pointTracker = vision.PointTracker();
initialize(pointTracker, points1.Location, img1);
[points1,p1validity] = step(pointTracker, img1);
%secondimage
points2 = detectMinEigenFeatures(img2);
pointimage2 = insertMarker(img2, points2.Location, '+','Color', 'red');
subplot(1,2,2); imshow(pointimage2);
[points2, p2validity] = step(pointTracker, img2);
%show translation between 1 and 2
figure(4);
showMatchedFeatures(img1,img2,points1,points2,'falsecolor');

%between img 2 and 3
figure(5);subplot(1,2,1);
imshow(pointimage2);
%thirdimage
points3 = detectMinEigenFeatures(img3);
pointimage3 = insertMarker(img3, points3.Location, '+','Color', 'red');
subplot(1,2,2);imshow(pointimage3);
[points3,p3validity] = step(pointTracker, img3);
figure(6);
showMatchedFeatures(img2,img3,points2,points3,'falsecolor');

%between img3 and 4
figure(7);subplot(1,2,1);
imshow(pointimage3);
%fourthimage
points4 = detectMinEigenFeatures(img4);
pointimage4 = insertMarker(img4, points4.Location, '+','Color', 'red');
subplot(1,2,2);imshow(pointimage4);
[points4,p4validity] = step(pointTracker, img4);
figure(8);
showMatchedFeatures(img3,img4,points3,points4,'falsecolor');

%% Question 4 Estimation of Camera Matrix (rotation between frames)

[F12, inliers12] = estimateFundamentalMatrix(points1, points2);
[F23, inliers23] = estimateFundamentalMatrix(points2, points3);
[F34, inliers34] = estimateFundamentalMatrix(points3, points4);

[R12, t12] = cameraPose(F12, cameraParams, points1, points2)
[R23, t23] = cameraPose(F23, cameraParams, points2, points3)
[R34, t34] = cameraPose(F34, cameraParams, points3, points4)

%% Question 5 Triangulation
%accumulated R
Rcum = R12*R23*R34
tcum = R12*(t12') + R23*(t23') + R34*(t34')

%cameraMatrix
cMatrix = cameraMatrix(cameraParams, Rcum', (-tcum)'*(Rcum'));
c12Matrix = cameraMatrix(cameraParams, R12, t12);
c23Matrix = cameraMatrix(cameraParams, R23, t23);
c34Matrix = cameraMatrix(cameraParams, R34, t34);

%stereoparams
stereoparams12 = stereoParameters(cameraParams, cameraParams, R12, t12);
stereoparams23 = stereoParameters(cameraParams, cameraParams, R23, t23);
stereoparams34 = stereoParameters(cameraParams, cameraParams, R34, t34);
%worldPoints
wpts = triangulate(points1, points2, stereoparams12);
figure(9);
pcshow(wpts);

figure(10);
wpts = triangulate(points2, points3, stereoparams23);
pcshow(wpts);

figure(11);
wpts = triangulate(points3, points4, stereoparams34);
pcshow(wpts);

%% Question 6 Bundle Adjustment
%% Question 7 Point Cloud










