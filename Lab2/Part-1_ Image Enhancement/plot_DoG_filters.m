function imOut = plot_DoG_filters(sigma_1, sigma_2)
image = (imread('./images/image2.jpg'));
%imOut = compute_LoG(image, LOG_type,sigma_1,sigma_2)
hold on
caption = sprintf('sigma 1: %.2f, sigma 2:  %.01f, ratio: %.1f',sigma_1,sigma_2,sigma_1/sigma_2);
imOut = compute_LoG(image, 3,sigma_1,sigma_2);
log = compute_LoG(image, 2,sigma_1,sigma_2);
h1 = subplot(1,3,1);imshow(log,[]);
title(caption)
%h1 = subplot(1,3,2);imshow(log,[]);
%title('LoG')
%suptitle(caption);

set(h1, 'Position',[0.1,0,0.66666,1]);
%set(h2, 'Position',[0.38,0.3,0.66666,.6]);



hold off

end