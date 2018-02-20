function [output_image, titles] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
    [R, G, B] = getColorChannels(input_image);
    titles = ["Opponent red", "Opponent blue", "Opponent green", "Opponent"];
    opp_R = (R - G) / sqrt(2);
    opp_G = (R + G - 2 * B) / sqrt(6);
    opp_B = (R + G + B) / sqrt(3);
    output_image = cat(3, opp_R, opp_G, opp_B);
end

