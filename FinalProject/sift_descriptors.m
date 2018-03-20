
function [descriptors_all] = sift_descriptors(images, colorspace, feature_detector)
%%%%%%%%%%%%%
% images:           cell of images
% colorspace:       "RGB", "rgb", or "opponent"
% feature_detector: "dense" or "keypoints"
%%%%%%%%%%%%%

descriptors_all = [];

for i = 1:length(images)
    
    % extract image from cell array
    im = im2single(cell2mat(images(i)));
    
    if ndims(im) == 2
        descriptors = sift1d(im, feature_detector);
    
    else    
        im_gray = rgb2gray(im);
        
        if (colorspace == "RGB")
            descriptors = sift3d(im_gray, im, feature_detector);
            
        elseif (colorspace == "rgb")
            im = RGB2rgb(im);
            descriptors = sift3d(im_gray, im, feature_detector);
            
        elseif (colorspace == "opponent")
            im = rgb2opponent(im);
            descriptors = sift3d(im_gray, im, feature_detector);
        end
        
        descriptors_all = cat(1, descriptors_all, descriptors);
        
    end
    
end


