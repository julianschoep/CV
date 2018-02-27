function [ imOut ] = denoise( image, kernel_type, varargin)

switch kernel_type
    case 'Box'
        imOut = imboxfilt(image, varargin{1});
    case 'Median'
        imOut = medfilt2(image, [varargin{1}, varargin{1}]);
    case 'Gaussian'
        imOut = imfilter(image, gauss2D(varargin{2}, varargin{1}));
end
end
