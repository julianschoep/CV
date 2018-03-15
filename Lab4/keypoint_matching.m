
function matchingKeypoints = keypoint_matching(image1, image2)
    % vlfeat requires conversion to single precision.
    image1 = im2single(image1);
    image2 = im2single(image2);

     
    % Find matching keypoints.
    [f1, d1] = vl_sift(image1);
    [f2, d2] = vl_sift(image2);
    [matches, ~] = vl_ubcmatch(d1, d2);
     

    xy = [f1(1,matches(1,:))', f1(2,matches(1,:))'];
    XY = [f2(1,matches(2,:))', f2(2,matches(2,:))'];  
  
    matchingKeypoints = [xy, XY];
end

% Windows
% run('D:\Users\vandi\Downloads\vlfeat-0.9.21-bin\vlfeat-0.9.21\toolbox\vl_setup')
% Linux
% run('/usr/src/vlfeat-0.9.21/toolbox/vl_setup')

