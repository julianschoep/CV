function [f] = extract_keypoints_SIFT(image)
    [r,c,n_ch] = size(image);
    if n_ch == 3
        image = im2single(rgb2gray(image));
    else
        image = im2single(image);
    end
    % Find matching keypoints.
    [f, d] = vl_sift(image);
end


