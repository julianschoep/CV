function [d] = RGBSIFT(im,denseBool)
    [r,c,ch] = size(im);
    
    d = [];
    for i = 1:ch
       if denseBool
            [f,d_i] = vl_phow(single(im(:,:,i)),'Step',10);
       else
            [f,d_i] = vl_sift(single(im(:,:,i)));
       end
       d = cat(2,d,d_i);
    end
end