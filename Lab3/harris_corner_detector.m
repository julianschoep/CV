function [ H, r, c ] = harris_corner_detector( image, k,sigma,n,thresh )
    % Convert image to gray scale
    %k = ceil(6*sigma + 1) % around three standard deviations from the mean
                          %  the kernel values are assumed zero.
    image = im2double(rgb2gray(image));
    % Sobel operator in x direction
    %Gx = [ 0.006 0.061 0.242 0.383 0.242 0.061 0.006 ]
    %Gy = [ 0.006 ;0.061; 0.242; 0.383 ;0.242; 0.061; 0.006 ]
    Gx = [1 0 -1 ; 2 0 -2 ; 1 0 -1];
    % Sobel operator in y direction
    Gy = [1 2 1 ; 0 0 0; -1 -2 -1];
    % Gaussian operator with kernel size k and st.dev. sigma.
    G = fspecial('gauss',k,sigma);
    % Image gradient in x direction.
    Ix = imfilter(image,Gx, 'replicate','same','conv');
    % Image gradient in y direction.
    Iy = imfilter(image,Gy, 'replicate','same','conv');
    
    A = imfilter(Ix.^2,G, 'replicate','same','conv');
    B = imfilter((Ix.*Iy),G, 'replicate','same','conv');
    C = imfilter(Iy.^2,G, 'replicate','same','conv');
    
    H = (A.*C-(B.^2))-0.04*(A+C).^2;
    figure(1);imshow(H);
    
    d = floor(n/2);
    % Pad H with d 0's.
    H_pad = padarray(H,[d d]);
    [h,w] = size(H_pad); 
    corners = [];
    
    % iterate all pixels (not the padding)
    for r = (d+1):h-d;
        for c = (d+1):w-d;
            % if threshold is exceeded
            if H_pad(r,c) > thresh;
                % iterate over nxn window
                is_max = true;
                disp("r");
                disp(r);
                for ri = r-d:r+d;
                    disp("ri");
                    disp(ri);
                    for ci = c-d:c+d;
                        
                        if H_pad(r,c) < H_pad(ri,ci);
                            is_max = false;
                        end
                    end
                end
                if is_max;
                    corners = cat(1,corners,[c-d,r-d]);
                end
            end
    
        end
    end
    r = corners(:,2);
    c = corners(:,1);
    %figure(1)
    subplot(1,3,1);imshow(Ix);title("Ix")
    subplot(1,3,2);imshow(Iy);title("Iy")
    subplot(1,3,3);imshow(image);title("Detected corners");
    suptitle(['\sigma: ', num2str(sigma), ', kernel size: ', num2str(k), ', max window size: ',num2str(n), ', threshold: ',num2str(thresh)])
    hold on; scatter(corners(:,1),corners(:,2),15,'red');
    hold off;
end

% Demo function to display Harris corner detector results.
function demo
    % Read in the two images
    pongIm  = imread('./pingpong/0000.jpeg')
    toyIm   = imread('./person_toy/00000001.jpg')
    % Usage of harris_corner_detector:
    %
    % harris_corner_detector(I, k,s,n,t)
    % Where:
    %       I : input image
    %       k : kernel size of gaussian
    %       s : Sigma of gaussian
    %       n : Kernel size of max window
    %       t : Threshold
    
    % Best ping pong image:
    harris_corner_detector(pongIm,5,5,5,0.1);
    % Best non-rotated toy image:
    harris_corner_detector(toyIm,3,7,9,0.02);
    
    % To rotate an image with a specified background we use 
    % script Imtool (source: https://tinyurl.com/y9uxa3ob)
    % Usage of imtool:
    %
    % imtool(I, theta, background_color)
    % Where I: image and theta: rotation
    
    % Rotated toy image with black background:
    harris_corner_detector(imtool(toyIm,-64,0),7,3,9,0.02);
    
    % Rotated toy image with gray background:
    harris_corner_detector(imtool(toyIm,-64,200),7,3,9,0.02);
   
end