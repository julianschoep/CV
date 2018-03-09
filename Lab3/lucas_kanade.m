demo;

% Demo function to display Lucas-Kanade results.
function demo
    % Load images with double precision.
    sphere1 = im2double(imread('sphere1.ppm'));
    sphere2 = im2double(imread('sphere2.ppm'));
    synth1 = im2double(imread('synth1.pgm'));
    synth2 = im2double(imread('synth2.pgm'));

    % Convert RGB images to grayscale.
    sphere1_gray = rgb2gray(sphere1);
    sphere2_gray = rgb2gray(sphere2);

    % Set region size.
    region_size = 15;

    % Plot each image and the results of the Lucas-Kanade algorithm.
    figure(1)
    imshow(sphere1)
    hold on
    plot_optical_flow(sphere1_gray, sphere2_gray, region_size);

    figure(2)
    imshow(synth1)
    hold on
    plot_optical_flow(synth1, synth2, region_size);
end

% Optical flow through Lucas-Kanade.
function plot_optical_flow(original_image, moved_image, region_size)
    % Compute image wide spatial and temporal derivatives.
    % Image wide to reduce the impact of derivative padding.
    [dx, dy] = gradient(original_image);
    dt = moved_image - original_image;
    
    % Divide images and derivatives in regions.
    regions_original = divide_in_regions(original_image, 15);
    regions_moved = divide_in_regions(moved_image, 15);
    regions_dx = divide_in_regions(dx, 15);
    regions_dy = divide_in_regions(dy, 15);
    regions_dt = divide_in_regions(dt, 15);
    
    % Initialize coordinate matrices.
    x = zeros(size(regions_original));
    y = zeros(size(regions_original));
    v1 = zeros(size(regions_original));
    v2 = zeros(size(regions_original));
   
    % Compute optical flow vectors per region.
    for i = 1:size(regions_original, 1)
        for j = 1:size(regions_original, 2)
            dx = regions_dx{i, j};
            dy = regions_dy{i, j};
            dt = regions_dt{i, j} * -1;
            A = [dx(:), dy(:)];
            b = dt(:);
            v = pinv(A)*b;

            v1(i, j) = v(1);
            v2(i, j) = v(2);
            x(i, j) = j * region_size - region_size / 2;
            y(i, j) = i * region_size - region_size / 2;
        end
    end
    % Plot flow vectors on the image.
    quiver(x, y, v1, v2, 'r');
end

% Divide an image in regions with correct remainders.
function regions = divide_in_regions(image, region_size)
    [rows columns] = size(image);
    numOfRegions = floor(rows / region_size);
    regionVector = [region_size * ones(1, numOfRegions), rem(columns, region_size)];
    regions = mat2cell(image, regionVector, regionVector);
    regions = regions(1:numOfRegions, 1:numOfRegions);
end
