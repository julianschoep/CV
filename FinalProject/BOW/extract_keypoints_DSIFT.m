function [f] = extract_keypoints_DSIFT(image)

    image = im2single(rgb2gray(image));
    
    binSize = 8;
    magnif = 3;
    image_smoothed = vl_imsmooth(image,sqrt((binSize/magnif)^2-.25));
    % Find matching keypoints.
    [f, d] = vl_dsift(image_smoothed,'size',binSize);
    
end


%run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')