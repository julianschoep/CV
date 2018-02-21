% Load image with double precision
original = im2double(imread('awb.jpg'));

% Separate RGB channels
red = original(:,:,1);
green = original(:,:,2);
blue = original(:,:,3);

% Compute averages
mean(mean(red))
mean(mean(blue))
mean(mean(green))

max(max(red))

red = red / (2 * mean(mean(red)));
blue = blue / (2 * mean(mean(blue)));
green = green / (2 * mean(mean(green)));

awb_image = cat(3, red, green, blue);

figure()
subplot(1,2,1);
imshow(original);

subplot(1,2,2);
imshow(awb_image);
