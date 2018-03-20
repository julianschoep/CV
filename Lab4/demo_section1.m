% Demo script that executes all code and generates the required images for
% Section 1 - Image Alignment.

%% Load images.
image1 = im2double(imread('boat1.pgm'));
image2 = im2double(imread('boat2.pgm'));

% figure()
% imshow(image1)
% figure()
% imshow(image2)

%% % Match keypoints.
matchingKeypoints = keypoint_matching(image1, image2);

%% Plot 50 matches
figure()
plot_matches(matchingKeypoints, image1, image2);

%% Ransac
% The amount of iterations
N = 3;

% Minimum amount of point matches taken (3 for affine)
P = 4;

% % Verbose mode:
% - 0 means no plots at all
% - 1 means plots of all subsamples
% - 2 means all plots.

verbose_mode = 2;

[transform_params1, transform_matrix1] = ransac(image1, image2, N, P, verbose_mode)

%% Visualize transformations from image1 to image2 and vice-versa

% Find transformation from image2 to image 1
[transform_params2, transform_matrix2] = ransac(image2, image1, N, P, verbose_mode);

%%

% Use handmade function and imwarp
im1_t = transform_image(image1,transform_params1);
T1 = affine2d(transform_matrix1');
im1_t_warp = imwarp(image1, T1);

im2_t = transform_image(image2,transform_params2);
T2 = affine2d(transform_matrix2');
im2_t_warp = imwarp(image2, T2);

% Show results
figure()
subplot(1,2,1); imshow(im1_t);
subplot(1,2,2); imshow(im1_t_warp);

figure()
subplot(1,2,1); imshow(im2_t);
subplot(1,2,2); imshow(im2_t_warp);

%%




