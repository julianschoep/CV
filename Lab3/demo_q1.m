function demo_q1
    
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