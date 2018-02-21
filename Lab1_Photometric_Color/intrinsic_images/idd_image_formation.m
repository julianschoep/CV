% Load images and convert to double precision
reflectance = im2double(imread('ball_reflectance.png'));
shading = im2double(imread('ball_shading.png'));
original = im2double(imread('ball.png'));

% Reconstruct through element-wise multiplication
reconstruction = reflectance .* shading;

% Plot in a single figure
figure();
subplot(2, 2, 1);
imshow(reflectance);
title("Reflectance");

subplot(2, 2, 2);
imshow(shading);
title("Shading");

subplot(2, 2, 3);
imshow(reconstruction);
title("Reconstruction");

subplot(2, 2, 4);
imshow(original);
title("Original")