function [I] = load_filename_list(dir,n)
    I = cell(n,1);
    for i = 1:n
        img_name = sprintf('img%03.f.jpg',i);
        img_path = [dir,img_name];
        disp(img_path);
        disp(img_name);
        I_i = imread(img_path);
        I{i} = I_i
        
    end
end