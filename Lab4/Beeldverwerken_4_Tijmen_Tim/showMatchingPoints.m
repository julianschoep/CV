function showMatchingPoints(im1, im2)
 % Convert the images to single format
    im1 = im2single(im1);
    im2 = im2single(im2);
        
    % Find matches
    [fa, da] = vl_sift(im1);
    [fb, db] = vl_sift(im2);
    [matches, ~] = vl_ubcmatch(da, db);
    
    % Reshape and concatenate the images in order to plot the lines
    im2 = imresize(im2, size(im1));
    concat = cat(2,im1,im2);
    imshow(concat);
    hold on;
    
    % Part of this implementation is taken from a demo file provided by
    % vl_feat. Located at: vlfeat/toolbox/demo/vl_demo_sift_match.m
    
    % Draw lines from a point in image 1 to the corresponding match in
    % image 2
    xa = fa(1,matches(1,:));
    xb = fb(1,matches(2,:)) + size(im1,2);
    ya = fa(2,matches(1,:));
    yb = fb(2,matches(2,:));
    h = line([xa ; xb], [ya ; yb]);
    set(h,'linewidth', 1, 'color', 'b');

    % Plot the matchpoints
    vl_plotframe(fa(:,matches(1,:)));
    fb(1,:) = fb(1,:) + size(im1,2);
    vl_plotframe(fb(:,matches(2,:)));
    axis image off ;
    hold off;
end

