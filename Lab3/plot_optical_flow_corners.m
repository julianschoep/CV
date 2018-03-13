% Optical flow through Lucas-Kanade for detected corners (Section 3).

function plot_optical_flow_corners(original_image, moved_image, region_size, r, c)

    % The center pixel offset of the region borders.
    pixel = floor(region_size/2);
    
    % Discard corners that are too close to the edge for the region size.
    j = 1;
    for i = 1:numel(r)
        r_i = r(i);
        c_i = c(i);
        if r_i + pixel <= size(original_image, 1) - 1 ... 
                && c_i + pixel <= size(original_image, 2) - 1 ... 
                && r_i - pixel >= 1 && c_i - pixel >= 1
            r(j) = r_i;
            c(j) = c_i;
            j = j + 1;
        end
    end
    
    % Compute image wide spatial and temporal derivatives.
    [Ix, Iy] = gradient(original_image);
    It = moved_image - original_image;
    
    v1 = zeros(size(r));
    v2 = zeros(size(r));
    % Compute optical flow vectors per corner.
    for i = 1:numel(r)
        % Get the derivatives for the corresponding window.
        Ix_i = Ix(r(i)-pixel:r(i)+pixel, c(i)-pixel:c(i)+pixel);
        Iy_i = Iy(r(i)-pixel:r(i)+pixel, c(i)-pixel:c(i)+pixel);
        It_i = It(r(i)-pixel:r(i)+pixel, c(i)-pixel:c(i)+pixel);
        A = [Ix_i(:), Iy_i(:)];
        b = It_i(:);
        v = pinv(A)*b;

        v1(i) = v(1);
        v2(i) = v(2);
    end
    % Plot flow vectors on the image.
    quiver(c, r, v1, v2, 'r');
end
