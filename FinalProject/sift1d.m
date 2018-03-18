function[descriptors] = sift1d(im,feature_detector)

if feature_detector == "keypoints" 
[f1,descriptor] = vl_sift(im);

descriptors = cat(1, descriptor', ...
                     descriptor', ...
                     descriptor'  ...
                 );
end

end