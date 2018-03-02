function [ imOut ] = denoise( image, kernel_type, varargin)

filter_size = varargin{1};


switch kernel_type
    case 'box'
        imOut = imboxfilt(image,filter_size);
    case 'median'
        imOut = medfilt2(image,[filter_size,filter_size]);
    case 'gaussian'
        sigma =  varargin{2};
        kernel = gauss2D(sigma, filter_size);
        imOut = imfilter(image, kernel);
        
end
end
