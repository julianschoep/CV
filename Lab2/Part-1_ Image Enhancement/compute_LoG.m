function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1: Smoothing the image with a Gaussian kernel (kernel size of 5 and
        %    standard deviation of 0.5), then taking the Laplacian of the smoothed image
        %    (i.e. second derivative).
    
    case 2
        %method 2: Convolving the image directly with a LoG kernel (kernel size of 5
        %    and standard deviation of 0.5).
	% bla bla
    case 3
        %method 3: Taking the Difference of two Gaussians (DoG) computed at different
        %    scales σ 1 and σ 2 .
    
end
end

