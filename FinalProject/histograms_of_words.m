function [histograms] = histograms_of_words(images, centroids, colorspace, feature_detector)

num_images = length(images);
vocab_size = size(centroids, 1);

histograms = zeros(num_images, vocab_size);

for i = 1:num_images
    
    im = im2single(cell2mat(images(i)));
    
    if ndims(im) == 3
        if (colorspace == 'RGB')
            descriptors = sift3d(im, feature_detector);
        elseif (colorspace == 'rgb')
            im = RGB2rgb(im);
            descriptors = sift3d(im, feature_detector);
        elseif (colorspace == 'opponent')
            im = rgb2opponent(im);
            descriptors = sift3d(im, feature_detector);
        end
        
    elseif ndims(im) == 2
        descriptors = sift1d(im, feature_detector);
    end
    
    centroid_hist = zeros(vocab_size, 1);
    
    for descr_idx = 1:size(descriptors, 1)
        max_distance = 0;
        centroid = 0;
        
        for centroid_idx = 1:vocab_size
            
            % Euclidean distance
%             V = double(descriptors(descr_idx) - centroids(centroid_idx));
%             dist = sqrt(V * V');
            
            dist = pdist2(descriptors(descr_idx), centroids(centroid_idx));
            
            if dist > max_distance
                max_distance = dist;
                centroid = centroid_idx;
            end
              
        end
        centroid_hist(centroid) = centroid_hist(centroid) + 1;
        
    end
    
    histograms(i, :) = normc(centroid_hist);
    
end

end