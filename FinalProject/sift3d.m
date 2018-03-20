function [descriptors] = sift3d(im, feature_detector)

[f, ~] = vl_sift(rgb2gray(im));

channel1_descriptors = [];
channel2_descriptors = [];
channel3_descriptors = [];

for k = 1:size(f, 2)
    feat = f(:,k);
    
    if feature_detector == "keypoints"
        [f1, channel1_descriptors_point] = vl_sift(im(:,:,1), 'frames', feat);
        [f2, channel2_descriptors_point] = vl_sift(im(:,:,2), 'frames', feat);
        [f3, channel3_descriptors_point] = vl_sift(im(:,:,3), 'frames', feat);
        
    elseif feature_detector == "dense"
        [f1, channel1_descriptors_point] = vl_dsift(im(:,:,1), 'frames', feat, 'step', 10);
        [f2, channel2_descriptors_point] = vl_dsift(im(:,:,2), 'frames', feat, 'step', 10);
        [f3, channel3_descriptors_point] = vl_dsift(im(:,:,3), 'frames', feat, 'step', 10);   
    end
    
    channel1_descriptors = cat(1, channel1_descriptors, channel1_descriptors_point');
    channel2_descriptors = cat(1, channel2_descriptors, channel2_descriptors_point');
    channel3_descriptors = cat(1, channel3_descriptors, channel3_descriptors_point');    
end

descriptors = cat(1, channel1_descriptors', ...
                     channel2_descriptors', ...
                     channel3_descriptors'  ...
                 )';

end