function [ PSNR ] = myPSNR( orig_image, approx_image )
    rmse = sqrt(immse(orig_image, approx_image));
    PSNR = 20 * log10(max(max(orig_image)) / rmse);
end

