function [output_image, titles] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb
    [R, G, B] = getColorChannels(input_image);
    titles = ["Red", "Green", "Blue", "Normalized RGB"];
    norm_R = R ./ (R + G + B);
    norm_G = G ./ (R + G + B);
    norm_B = B ./ (R + G + B);
    output_image = cat(3, norm_R, norm_G, norm_B);
end

