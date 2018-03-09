function [image_list] =  only_images(directory_contents) 
    image_list = [];
    for i = 1:length(directory_contents)
        filename = directory_contents(i).name;
        if length(filename) > 4
            if filename(end-3:end) == 'jpeg'
                image_list = cat(1, image_list, filename);
            elseif filename(end-2:end) == 'jpg'
                image_list = cat(1, image_list, filename);
            end
        end
    end
end