function [ image_stack ] stack_images (dirname)

images = dir(strcat(dirname,'\*.png'))
image_stack = []

for file = images'
    file.name = strcat('photometrics_images\SphereGray5\', file.name)
    image = imread(file.name);
    imshow(image);
    image_stack = cat(3, image_stack, image);
end

end