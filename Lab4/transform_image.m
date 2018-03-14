function [im_t] = transform_image(im,transform_params)
    [height,width] = size(im);
    % Calculate transformed corners to get boundaries of im_t
    % Create a matrix that holds the transposed coordinates. This is used
    % to estimate the size and offset for the transformed image.
    % Probably not the best way to do it, but oh well.
    A = zeros(height,width,2);
    for r = 1:height
        for c = 1:width            
                [c_t,r_t] = transform_point(c,r,transform_params);
                A(r,c,1) = c_t;
                A(r,c,2) = r_t;
        end
    end
    %A(1,1,1) is new column value
    %A(1,1,2) is new row value
    %disp(A);
    max_c = max(max(A(:,:,1)));
    min_c = min(min(A(:,:,1)));
    max_r = max(max(A(:,:,2)));
    min_r = min(min(A(:,:,2)));
    % Get dimensions of new image
    width_t = max_c - min_c;
    height_t = max_r - min_r;
    im_t = zeros(int8(ceil(height_t)),int8( ceil(width_t)));
    for r = 1:height
        for c = 1:width
            new_c = A(r,c,1);
            new_r = A(r,c,2);
            new_c = abs_ceil(new_c - min_c+1); % handle offset
            new_r = abs_ceil(new_r - min_r+1);
            im_t(round(new_r),round(new_c)) = im(r,c);
        end
    end
end

function [r] = abs_ceil(val)
    if val < 0
        r= floor(val);
    else
        r= ceil(val);
    end
end