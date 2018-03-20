function [d] = RGBSIFT(im,denseBool)
    [r,c,ch] = size(im);
    if denseBool
        keypoints = extract_keypoints_DSIFT(im);
    else
        keypoints = extract_keypoints_SIFT(im);
    end
    d = [];
    for i = 1:ch
       d_i = extract_descriptors(im(:,:,i),keypoints);
       d = cat(3,d,d_i);
    end
end