function plot_gradients_filters()
image = imread('./images/image2.jpg');
[Gx, Gy, im_magnitude,im_direction] = compute_gradient(image);
figure(1)
imshow(image);
title('Original image');
% figure(2)
% imshow(Gx,[]);
% title('Gradients in x direction (Gx)');
% figure(3)
% imshow(Gy,[]);
% title('Gradients in y direction (Gy)');
% figure(4)
% imshow(im_magnitude,[]);
% title('Gradient magnitudes');
figure(5)
imshow(im_direction, []);
title('Gradient directions');
