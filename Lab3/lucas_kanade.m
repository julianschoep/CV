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
    plot_optical_flow_image(sphere1_gray, sphere2_gray, region_size);

    figure(2)
    imshow(synth1)
    hold on
    plot_optical_flow_image(synth1, synth2, region_size);
end

% Optical flow through Lucas-Kanade image wide (Section 2).
function plot_optical_flow_image(original_image, moved_image, region_size)
    % Compute image wide spatial and temporal derivatives.
    % Image wide to reduce the impact of derivative padding.
    [Ix, Iy] = gradient(original_image);
    It = moved_image - original_image;

    % Divide images and derivatives in regions.
    regions_original = divide_in_regions(original_image, 15);
    regions_moved = divide_in_regions(moved_image, 15);
    regions_Ix = divide_in_regions(Ix, 15);
    regions_Iy = divide_in_regions(Iy, 15);
    regions_It = divide_in_regions(It, 15);
    
    % Initialize coordinate matrices.
    x = zeros(size(regions_original));
    y = zeros(size(regions_original));
    v1 = zeros(size(regions_original));
    v2 = zeros(size(regions_original));
   
    % Compute optical flow vectors per region.
    for i = 1:size(regions_original, 1)
        for j = 1:size(regions_original, 2)
            Ix = regions_Ix{i, j};
            Iy = regions_Iy{i, j};
            It = regions_It{i, j} * -1;
            A = [Ix(:), Iy(:)];
            b = It(:);
            v = pinv(A)*b;

            v1(i, j) = v(1);
            v2(i, j) = v(2);
            x(i, j) = j * region_size - round(region_size / 2);
            y(i, j) = i * region_size - round(region_size / 2);
        end
    end
    % Plot flow vectors on the image.
    quiver(x, y, v1, v2, 'r');
end

% Optical flow through Lucas-Kanade for detected corners (Section 3).
function [r,c] =  plot_optical_flow_corners(original_image, moved_image, region_size, r, c)
    % Compute image wide spatial and temporal derivatives.
    % Image wide to reduce the impact of derivative padding.
    
    % The center pixel offset of the region borders.
    pixel = round(region_size/2)
    
    % Discard corners that are too close to the edge for the region size.
    j = 1
    for i = 1:numel(r)
        r_i = r(i);
        c_i = c(i);
        if r_i + p <= size(original_image, 1) - 1 ... 
                && c_i + pixel <= size(original_image, 2) - 1 ... 
                && r_i - pixel >= 1 && c_i - pixel >= 1
            r(j) = r_i;
            c(j) = c_i;
            j = j + 2
        end
    end
    
    [Ix, Iy] = gradient(original_image);
    It = moved_image - original_image;
    
    v1 = zeros(size(r));
    v2 = zeros(size(r));
    % Compute optical flow vectors per region.
    for i = 1:numel(r)
        Ix = Ix_m(r-pixel:c+pixel, r-pixel:c+pixel);
        Iy = Iy_m(r-pixel:c+pixel, r-pixel:c+pixel);
        It = It_m(r-pixel:c+pixel, r-pixel:c+pixel);
        A = [Ix(:), Iy(:)];
        b = It(:);
        v = pinv(A)*b;

        v1(i) = v(1);
        v2(i) = v(2);
    end
    % Plot flow vectors on the image.
    quiver(c, r, v1, v2, 'r');
end

% Divide an image in regions with correct remainders.
function regions = divide_in_regions(image, region_size)
    [rows columns] = size(image);
    numOfRegions = floor(rows / region_size);
    regionVector = [region_size * ones(1, numOfRegions), rem(columns, region_size)];
    regions = mat2cell(image, regionVector, regionVector);
    regions = regions(1:numOfRegions, 1:numOfRegions);
end
