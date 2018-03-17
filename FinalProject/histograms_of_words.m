function [histograms] = histograms_of_words(images, centroids, colorspace, feature_detector)
%
% Args:
%   images:           a cell array of N images
%   centroids:        the visual words - a V x F matrix, where V is the 
%                     vocabulary size and F is the dimensionality of the
%                     SIFT features (1x128 or 3x128)
%   colorspace:       "RGB", "rgb", "opponent"
%   feature_detector: "dense" or "keypoints"
%
% Return: an N x V matrix of image histograms. 

num_images = length(images);
vocab_size = size(centroids, 1);
histograms = zeros(num_images, vocab_size);

for i = 1:num_images
    
    % extract image from cell array
    im = im2single(cell2mat(images(i)));
    
    
    % Obtain K x F matrix of SIFT descriptors
    % where K = |keypoints|, F = 128 or 3x128
    
    % 3-channel image
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
        
    % 1-channel (grayscale) image
    elseif ndims(im) == 2
        descriptors = sift1d(im, feature_detector);
    end
    
    
    % Compute euclidean distance between descriptors and centroids
    distances = pdist2(double(descriptors), centroids);
    [~, winning_centroids] = min(distances, [], 2);
    
    centroid_hist = zeros(vocab_size, 1);
    
    % Add counts of visual words 
    for k = 1:length(winning_centroids)
        centroid_hist(winning_centroids(k)) = centroid_hist(winning_centroids(k)) + 1;
    end
    
    % the normalised histogram for image i
    histograms(i, :) = normc(centroid_hist);
    
end

end
