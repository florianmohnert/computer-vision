function [descriptors_all] = sift_descriptors(images, colorspace, feature_detector)
%
% Returns a n x 384 matrix, where n is the number of images and 384=3*128.
%
% Args:
%   images:           a cell of images
%   colorspace:       "RGB", "rgb", or "opponent"
%   feature_detector: "dense" or "keypoints"
%
descriptors_all = [];

for i = 1:length(images)
    
    % extract image from cell array
    im = im2single(cell2mat(images(i)));
    
    % if grayscale
    if ndims(im) == 2
        descriptors = sift1d(im, feature_detector);
        
    % if 3-channel
    else    
        im_gray = rgb2gray(im);
        
        if (colorspace == "RGB")
            descriptors = sift3d(im_gray, im, feature_detector);
            
        elseif (colorspace == "rgb")
            im = RGB2rgb(im);
            im(isnan(im)) = 0;
            descriptors = sift3d(im_gray, im, feature_detector);
            
        elseif (colorspace == "opponent")
            im = rgb2opponent(im);
            descriptors = sift3d(im_gray, im, feature_detector);
        end
        
        descriptors_all = cat(1, descriptors_all, descriptors);
    end
   
end


