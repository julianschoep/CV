function [filtered_images] = filter_rgb_images(image_set)
    % Filters out gray images from image set 
    n_images = size(image_set,1);
    filtered_images = cell(n_images,1);
    cntr = 0;
    for i = 1:n_images
        image = image_set{i};
        [r,c,ch] = size(image);
        if ch == 3
            cntr = cntr + 1;
            disp(cntr)
            filtered_images{cntr} = image;
        end
    end
    % Remove empty cells
    filtered_image_set = filtered_images(cellfun('ndims',filtered_images)==3)

end