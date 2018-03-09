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
images = imread([dir_name,'/',image_filenames(1,:)]);
for i= 2:n_files
    % Read in subsequent images
    url = [dir_name,'/',image_filenames(i,:)];
    temp_i = imread(url);
    images = cat(4,images,temp_i);
end


[H, r,c] = harris_corner_detector(images(:,:,:,1), k,sigma,N,t);
for i=2:n_files
    image = images(:,:,:,i);
    % For every image
    % determine next point of feature
    % overlay said point on image
    % save image
end

end

function demo
    % still have to determine s
    tracking( './pingpong', s, 5, 5, 5, 0.1)
    
    tracking( './person_toy', s, 7, 3, 9, 0.02)
end




