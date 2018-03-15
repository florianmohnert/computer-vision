function [stitched] = stitch(im1, im2)
%
% Takes an image pair as input, and returns the stitched version.
%
if ndims(im1) == 3
    im1_rgb = im1;
    im1 = rgb2gray(im1);
end

if ndims(im2) == 3
    im2_rgb = im2;
    im2 = rgb2gray(im2);
end

[best_model, best_model_score, transformed_im2, new_coords] = RANSAC(im1, im2, 10, 50);

[h, w] = size(im1);
new_coords = new_coords(:, :, :) + reshape([h w], [1,1,2]);
        
for x = 1:size(im2, 1)
    for y = 1:size(im2, 2)
        im2_(new_coords(x, y, 1), new_coords(x, y, 2), :) = im2_rgb(x, y, :); 
    end
end

stitched = imfuse(im1_rgb, im2_, 'blend');

end