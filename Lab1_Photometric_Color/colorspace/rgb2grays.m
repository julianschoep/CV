function [output_image, titles] = rgb2grays(input_image)
    % converts an RGB into grayscale by using 4 different methods
    titles = ["Lightness", "Average", "Luminosity", "MATLAB"];
    [R, G, B] = getColorChannels(input_image);
    
    % ligtness method
    lightness = (max(max(R, G), B) + min(min(R, G), B)) / 2;

    % average method
    average = (R + G + B) / 3;

    % luminosity method
    luminosity = 0.21 * R + 0.72 * G + 0.07 * B;

    % built-in MATLAB function 
    matlab = rgb2gray(input_image); % 0.2989 * R + 0.5870 * G + 0.1140 * B
    
    output_image = cat(3, lightness, average, luminosity, matlab);
end

