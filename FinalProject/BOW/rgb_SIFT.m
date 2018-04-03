function [d] = rgb_SIFT(im, denseBool)
    
    [r,c,ch] = size(im);
    
    d = [];
    % Get rgb normalized image
    rgb = get_normalized_color(im);
    for i = 1:ch
       if denseBool
           d_i = vl_phow(single(rgb(:,:,i)),'Step',10);
       else
           d_i = vl_sift(single(rgb(:,:,i)));
       end
       d = cat(2,d,d_i);
    end
end