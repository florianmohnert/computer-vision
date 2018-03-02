function imOut = compute_LoG(im, LOG_type,varargin)


switch LOG_type
    case 1
        %method 1
        kernel = gauss2D(0.5,5);
        smoothed_image = imfilter(im,kernel);
        laplacian = fspecial('laplacian', 0.5);
        imOut = imfilter(smoothed_image,laplacian);
        
    case 2
        %method 2
        laplacian = fspecial('log', [5,5],0.5);
        imOut = imfilter(im,laplacian);
        

    case 3
        %method 3
        s1 = varargin{1};
        s2 = varargin{2};
        
        gauss_s1 = imgaussfilt(im, s1);
        gauss_s2 = imgaussfilt(im, s2);
        
        imOut = gauss_s1 - gauss_s2;

end
end

