function [im_t] = transform_image(im,transform_params)
    [h,w] = size(im);
    % Calculate transformed corners to get boundaries of im_t
    % Create a matrix that holds the transposed coordinates. This is used
    % to estimate the size and offset for the transformed image.
    A = zeros(h,w,2);
    for r = 1:h
        for c = 1:w            
                [c_t,r_t] = transform_point(c,r,transform_params);
                A(r,c,1) = c_t;
                A(r,c,2) = r_t;
        end
    end
    %A(1,1,1) is new column value
    %A(1,1,2) is new row value
    max_c = max(max(A(:,:,1)));
    min_c = min(min(A(:,:,1)));
    max_r = max(max(A(:,:,2)));
    min_r = min(min(A(:,:,2)));
    % Get dimensions of new image
    width_t = max_c - min_c + 1;
    height_t = max_r - min_r + 1;
    im_t = zeros(ceil(height_t), ceil(width_t));
    
    for r = 1:h
        for c = 1:w
            new_c = A(r,c,1);
            new_r = A(r,c,2);
            new_c = abs_ceil(new_c - min_c+1); % round coordinates and handle offset.
            new_r = abs_ceil(new_r - min_r+1);
            im_t(new_r,new_c) = im(r,c);
        end
    end
end

% Round coordinates correctly even if < 0
function [r] = abs_ceil(val)
    if val < 0
        r= floor(val);
    else
        r= ceil(val);
    end
end