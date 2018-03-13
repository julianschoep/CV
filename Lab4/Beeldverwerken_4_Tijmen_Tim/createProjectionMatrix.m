function projMatrix = createProjectionMatrix(xy, uv)
    % Gather the necessary points for matrix M
    x = xy(:, 1);
    y = xy(:, 2);
    
    u = uv(:, 1);
    v =  uv(:, 2);
    
    o = ones(size(x));
    z = zeros(size(x));
    
    % Fill in matrix M
    Aoddrows = [x, y, o, z, z, z, -u.*x, -u.*y, -u];
    Aevenrows = [z, z, z, x, y, o, -v.*x, -v.*y, -v];
    
    % Take the kernel of M and then reshape to get the projection matrix
    %M = null([Aoddrows; Aevenrows], 'r');
    projMatrix = [Aoddrows; Aevenrows];
end