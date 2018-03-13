function bestmodel = ransac(data, k, thresh, d, s)
    % Initialize the best error. This should be a big number, so that newly
    % found best error is smaller than the standard value of 10000
    besterr = 10000;
    
    % Initialization of the best model, if the function returns an empty
    % matrix we know that the algorithm didn't find an best model
    bestmodel = [];
    
    % Represent the coordinates of the matches in a separate variable with
    % homogeneous coordinates, we use this variable later on
    xy = [data(:, 1:2), ones(size(data,1), 1)]';
    
    % Iterate k times, this is an input variable
    for i = 1:k
        % Sample s random points, s is an input variable
        sample = datasample(data, s);
        % Calculate the projection matrix with our implemented
        % estimateProjectionMatrix function
        projMatrix = estimateProjectionMatrix(sample(:, 1:2), ...
                                              sample(:, 3:4));
        % The inlier points should be null at the beginnen of each iteration
        % because from now on we are going to find them
        inliers = [];
        
        % Iterate over each matching point
        for elem = 1:size(data, 1)
            % Find the points in the second image given the projection
            % matrix
            possibleinlier = projMatrix * xy(:, elem);
            % Divide by the homogeneous coordinate
            possibleinlier = possibleinlier / possibleinlier(3);
            % Calculate the distance between the original point in the
            % second image and the calculated points that we gathered using 
            % the projection matrix
            distance = sqrt((data(elem, 3) - possibleinlier(1))^2 ...
                          + (data(elem, 4) - possibleinlier(2))^2);
            % If the distance is lower or equal to the threshold, we add
            % the point as an inlier
            if distance <= thresh
                inliers = [inliers; data(elem, :)];
            end
        end
        
        % If the amount of inliers satisfies the amount of desired inliers,
        % continue
        if (size(inliers, 1) > d)
            % We now compute a new projeciton matrix based on the new
            % points classified as inliers
            thismodel = estimateProjectionMatrix(inliers(:, 1:2), ...
                                                   inliers(:, 3:4));
            % Initialize the error each iteration to 0
            thiserr = 0;
            % Iterate over the amount of inliers
            for elem = 1:size(inliers, 1)
                % Calculate the current error
                fittedpoint = thismodel * [inliers(elem, 1:2), 1]';
                thiserr = thiserr + sqrt((inliers(elem, 3) - fittedpoint(1))^2 ...
                                       + (inliers(elem, 4) - fittedpoint(2))^2);
            end
            % If the current calculated error is better than the best
            % error, make it the new best error, update the corresponding
            % model aswell
            if thiserr < besterr
                besterr = thiserr;
                bestmodel = thismodel;
            end
        end
    end
end

