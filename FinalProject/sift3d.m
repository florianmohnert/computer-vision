function[descriptors] = sift3d(im,feature_detector)

[f,d] = vl_sift(rgb2gray(im));



if feature_detector == "keypoints"
    
    [f1,channel1_descriptors] = vl_sift(im(:,:,1));
    [f2,channel2_descriptors] = vl_sift(im(:,:,2));
    [f3,channel3_descriptors] = vl_sift(im(:,:,3));
    size(channel1_descriptors)
    size(channel2_descriptors)
    size(channel3_descriptors)
else
    [f1,channel1_descriptors] = vl_dsift(im(:,:,1));
    [f2,channel2_descriptors] = vl_dsift(im(:,:,2));
    [f3,channel3_descriptors] = vl_dsift(im(:,:,3));
    
end

descriptors = cat(1,channel1_descriptors',channel2_descriptors',channel3_descriptors');

    


end