function estimatedpoints = estimateGivenPoints(xy, XY, data)
    % Estimating the projection matrix from the given four points
    projMatrix = estimateProjectionMatrix(xy, XY);
    disp(projMatrix);

    % Now we project the remaining points with the projection matrix
    estimatedpoints = [];
    for i = 1:size(data, 1)
        estimpoint = projMatrix * [data(i, 1:2), 1]';
        estimpoint = estimpoint / estimpoint(3);
        estimatedpoints = [estimatedpoints; estimpoint(1:2)'];
    end
end

