function [descriptors] = sift1d(im, feature_detector)
%
% Returns a 3x128-dimensional SIFT descriptor for grayscale images
% by concatenating the 1-channel descriptor thrice.
% 
% Args:
%   im:               a grayscale image
%   feature_detector: "keypoints" or "dense"
%
if feature_detector == "dense"
    [~, descriptor] = vl_dsift(im, 'step', 20);
    descriptors = cat(1, descriptor, descriptor, descriptor);
else
    [~, descriptor] = vl_sift(im);
    descriptors = cat(1, descriptor, descriptor, descriptor);
end

descriptors = descriptors';
end