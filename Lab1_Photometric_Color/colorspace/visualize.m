function visualize(input_image, titles)
    figure();
    subplot(2,2,1);
    imshow(input_image(:, :, 1));
    title(titles(1));
    
    subplot(2,2,2);
    imshow(input_image(:, :, 2));
    title(titles(2));
    
    subplot(2,2,3);
    imshow(input_image(:, :, 3));
    title(titles(3));
    
    % For grays the fourth image should also be single-channel
    if size(input_image, 3) == 4
        subplot(2,2,4);
        imshow(input_image(:, :, 4));
        title(titles(4));
    else
        subplot(2,2,4);
        imshow(input_image);
        title(titles(4));
    end
end

