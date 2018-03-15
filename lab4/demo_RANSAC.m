%
% Finding and showing affine transformation between a pair of images.

clearvars;
im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

subplot(2,2,1);
sub1 = imshow(im1);
title('Boat 1');

[~, ~, transformed_im, ~] = RANSAC(im1, im2, 6, 50);
subplot(2,2,2);
sub2 = imshow(transformed_im);
title("Image 2 to image 1.");

subplot(2,2,3);
sub3 = imshow(im2);
title('Boat 2');

[~, ~, transformed_im, ~] = RANSAC(im2, im1, 6, 50);
subplot(2,2,4);
sub4 = imshow(transformed_im);
title("Image 1 to image 2.");
