function [result] =overlay_images(image1, image2, dr, dc)
    % Image1 is the base image
    % Estimated output image depends on 
    
    [r1,c1] = size(image1);
    [r2,c2] = size(image2);
    if dr > 0
        new_height = ceil(r2 + dr);
    else
        new_height = ceil(r1 - dr);
    end
    if dc > 0
        new_width = ceil(c2 + dc);
    else
        new_width = ceil(c1 - dc);
    end
    
    result = zeros(new_height, new_width);
    for r=1:new_height
        for c=1:new_width
            if dr > 0
                if dc > 0
                    if r < r1 & c < c1
                        result(r,c) = image1(r,c);
                    end
                    if (round(r - dr) > 0) & (round(c - dc) > 0) & round(r-dr) < r2 & round(c-dc) < c2
                        if image2(round(r-dr),round(c-dc)) ~= 0 
                            result(r,c) = image2(round(r-dr),round(c-dc));
                        end
                    end
                else
                    %dr > 0 but dc < 0
                    if round(c + dc) > 0 & r < r1 & round(c+dc) < c1
                        result(r,c) = image1(r,round(c+dc));
                    end
                    if r - dr > 0 & c < c2 & (r-dr) < r2
                        if image2(round(r-dr),c) ~= 0
                            result(r,c) = image2(round(r-dr),c);
                        end
                    end
                end
                % first image to display in row will be image 1
            else
                % dr < 0
                if dc > 0
                    if r + dr > 0 & c < c1 & round(r+dr) < r1
                        result(r,c) = image1(round(r+dr),c);
                    end
                    if round(c - dc) > 0 & r < r2 & round(c-dc) < c2
                        if image2(r,round(c-dc)) ~= 0
                            result(r,c) = image2(r,round(c-dc));
                        end
                    end
                else
                    % dr < 0 & dc < 0
                    if round(r + dr) > 0 & round(c + dc) > 0 & round(r+dr) < r1 & round(c+dc) < c1
                        result(r,c) = image1(round(r+dr),round(c+dc));
                    end
                    if r < r2 & c < c2
                        if image2(r,c) ~= 0
                            result(r,c) = image2(r,c);
                        end
                    end
                end
            end
        end
    end
    
    


end