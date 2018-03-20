function [descriptors] = sift3d(im_gray,im, feature_detector)

[f, ~] = vl_sift(im_gray);
im = im2single(im);

if feature_detector == "keypoints"
    [~, channel1_descriptors] = vl_sift(im(:,:,1), 'frames', f);
    [~, channel2_descriptors] = vl_sift(im(:,:,2), 'frames', f);
    [~, channel3_descriptors] = vl_sift(im(:,:,3), 'frames', f);
    
elseif feature_detector == "dense"
    [~, channel1_descriptors] = vl_dsift(im(:,:,1), 'step', 10);
    [~, channel2_descriptors] = vl_dsift(im(:,:,2), 'step', 10);
    [~, channel3_descriptors] = vl_dsift(im(:,:,3), 'step', 10);
end



descriptors = cat(1, channel1_descriptors', ...
    channel2_descriptors', ...
    channel3_descriptors'  ...
    );

end