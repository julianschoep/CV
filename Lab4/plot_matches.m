% Plots lines between matches across two images.
function plot_matches(matches, image1, image2)
    % Concatenate images and show
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
