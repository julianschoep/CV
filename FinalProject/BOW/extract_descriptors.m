function [d] = extract_descriptors(I,f)
    I_ = vl_imsmooth(im2double(I),sqrt(f(3)^2 - 0.5^2));
    [Ix, Iy] = vl_grad(I_);
    mod = sqrt(Ix.^2 + Iy.^2);
    ang = atan2(Iy,Ix);
    grd = shiftdim(cat(3,mod,ang),2);
    grd = single(grd);
    d = vl_siftdescriptor(grd,f);

end