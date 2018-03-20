function [rgb] = get_normalized_color(rgb_image)
    rgb_image = im2double(rgb_image);
    R = rgb_image(:,:,1);
    G = rgb_image(:,:,2);
    B = rgb_image(:,:,3);
    
    r = R./(R+G+B);
    g = G./(R+G+B);
    b = B./(R+G+B);
    rgb = cat(3,r,g,b);
    
    
end