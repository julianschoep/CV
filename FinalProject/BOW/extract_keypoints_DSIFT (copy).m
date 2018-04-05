function [keypoints] = extract_keypoints_DSIFT(image)
    % Extract dense keypoints, but subsample them to only take every 10th
    % pixel
    image = im2single(rgb2gray(image));
    disp(size(image));
    binSize = 8;
    magnif = 3;
    image_smoothed = vl_imsmooth(image,sqrt((binSize/magnif)^2-.25));
    % Find matching keypoints.
    [f, d] = vl_dsift(image_smoothed,'size',binSize);
    % Take every 10th keypoint
    
    n = size(f,2);
    cntr = 0;
    for i= 1:n
        if mod(cntr,10) == 0
            if ~exist('keypoints','var')
                keypoints = f(:,i)
            else
                keypoints = cat(2, keypoints, f(:,i));
            end
        end
        cntr = cntr + 1;
    end
end


%run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')