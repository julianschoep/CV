function [ PSNR ] = myPSNR( orig_image, approx_image )
<<<<<<< HEAD
    rmse = sqrt(immse(orig_image, approx_image));
    PSNR = 20 * log10(max(max(orig_image)) / rmse);
=======


>>>>>>> 6b8db9cb9059552a7e392a78227432ee56a2b72f
end

