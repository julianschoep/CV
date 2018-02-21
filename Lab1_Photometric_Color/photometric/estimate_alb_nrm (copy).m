function [ albedo, normal,avg_residuals ] = estimate_alb_nrm( image_stack, scriptV, image_indices, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   image_indices: the indices of the images to use to estimate albedo and
%   normal. This gives us more control over which images to use for
%   estimation.
%   albedo : the surface albedo
%   normal : the surface normal
%   avg_residuals: the average of the residuals over all <batch_size>
%   images per point, summed up over all (x,y) points. This gives us a
%   measure of fitness on the least squares estimate.

[h, w, n] = size(image_stack);
if ~exist('shadow_trick')
    shadow_trick = true;
end
if ~exist('image_indices')
    % use all images in the image_stack
    batch_size = length(scriptV);
    image_indices = [1:batch_size];
    disp(batch_size);
    disp(image_indices);
else
    scriptV = scriptV(image_indices,:);
    batch_size = length(image_indices);
end
% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)

albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|

avg_residuals  = 0;
if shadow_trick == true;
    for r = 1:h;
        for c = 1:w;
             i = squeeze(image_stack(r,c,:));
             scriptI = diag(i);
             g= mldivide(scriptI*scriptV, scriptI*i);
             %avg_residuals = avg_residuals + mean(abs(residual));
             albedo(r,c,1) = norm(g);
             if norm(g) == 0
                 normal_at_point = 0;
             else
                normal_at_point = g / norm(g);
             end
             normal(r,c,:) = normal_at_point;
        end 
    end 
else
    for r = 1:h;
        for c = 1:w;
            i = squeeze(image_stack(r,c,:));
            
            [g,resnorm, residual] = lsqnonneg(scriptV,i);
            avg_residuals = avg_residuals + mean(abs(residual));
            %reconstructed_point = scriptV*g;
            %constructed(r,c,:) = reshape(reconstructed_point,1,1,5);
            %resnorms(r,c,:) = reshape(abs(residual),1,1,5);
            %g = mldivide(scriptV,i);
            albedo(r,c,1) = norm(g);
            normal_at_point = g / norm(g);
            normal(r,c,:) = normal_at_point;
        end 
    end 
end 
%figure('NumberTitle','off','Name','Albedo SphereGray5 Shadowtrick')
%imshow(albedo);
%figure('NumberTitle','off','Name','Normal SphereGray5 Shadowtrick')
%imshow(normal);
%disp('HELLOO');
avg_residuals = avg_residuals / (h*w);
%disp('end');



% =========================================================================

end

