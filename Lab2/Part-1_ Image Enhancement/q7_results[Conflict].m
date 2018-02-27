% Load images, convert to double precision
gauss_noise = im2double(imread('images\image1_gaussian.jpg'));
sp_noise = im2double(imread('images\image1_saltpepper.jpg'));
orig = im2double(imread('images\image1.jpg'));

image = {gauss_noise, sp_noise};
type = ["Box", "Median"];
kernel_size = [3 5 7];

for i = 1:2
    plot = 1;
    figure(i)
    for j = 1:2
        for k = 1:3
            approx = denoise(image{i}, type(j), kernel_size(k));
            subplot(2, 3, plot)
            imshow(approx);
            str = sprintf('%s filter of size %dx%d', type(j), kernel_size(k), kernel_size(k));
            title(str);
            plot = plot + 1;
            PSNR = myPSNR(approx, orig); 
            fprintf('PSNR = %d for image %d with %s filter of size %dx%d\n', PSNR, i, type(j), kernel_size(k), kernel_size(k));
        end
    end
end

sigma = [1/2 1.0 2.0];
kernel_size = [3 5 7 9 11];

figure(3)
plot = 1;
"Gaussian"
for j = 1:3
    for k = 1:5
        approx = denoise(gauss_noise, "Gaussian", kernel_size(k), sigma(j));
        subplot(3, 5, plot)
        imshow(approx);
        str = sprintf('Sigma %d of size %dx%d', sigma(j), kernel_size(k), kernel_size(k));
        title(str);
        plot = plot + 1;
        PSNR = myPSNR(approx, orig); 
        fprintf('PSNR = %d with sigma %d of size %dx%d\n', PSNR, sigma(j), kernel_size(k), kernel_size(k));
    end
end
