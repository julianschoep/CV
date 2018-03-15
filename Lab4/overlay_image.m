function overlay_images(image1, image2, dr, dc)
    % Image1 is the base image
    % Estimated output image depends on 
    
    [r1,c1] = size(image1)
    [r2,c2] = size(image2)
    if dr > 0
        new_height = dr + r2;
    else
        new_height = dr + r1;
    end
    if dc > 0
        new_width = dc + c2;
    else
        new_width = dc + c1;
    end
    result = zeros(new_height, new_width);
    for r=1:new_height
        for c=1:new_width
            if dr > 0
                if dc > 0
                    result(r,c) = image1(r,c)
                    if r - dr > 0 & if c - cr > 0
                        
                            result(r,c) = image2(r-dr,c-cr)
                            
                else
                    
                end
                % first image to display in row will be image 1
            else
                if dc > 0
                    
                else
                    
                end
                
            end
            
        end
    end
    
    


end