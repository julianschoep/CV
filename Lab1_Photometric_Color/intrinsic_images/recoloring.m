% Load images and convert to double precision
reflectance = im2double(imread('ball_reflectance.png'));
shading = im2double(imread('ball_shading.png'));
original = im2double(imread('ball.png'));

% Separate RGB channels
red = reflectance(:,:,1);
green = reflectance(:,:,2);
blue = reflectance(:,:,3);

% Find material color
R = max(max(red));
G = max(max(green));
B = max(max(blue));

% Find the pixels that compose the ball
ball_pixels = red == R & green == G & blue == B;

% Green is [0 255 0], scaled to a 0-1 range in MATLAB
red(ball_pixels) = 0;
green(ball_pixels) = 1;
blue(ball_pixels) = 0;

% Recombine channels and reconstruct with shading
green_image = cat(3, red, green, blue) .* shading;

% Magenta is [1 0 1]
red(ball_pixels) = 1;
green(ball_pixels) = 0;
blue(ball_pixels) = 1;
magenta_image = cat(3, red, green, blue) .* shading;

% Plot in a single figure
figure();
fig1 = subplot(2, 3, 1);
fig1.Color = [R G B];

fig2 = subplot(2, 3, 2);
fig2.Color = [0 1 0];

fig3 = subplot(2, 3, 3);
fig3.Color = [1 0 1];
title("Magenta");

subplot(2, 3, 4);
imshow(original);
title("Original color");

subplot(2, 3, 5);
imshow(green_image);
title("Green");

subplot(2, 3, 6);
imshow(magenta_image);
title("Magenta");