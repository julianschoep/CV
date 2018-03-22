function [descriptors] = getDescriptors(func, image_set, dense)
    n = size(image_set,1);
    descriptors= [];
    for i = 1:n
       d = func(image_set{i},dense);
       descriptors = cat(2,descriptors,d);
    end

    % Reshape the discriptors to be 128-dimensional (instead of 128x3
    % dimensional?)
    [dim,n,ch] = size(descriptors);
    assert(dim==128,'descriptors have to be 128-dimensional');
    descriptors = reshape(descriptors,[128,(n*ch)]);
    disp("Done retrieving descriptors.");
end