function [f] = extract_keypoints_SIFT(image)
    image = im2single(rgb2gray(image));
    % Find matching keypoints.
    [f, d] = vl_sift(image);
end


