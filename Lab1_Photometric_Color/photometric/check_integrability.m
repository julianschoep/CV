function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
p = zeros(size(normals, 1), size(normals, 2));
q = zeros(size(normals, 1), size(normals, 2));
SE = zeros(size(normals, 1), size(normals, 2));

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy

% normal = zeros(h, w, 3);

for i = 1:size(normals, 1)
    for j = 1:size(normals, 2)
        p(i, j) = normals(i, j, 1) / normals(i, j, 3);
        q(i, j) = normals(i, j, 2) / normals(i, j, 3);
    end
end

% p1 = zeros(size(normals, 1), size(normals, 2));
% p1 = normals(:, :, 1) / normals(:, :, 3);
% assert(isequal(p, p1), 'p is not equal to p1')
% ========================================================================

p(isnan(p)) = 0;
q(isnan(q)) = 0;

% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE

% for i = 1:size(normals, 1)
%     for j = 1:size(normals, 2)
%         SE(i, j) = (p(i, j) / normals(i, j, 3) - q(i, j) / normals(i, j, 3))^2;
%     end
% end

% Pad array with zeros
% delta_p = diff(p, 1, 1); % 511 x 512
% delta_p = cat(1, zeros(1, size(delta_p, 2)), delta_p);
% 
% delta_q = diff(q, 1, 2); % 512 x 511
% delta_q = cat(2, zeros(size(delta_q, 1), 1), delta_q);

[dpdx, dpdy] = gradient(p);
[dqdx, dqdy] = gradient(q);

SE = (dpdy - dqdx).^2;

% ========================================================================

end

