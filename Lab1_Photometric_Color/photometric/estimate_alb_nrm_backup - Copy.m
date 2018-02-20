function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, n] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);
resnorms = zeros(h,w,1);

% =========================================================================
% YOUR CODE GOES HERE
% for each point in the image array
%   stack image values into a vector i
%   construct the diagonal matrix scriptI
%   solve scriptI * scriptV * g = scriptI * i to obtain g for this point
%   albedo at this point is |g|
%   normal at this point is g / |g|

% For rgb pictures use the mean albedo/normal of the three channels
if length(size(image_stack)) == 4
    [h, w, channel, n] = size(image_stack);
    for c = 1:channel
        image_stack_color = squeeze(image_stack(:, :, c, :));
        if shadow_trick == true
            [alb, nor] = estimate_alb_nrm(image_stack_color, scriptV, shadow_trick);
            albedo = albedo + alb;
            normal = normal + nor;
        else
            [alb, nor] = estimate_alb_nrm(image_stack_color, scriptV);
            albedo = albedo + alb;
            normal = normal + nor;
        end
    end
    albedo = albedo / channel;
    normal = normal / channel;
else
    if shadow_trick == true
        for r = 1:h
            for c = 1:w
                 i = reshape(image_stack(r,c,:),n,1);
                 scriptI = diag(i);
                 g = linsolve(scriptI*scriptV, scriptI*i);
                 disp(size(g));
                 albedo(r,c,1) = norm(g);
                 normal_at_point = g / norm(g);
                 normal(r,c,:) = normal_at_point;
            end 
        end 
    else
        for r = 1:h
            for c = 1:w
                i = reshape(image_stack(r,c,:),n,1); %B in Ax=B

                [g,resnorm, residual] = lsqnonneg(scriptV,i);
                resnorms(r,c,1) = resnorm;
                %g = mldivide(scriptV,i);
                albedo(r,c,1) = norm(g);
                normal_at_point = g / norm(g);
                normal(r,c,:) = normal_at_point;
            end 
        end 
    end 
    figure(1)
    imshow(albedo)
    figure(2)
    imshow(normal)
end


% =========================================================================

end

