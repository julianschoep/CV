function [keypoints] = extract_keypoints_DSIFT(image)
    % Extract dense keypoints, but subsample them to only take every 10th
    % pixel
    [r,c,ch] = size(image);
    padding = 13;
    l = (r/10)*(c/10);
    keypoints = cell(1,l);
    cntr = 1;
    for x = padding:10:(c-padding)
        for y = padding:10:(r-padding)
            keypoints{cntr} = [x;y];
            cntr = cntr +1;
        end
    end
    keypoints = cell2mat(keypoints);
end


%run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')