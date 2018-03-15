function [transform_params transform_matrix,inlier_matchpoints] = ransac(im1, im2, N, P, verbose_mode)
    % Verbose mode:
    % - 0 means no plots at all
    % - 1 means plots of all subsamples
    % - 2 means all plots.
    % Get the size parameters of both images.
    vm = verbose_mode;
    [height,width] = size(im1);
    % Get the point matches of the two images
    matches = keypoint_matching(im1,im2);
    % get ith match
    % [x1,y1,x2,y2] = matches(i,:)

    % best number of inliers (higher is better)
    best_n = 0;
    best_transform_params = [];
    best_inliers_idx = [];

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
        transform_params = pinv(A)*b;
        x1 = matches(:,1);
        y1 = matches(:,2);
        % placeholders for estimated coordinates
        estimated_cords = zeros(length(x1),2);
        target_cords = matches(:,3:4);
        % Stitch images together and show them.
        % images are catted in x plane.
        if vm ==1
            both_im = cat(2, im1, im2);
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
        if vm==1;scatter(matches(:,3)+width,matches(:,4),'ro');end
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
    inlier_matchpoints = zeros(best_n,4);
    for i = 1:best_n
        idx = best_inliers_idx(i);
        inlier_matchpoints(i,:) = matches(idx,:);
        [x,y,u,v] = get_vars(matches(idx,:));
        [Ai,bi] = getAb_point(x,y,u,v);
        A = cat(1,A,Ai);
        b = cat(1,b,bi);
    end
    disp("New transform parameters found");
    transform_params = pinv(A)*b;
    [m1,m2,m3,m4,t1,t2] = get_vars(transform_params);

    transform_matrix = [m1,m2,t1;m3,m4,t2;0,0,1];
    end

function [A,b] = getAb_point(x,y,u,v)
    A = [x,y,0,0,1,0;0,0,x,y,0,1];
    b = [u;v];

end

function varargout = get_vars(thing)
    n = length(thing);
    varargout = cell(1,n);
    for k = 1:n
        varargout{k} = thing(k);
    end
end

function [inlier_idx] = get_inliers(estimated_cords, target_cords)
    inlier_idx = [];
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