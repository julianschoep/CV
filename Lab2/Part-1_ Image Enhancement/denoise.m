function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'Box'
        imOut = imboxfilt(image, varargin{1}, "Padding", "symmetric"); %
    case 'Median'
        imOut = medfilt2(image, [varargin{1}, varargin{1}], "symmetric"); % Symmetric padding for better edge cases.
    case 'Gaussian'
        imOut = imfilter(image, gauss2D(varargin{2}, varargin{1}), "symmetric"); % Symmetric padding for better edge cases.
end
end
