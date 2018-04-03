function [d] = graySIFT(im, denseBool)
    ch = size(im,3);
    if ch == 3
        im = im2single(rgb2gray(im));
    else
        im = im2single(im);
    end
    
    if denseBool
        
        [f, d] = vl_PHOW(im,'Step',10);
        
    else
        [f, d] = vl_sift(im);
    end

end