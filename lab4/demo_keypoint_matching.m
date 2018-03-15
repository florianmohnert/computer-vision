%
% Matching salient points in two images.
%

im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

% matches is a list of unique feature indexes
% coordinates can then be found in f1 and f2
[matches, f1, f2] = keypoint_matching(im1, im2, true);
