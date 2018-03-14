                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        %%%%%%%%%%%% MAIN %%%%%%%%%%%%
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Week 4
% Tijmen van Dijk - 11336404
% Tim de Haan - 11029668

%% demo_mosaic

% Demo that demonstrates the our own implementation of the projective
% matrix estimation

demo_mosaic;

%% findMatches.m

% Find matches between two given images, the images have to be in
% grayscale

% im1 = rgb2gray(imread('nachtwacht1.jpg'));
% im2 = rgb2gray(imread('nachtwacht2.jpg'));

% im1 = imread('boat1.pgm');
% im2 = imread('boat2.pgm');

im2 = rgb2gray(imread('left.jpg'));
im1 = rgb2gray(imread('right.jpg'));

imshow(im1)
% Function that returnes the coordinates of the matching points, the first
% column is the x coordinate of im1, the second column is the y coordinate
% of im1. Column 3 is the x coordinate of im2 and column 4 is the y
% coordinate of im2
data = findMatches(im1, im2);

% Function that plots the matching points connected with a line. The
% function had to be separated from the upper function since im1 and im2
% don't have the same dimensions and the reshaping alters the matching point
% coordinates. Two images have to share the same dimensions in order to
% make 1 image out of 2 given images. 
showMatchingPoints(im1, im2);

%% Finding the projection matrix with good matches

% Imagine we pick 4 points, chosen by us, that are good matches 
xy = [data(16, 1), data(16, 2); data(27, 1), data(27, 2); ...
      data(28, 1), data(28, 2)]; data(31, 1), data(31, 2);
XY = [data(16, 3), data(16, 4); data(27, 3), data(27, 4); ...
      data(28, 3), data(28, 4)]; data(31, 3), data(31, 4);

goodpoints = estimateGivenPoints(xy, XY, data);

% Plot the points
figure, imshow(im2);
hold on;
plot(goodpoints(:, 1), goodpoints(:, 2), 'g*');
hold off;

%% Finding the projection matrix with bad matches

% Imagine we pick 4 points, chosen by us, that are bad matches 
xy = [data(7, 1), data(7, 2); data(12, 1), data(12, 2); ...
      data(18, 1), data(18, 2)]; data(25, 1), data(25, 2);
XY = [data(7, 3), data(7, 4); data(12, 3), data(12, 4); ...
      data(18, 3), data(18, 4)]; data(25, 3), data(25, 4);

badpoints = estimateGivenPoints(xy, XY, data);

% Plot the points
figure, imshow(im2);
hold on;
plot(badpoints(:, 1), badpoints(:, 2), 'r*');
hold off;

%% ransac.m

% The amount of iterations that are done
k = 9;
% The maximum distance for being an inlier
thresh = 0.5;
% The minimum amount of inliers
d = size(data, 1) * 0.2;
% Minimum amount of point matches taken
s = 4;

% Ransac returns the optimal projective matrix
bestmodel = ransac(data, k, thresh, d, s);
disp(bestmodel);

%% Using RANSAC result to mosaic the two images

% Provide the bestmodel as input for the mosaicing function
T = maketform('projective', bestmodel');
[x y] = tformfwd(T,[1 size(im1,2)], [1 size(im1,1)])

xdata = [min(1,x(1)) max(size(im2,2),x(2))];
ydata = [min(1,y(1)) max(size(im2,1),y(2))];
f12 = imtransform(im1,T,'Xdata',xdata,'YData',ydata);
f22 = imtransform(im2, maketform('affine', [1 0 0; 0 1 0; 0 0 1]), 'Xdata',xdata,'YData',ydata);
subplot(1,1,1);

% Show the mosaic
imshow(max(f12,f22));

%%

