function [descriptors] = sift1d(im, feature_detector)

if feature_detector == "dense"
    [~, descriptor] = vl_dsift(im, 'step', 20);
    descriptors = cat(1, descriptor, descriptor, descriptor);
else
    [~, descriptor] = vl_sift(im);
    descriptors = cat(1, descriptor, descriptor, descriptor);
end

descriptors = descriptors';
end