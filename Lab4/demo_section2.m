% Demo script that executes all code and generates the required images for
% Section 2 - Image Stitching.

%% Load images and find best transformation.
image1 = rgb2gray(im2double(imread('left.jpg')));
image2 = rgb2gray(im2double(imread('right.jpg')));

matchingKeypoints = keypoint_matching(image1, image2);

N = 3
P = 3
verbose_mode = 0
[transform_params, transform_matrix] = ransac(image2, image1, N, P, verbose_mode)
% inlier_matches holds the coordinates of the matches that are considered
% inliers under the transformation by <transform_matrix>.

%% Calculate coordinates of corners.
[r, c] = size(image2);

% Corner coordinates as homogenous vectors, transposed to get column
% vectors.
corners = [1,1,1; 1,c,1; r,c,1; r,1,1]';
corners_t = round(transform_matrix * corners);
% Remove unit row
corners_t = corners_t(1:2, :);

% corners_t(1,:) holds the column values for the four corners. The smallest of
% those is the shift in columns, and thus horizontal
hor_shift = min(corners_t(1,:));
% corners_t(1,:) holds the row values for the four corners. The smallest of
% those is the shift in rows, and thus vertical
ver_shift = min(corners_t(2,:));

% Transform the second image
im2_t = transform_image(image2, transform_params);

% Overlay the images with the corner-based shifts.
stitched = overlay_images(image1, im2_t,ver_shift,hor_shift);
imshow(stitched);


