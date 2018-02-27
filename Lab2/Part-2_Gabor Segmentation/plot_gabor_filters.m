function plot_gabor_filters()
%[gabor filter, filter_title] = createGabor( sigma, theta, lambda, psi, gamma )
% We have to visualize theta, sigma and gamma
%   - ARGUMENTS
%     sigma      Standard deviation of Gaussian envelope.
%     theta      Orientation of the Gaussian envelope. Takes arguments in
%                the range [0, pi/2).
%     lambda     The wavelength for the carriers. The central frequency 
%                (w_c) of the carrier signals.
%     psi        Phase offset for the carrier signal, sin(w_c . t + psi).
%     gamma      Controls the aspect ratio of the Gaussian envelope
i=0
for sigma= [1,5,10]
            i = i + 1;
            
            [gaborComplex, gaborTitle] = createGabor(sigma, 0, 15, 0, 1);
            gaborReal = gaborComplex(:,:,1);
            gaborImaginary = gaborComplex(:,:,2);
            subplot(3,6,i), imshow(gaborReal,[]);
            i = i + 1;
            title(['\sigma: ', num2str(sigma), ', \theta: ', num2str(0), ', \gamma: ',num2str(1)])
            subplot(3,6,i), imshow(gaborImaginary, []);
            
end
for theta=[0,(pi/4),(pi/2)]
    i = i + 1;
    [gaborComplex, gaborTitle] = createGabor(sigma, theta, 15, 0, 1);
    gaborReal = gaborComplex(:,:,1);
    gaborImaginary = gaborComplex(:,:,2);
    subplot(3,6,i), imshow(gaborReal,[]);
    i = i + 1;
    if theta == 0 
        title(['\sigma: ', num2str(sigma), ', \theta: 0, \gamma: ',num2str(1)])
    else
        title(['\sigma: ', num2str(sigma), ', \theta: 1/', num2str(pi/theta), '\pi, \gamma: ',num2str(1)])
    end
    subplot(3,6,i), imshow(gaborImaginary, []);
end

for gamma=[0.5,1,2]
    i = i + 1;
    [gaborComplex, gaborTitle] = createGabor(sigma, 0, 15, 0, gamma);
    gaborReal = gaborComplex(:,:,1);
    gaborImaginary = gaborComplex(:,:,2);
    subplot(3,6,i), imshow(gaborReal,[]);
    i = i + 1;
    title(['\sigma: ', num2str(sigma), ', \theta: ', num2str(0), ', \gamma: ',num2str(gamma)])
    subplot(3,6,i), imshow(gaborImaginary, []);
end