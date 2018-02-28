function imOut = compute_LoG(image, LOG_type,sigma_1,sigma_2)

switch LOG_type
    case 1
        %method 1: Smoothing the image with a Gaussian kernel (kernel size of 5 and
        %    standard deviation of 0.5), then taking the Laplacian of the smoothed image
        %    (i.e. second derivative).
        gauss_kernel = fspecial('gaussian',5,0.5);
        smoothed_image =  imfilter(image,gauss_kernel, 'replicate','same','conv');
        laplacian_kernel = fspecial('laplacian');
        imOut = imfilter(smoothed_image,laplacian_kernel, 'replicate','same','conv');
    case 2
        %method 2: Convolving the image directly with a LoG kernel (kernel size of 5
        %    and standard deviation of 0.5).
        LoG_kernel = fspecial('log',5,0.5);
        imOut = imfilter(image,LoG_kernel, 'replicate','same','conv');
    case 3
        %method 3: Taking the Difference of two Gaussians (DoG) computed at different
        %    scales σ 1 and σ 2 .
        gauss_kernel_1 = fspecial('gaussian',5,sigma_1);
        %im1 = imfilter(image,gauss_kernel_1, 'replicate','same','conv');
        gauss_kernel_2 = fspecial('gaussian',5,sigma_2);
        %im2 = imfilter(image,gauss_kernel_2, 'replicate','same','conv');
        DoG_kernel = gauss_kernel_1 - gauss_kernel_2;
        imOut = imfilter(image,DoG_kernel, 'replicate','same','conv');
        %imOut = im1-im2;

end
end

