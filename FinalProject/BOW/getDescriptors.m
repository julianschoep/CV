function [descriptors] = getDescriptors(func, image_set, dense)
    n = size(image_set,1);
    d_cells= cell(n,1);
    
    parfor i = 1:n
       im = image_set{i}
       ch = size(im,3)
       % Use graySIFT for grayscale imgs
       if ch == 3
            d = func(im,dense);
       else
           d = graySIFT(im, dense);
       end
       d_cells{i} =d;
    end
    
    % Reshape the discriptors to be 128-dimensional (instead of 128x3
    % dimensional?)
    descriptors = [];
    for i = 1:n
        descriptors = cat(2,descriptors,d_cells{i});
    end
    [dim,n,ch] = size(descriptors);
    assert(dim==128,'descriptors have to be 128-dimensional');
    disp("Done retrieving descriptors.");
end