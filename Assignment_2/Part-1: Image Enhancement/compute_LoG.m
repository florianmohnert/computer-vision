function imOut = compute_LoG(image, LOG_type,varargin)


switch LOG_type
    case 1
        %method 1
        kernel = gauss2D(0.5,5);
        smoothed_image = imfilter(image,kernel);
        laplacian = fspecial('laplacian', 0.5);
        imOut = imfilter(smoothed_image,laplacian);
        
    case 2
        %method 2
        laplacian = fspecial('log', [5,5],0.5);
        imOut = imfilter(image,laplacian);
        

    case 3
        %method 3
        s1 = varargin{1};
        s2 = varargin{2};

        hsize = [3,3];

        f1 = fspecial('gaussian', hsize, s1);
        f2 = fspecial('gaussian', hsize, s2);

        gauss_s1 = imfilter(image,f1);
        gauss_s2 = imfilter(image,f2);
            
        imOut = gauss_s1 - gauss_s2;

end
end

