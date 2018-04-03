function [d] = OpponentSIFT(im,denseBool)
    % Get opponent colors of image
    O = get_opponent_color(im);
    [r,c,ch] = size(O);
    d = [];
    for i = 1:ch
       if denseBool
            [f,d_i] = vl_phow(single(O(:,:,i)),'Step',10);
       else
            [f,d_i] = vl_sift(single(O(:,:,i)));
       end
       d = cat(2,d,d_i);
    end
end
