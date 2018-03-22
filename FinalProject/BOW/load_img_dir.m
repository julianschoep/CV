function [I] = load_img_dir(dir_path)
    
    a=dir([dir_path '*.jpg']);
    n = size(a,1);
    disp("Number of images in directory: " + n)
    I = cell(n,1);
    for i = 1:n
        img_name = sprintf('img%03.f.jpg',i);
        img_path = [dir_path,img_name];
        disp(img_path);
        disp(img_name);
        I_i = imread(img_path);
        I{i} = I_i;
        
    end
end

