function [d] = graySIFT(im, denseBool)
    im = im2single(rgb2gray(im));
    if denseBool
        binSize = 8;
        magnif = 3;
        image_smoothed = vl_imsmooth(im,sqrt((binSize/magnif)^2-.25));
        [f, d] = vl_dsift(image_smoothed,'size',binSize);
        
    else
        [f, d] = vl_sift(im);
    end

end