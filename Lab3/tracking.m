function tracking( dir_name, s, k, sigma, N, t)
% Parameters
% dir_name  : directory where the input images live
% s         : region s%ize for lucas-kanade
% k         : kernel size of gaussian in Harris corner detector
% sigma     : standard deviation of that gaussian
% N         : size of region of local optimum function (maybe set same as s?)
% t         : threshold for corner detector

image_filenames = only_images(dir(dir_name));
n_files = length(image_filenames);

% Read in the first image
images = im2double(imread([dir_name,'/',image_filenames(1,:)]));
for i= 2:n_files
    % Read in subsequent images
    url = [dir_name,'/',image_filenames(i,:)];
    temp_i = im2double(imread(url));
    images = cat(4,images,temp_i);
end

[H, r, c] = harris_corner_detector(images(:,:,:,1), k,sigma,N,t);
for i=2:n_files
    image1 = images(:,:,:,i-1);
    image2 = images(:,:,:,i);
    
    fig = figure(4)
    imshow(image1)
    hold on
    
    gray_image1 = im2double(rgb2gray(image1));
    gray_image2 = im2double(rgb2gray(image2));
    [r,c,v1,v2] = plot_optical_flow_corners(gray_image2, gray_image1, s, r, c);
    r = r+1.5*v2;
    c = c+1.5*v1;

    scatter(c+v2,r+v1,15,'red');
    str = sprintf('animation/%s_%d.jpg', dir_name, i);
    hold off
    saveas(fig,str)
    %pause(0.1);
    % For every image
    % determine next point of feature
    % overlay said point on image
    % save image
end

end

function demo
    % still have to determine s
    s = 9
    tracking( './pingpong', s, 5, 5, 5, 0.1);
    
    tracking( './person_toy', s, 7, 3, 9, 0.02);
end