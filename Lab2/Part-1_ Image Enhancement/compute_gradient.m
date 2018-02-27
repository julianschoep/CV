function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
GxKernel = [1,0,-1;2,0,-2;1,0,-1];
GyKernel = [1,2,1;0,0,0;-1,-2,-1];
Gx = imfilter(image,GxKernel, 'replicate','same','conv');
Gy = imfilter(image,GyKernel, 'replicate','same','conv');
[h, w,d] = size(image);
im_magnitude = zeros(h,w);
im_direction = zeros(h,w);
for r = 1:h
    for c = 1:w
        Gxi = double(Gx(r,c)); % x gradient at point
        Gyi = double(Gy(r,c)); % y gradient at point
        im_magnitude(r,c) = sqrt((Gxi^2)+(Gyi^2));
        if Gyi == 0
            im_direction(r,c) = atan(0);
        elseif Gxi == 0
            im_direction(r,c) = atan(inf);
        else
            im_direction(r,c) = atan(Gyi/Gxi); 
        end
        
    end
end

end

