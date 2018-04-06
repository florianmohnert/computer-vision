function [histograms] = histograms_of_words(images, centroids, colorspace, feature_detector)
%
% Args:
%   images:           a cell array of N images
%   centroids:        the visual words - a V x 384 matrix, where V is the 
%                     vocabulary size and 384 (= 3*128) is the 
%                     dimensionality of the SIFT features
%   colorspace:       "RGB", "rgb", or "opponent"
%   feature_detector: "dense" or "keypoints"
%
% Return: an N x V matrix of image histograms. 

num_images = length(images);
vocab_size = size(centroids, 1);
histograms = zeros(num_images, vocab_size);

for i = 1:num_images
    
    % extract image from cell array
    im = im2single(cell2mat(images(i)));
    
    % Obtain K x 384 matrix of SIFT descriptors where K = |keypoints|
    
    % 3-channel image
    if ndims(im) == 3
        im_gray = rgb2gray(im);
        
        if (colorspace == "RGB")
            descriptors = sift3d(im_gray, im, feature_detector);
        elseif (colorspace == "rgb")
            im = RGB2rgb(im);
            im(isnan(im)) = 0;
            descriptors = sift3d(im_gray, im, feature_detector);
        elseif (colorspace == "opponent")
            im = rgb2opponent(im);
            descriptors = sift3d(im_gray, im, feature_detector);
        end
        
    % 1-channel (grayscale) image
    elseif ndims(im) == 2
        descriptors = sift1d(im, feature_detector);
    end
        
    % Compute matrix of euclidean distances between descriptors and centroids
    distances = pdist2(normr(double(descriptors)), centroids);
    
    % get the indices of the winning centroids
    [~, winning_centroids] = min(distances, [], 2);
    
    centroid_hist = zeros(vocab_size, 1);
    
    % Add counts of visual words 
    for k = 1:length(winning_centroids)
        centroid_hist(winning_centroids(k), :) = centroid_hist(winning_centroids(k), :) + 1;
    end
    
    % the normalised histogram for image i
    histograms(i, :) = normc(centroid_hist);  
end

end
