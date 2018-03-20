function [O] = get_opponent_color(rgb_image)
    rgb_image = im2double(rgb_image);
    R = rgb_image(:,:,1);
    G = rgb_image(:,:,2);
    B = rgb_image(:,:,3);
    
    
    O1 = (R-G)/sqrt(2);
    O2 = (R+G-2*B)/sqrt(6);
    O3 = (R+G+B)/sqrt(3);
    O = cat(3,O1,O2,O3);
    

end