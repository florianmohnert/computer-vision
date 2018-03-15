function [matches, f1, f2] = keypoint_matching(im1, im2, visualise)
%
% Return the keypoint matchings between two images.
%
% Args:
%   visualise - 'true' to plot the images with 50 randomly sampled correspondences
%

if ndims(im1) == 3
    im1 = rgb2gray(im1);
end

if ndims(im2) == 3
    im2 = rgb2gray(im2);
end

im1 = single(im1) ;
im2 = single(im2) ;

% Find salient points (features) and get SIFT descriptors for those
[f1, d1] = vl_sift(im1);
[f2, d2] = vl_sift(im2);

% Find correspondences between features
[matches, scores] = vl_ubcmatch(d1, d2);  % matches returns indexes of points, coordinates can then be found in f1 and f2
[~, num_matches] = size(matches);

if visualise
    figure(1)
    imshowpair(im1, im2, 'montage')
    hold on
    rand_matches = randperm(num_matches,num_matches);

    % Take a random subset of putative matches of size 50.
    % Plot the images and connect correspondences.
    for i = 1:50

        match = matches(:, rand_matches(i));

        % features vecs for both points
        im1_feat = f1(: , match(1));
        im2_feat = f2(: , match(2));

        % coordinates
        im1_feat_x = im1_feat(1);
        im1_feat_y = im1_feat(2);

        im2_feat_x = im2_feat(1) + size(im1, 2);
        im2_feat_y = im2_feat(2);

        plot1 = plot([im2_feat_x, im1_feat_x], [im2_feat_y, im1_feat_y]);
        set(plot1, 'LineWidth', 2);
    end
end

end