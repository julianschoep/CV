function [d] = OpponentSIFT(im,denseBool)
    O = get_opponent_color(im);
    [r,c,ch] = size(O);
    if denseBool
        keypoints = extract_keypoints_DSIFT(im);
    else
        keypoints = extract_keypoints_SIFT(im);
    end
    
    d = [];
    for i = 1:ch
       d_i = extract_descriptors(O(:,:,i),keypoints);
       d = cat(3,d,d_i);
    end
    
end