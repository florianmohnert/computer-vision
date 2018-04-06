function [descriptors] = sift3d(im_gray, im, feature_detector)
%
% Returns a 3x128-dimensional SIFT descriptor for 3-channel images
% by concatenating the three single-channel descriptors (e.g. R, G, and B).
% 
% Args:
%   im:               a 3-channel image
%   im_gray:          the grayscale version of the image image
%   feature_detector: "keypoints" or "dense"
%
im = im2single(im);

if feature_detector == "keypoints"
    % get image features *once* from grayscale image
    [f, ~] = vl_sift(im_gray);
    
    % obtain descriptors for those image features
    [~, channel1_descriptors] = vl_sift(im(:,:,1), 'frames', f);
    [~, channel2_descriptors] = vl_sift(im(:,:,2), 'frames', f);
    [~, channel3_descriptors] = vl_sift(im(:,:,3), 'frames', f);
    
elseif feature_detector == "dense"
    [~, channel1_descriptors] = vl_dsift(im(:,:,1), 'step', 20);
    [~, channel2_descriptors] = vl_dsift(im(:,:,2), 'step', 20);
    [~, channel3_descriptors] = vl_dsift(im(:,:,3), 'step', 20);
end

descriptors = cat(1, channel1_descriptors, ...
                     channel2_descriptors, ...
                     channel3_descriptors  ...
                 );
descriptors = descriptors';

end