%
% Sticthing two images together based on RANSAC output.
%

im1 = imread('left.jpg');
im2 = imread('right.jpg');

stitched = stitch(im1, im2);

figure(1);
imshow(stitched);