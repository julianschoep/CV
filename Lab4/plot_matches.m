% Plots lines between matches across two images.
function plot_matches(matches, image1, image2)
    % Concatenate images and show
    
    % Deal with images that don't have the same size
    [width1, height1] = size(image1);
    [width2, height2] = size(image2);
    width_dif = width1 - width2;
    height_dif = height1 - height2;
    
    if width_dif > 0
        % Widht image 1 heigher than image2. Pad zeros.
        image2 = padarray(image2, [width_dif 0],0,'post');
    elseif width_dif < 0
        image1 = padarray(image1, [-width_dif 0], 0, 'post');
    end
    if height_dif > 0
        % Widht image 1 heigher than image2. Pad zeros.
        image2 = padarray(image2, [0 height_dif],0,'post');
    elseif height_dif < 0
        image1 = padarray(image1, [0 -height_dif], 0, 'post');
    end
    concat = cat(2, image1,image2);
    imshow(concat);
    hold on;
   
    % Sample 50 random samples
    matches = datasample(matches, 50);
    
    % Plot lines
    x1 = matches(:,1);
    y1 = matches(:,2);
    x2 = matches(:,3) + size(image1,2);
    y2 = matches(:,4);
    plot([x1 x2]',[y1 y2]', 'LineWidth', 1.3)
    hold off;
end
