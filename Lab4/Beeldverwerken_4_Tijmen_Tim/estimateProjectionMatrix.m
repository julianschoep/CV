function M = estimateProjectionMatrix(xy, XY)
    % Make matrix A
    A = createProjectionMatrix(xy, XY);
    
    % Take V from the svd of A
    [~, ~, V] = svd(A);
    m = V(:, end);
    
    % Reshape and transpose
    M = reshape(m, 3, 3)';
    M = M / M(3,3);
end