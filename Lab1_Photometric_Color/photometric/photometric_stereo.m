close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

%% 
% obtain many images in a fixed view under different illumination
disp('Loading images...')
image_dir = './SphereGray5/';   % TODO: get the path of the script
% image_ext = '*.png';

%%
disp('Loading images...')
image_dir = './SphereGray25/';   % TODO: get the path of the script

%%
%disp('Loading images...')
%image_dir = './MonkeyGray/';   % TODO: get the path of the script

%%
[image_stack, scriptV] = load_syn_images(image_dir);
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);

%%
% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005; % default is 0.005
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d out of a total of: %d\n\n.', sum(sum(SE > threshold)), numel(SE));

%% compute the surface height

height_map = construct_surface( p, q, 'column' );
% height_map_column = construct_surface( p, q, 'row');
% height_map_average = construct_surface( p, q, 'average');
% 
% show_model(albedo, height_map);

%% Plot surface mesh and surface normals
figure()
[X_sub, Y_sub] = meshgrid(1:32:512, 1:32:512);  
surf(X_sub, Y_sub, height_map(1:32:end, 1:32:end));
xlabel('x'),ylabel('y'),zlabel('z');
title('Surface Mesh');
axis([0 512 0 512 0 max(max(height_map))])

figure()
[U, V, W] = surfnorm(X_sub, Y_sub, height_map(1:32:end, 1:32:end));
quiver3(X_sub, Y_sub, height_map(1:32:end, 1:32:end), U, V, W, 0.5);
xlabel('x'),ylabel('y'),zlabel('z');
title('Surface normals');
axis([0 512 0 512 0 max(max(height_map))])

%% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map);

%% Attempt at quiver plot (can't figure out how to subsample)
figure(1)
quiver3(zeros(size(height_map)), normals(:, :, 1), normals(:, :, 2), normals(:, :, 3))

%% Load RGB Images
disp('Loading images...')
image_dir = './SphereColor/';   % TODO: get the path of the script

[image_stack, scriptV] = load_syn_images(image_dir, 3);
[h, w, channel, n] = size(image_stack);
fprintf('Finish loading %dx%d images.\n\n', channel, n);

[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);

%% Face
[image_stack, scriptV] = load_face_images('./yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d out of a total of: %d\n\n.', sum(sum(SE > threshold)), numel(SE));

%% compute the surface height
height_map = construct_surface( p, q );

show_results(albedo, normals, SE);
show_model(albedo, height_map);

