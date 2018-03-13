function ransac(im1, im2, N, P, verbose_mode)
% Verbose mode:
% - 0 means no plots at all
% - 1 means plots of all subsamples
% - 2 means all plots.
% Get the size parameters of both images.
vm = verbose_mode
[height,width] = size(im1);
% Get the point matches of the two images
matches = keypoint_matching(im1,im2);
% get ith match
% [x1,y1,x2,y2] = matches(i,:)

% best number of inliers (higher is better)
best_n = 0
best_transform_params = []
best_inliers_idx = []

for i = 1:N
    % Take P unique samples
    selected = datasample(matches,P, 'Replace',false);
    A = [];
    b= [];
    for j = 1:P
        [x,y,u,v] = get_vars(selected(j,:));
        [Ai,bi] = getAb_point(x,y,u,v);
        A = cat(1,A,Ai);
        b = cat(1,b,bi);
    end
    transform_params =pinv(A)*b;
    x1 = matches(:,1);
    y1 = matches(:,2);
    % placeholders for estimated coordinates
    estimated_cords = zeros(length(x1),2);
    target_cords = matches(:,3:4);
    % Stich images together and show them.
    % images are catted in x plane.
    both_im = cat(2, im1, im2);
    if vm ==1
        figure();imshow(both_im);
        hold on;
    end
    for k=1:length(matches)
        [x,y,u,v] = get_vars(matches(k,:));
        % Calculate transormed points
        [x_t, y_t] = transform_point(x,y,transform_params);
        estimated_cords(k,:) = [x_t,y_t];
        
        if vm ==1
            % Have to add width of input images since they are put together
            % along x-axis
            plot([x,x_t+width],[y,y_t], 'bo-');
        end
    end
    % Scatter the target locations as well in red.
    if vm==1;scatter(matches(:,3)+width,matches(:,4),'ro');end;
    % Get the indexes of the inliers. Number of inliers is simply the
    % length of the array containing the indexes of the inliers.
    inliers_idx = get_inliers(estimated_cords, target_cords);
    num_inliers = length(inliers_idx);
    if  num_inliers > best_n
        best_transform_params = transform_params;
        best_n = num_inliers;
        best_inliers_idx = inliers_idx;
    end
end
% We now have obtained the transformation parameters that yield the highest
% number of inliers. We also have those inliers saved in best_inliers_idx.
% We can now estimate the transformation matrix on these inliers instead of
% the random samples we did earlier.

A = [];
b = [];
for i = 1:best_n
    idx = best_inliers_idx(i);
    [x,y,u,v] = get_vars(matches(idx,:));
    [Ai,bi] = getAb_point(x,y,u,v);
    A = cat(1,A,Ai);
    b = cat(1,b,bi);
end
disp("New transform params found");
transform_params =pinv(A)*b;
[a1,a2,a3,a4,a5,a6] = get_vars(transform_params);

transform_matrix = [a1,a2,a3;a4,a5,a6;0,0,1];
%T = maketform('affine',transform_matrix);

%plot the images
%im_t = imtransform(im2,T);
%figure();
%subplot(1,3,1);imshow(Ix);title("Ix")
figure();
subplot(1,3,1);imshow(im1);
subplot(1,3,2);imshow(im2);
im_t = transform_image(im1,transform_params);
subplot(1,3,3);imshow(im_t,[]);
end

function [im_t] = transform_image(im,transform_params)
    [height,width] = size(im);
    % Calculate transformed corners to get boundaries of im_t
    % Create a matrix that holds the transposed coordinates. This is used
    % to estimate the size and offset for the transformed image.
    % Probably not the best way to do it, but oh well.
    A = zeros(height,width,2);
    for r = 1:height
        for c = 1:width            
                [c_t,r_t] = transform_point(c,r,transform_params);
                A(r,c,1) =c_t;
                A(r,c,2) = r_t;
        end
    end
    %A(1,1,1) is new column value
    %A(1,1,2) is new row value
    %disp(A);
    max_c = max(max(A(:,:,1)));
    min_c = min(min(A(:,:,1)));
    max_r = max(max(A(:,:,2)));
    min_r = min(min(A(:,:,2)));
    % Get dimensions of new image
    width_t = max_c - min_c;
    height_t = max_r - min_r;
    im_t = zeros(int8(ceil(height_t)),int8( ceil(width_t)));
    for r = 1:height
        for c = 1:width
            new_c = A(r,c,1);
            new_r = A(r,c,2);
            new_c = abs_ceil(new_c - min_c+1); % handle offset
            new_r = abs_ceil(new_r - min_r+1);
            im_t(new_r,new_c) = im(r,c);
        end
    end
end

function [A,b] = getAb_point(x,y,u,v)
    A = [x,y,0,0,1,0;0,0,x,y,0,1];
    b = [u;v];

end
function [r] = abs_ceil(val)
    if val < 0
        r= floor(val);
    else
        r= ceil(val);
    end
end

function varargout = get_vars(thing)
    n = length(thing);
    varargout = cell(1,n);
    for k = 1:n
        varargout{k} = thing(k);
    end
end

function [inlier_idx] = get_inliers(estimated_cords, target_cords)
    inlier_idx = []
    for i=1:length(estimated_cords)
        [xe,ye] = get_vars(estimated_cords(i,:));
        [xt,yt] = get_vars(target_cords(i,:));
        if cart_dist(xe,xt,ye,yt) < 10
            inlier_idx = cat(2,inlier_idx,i);
        end
    end
end

function [dist] = cart_dist(x1,y1,x2,y2)
    dist = sqrt((x1-x2)^2+(y1-y2)^2);
end
function [x_t,y_t] = transform_point(x,y,transform_params)
    [m1,m2,m3,m4,t1,t2] = get_vars(transform_params);
    M = [m1,m2;m3,m4];
    r= M*[x;y]+[t1;t2];
    x_t = r(1);
    y_t = r(2);
end
