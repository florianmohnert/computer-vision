function [Gx, Gy, im_magnitude, im_direction] = compute_gradient_(image, k)

i = double(image);
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];

Gx = imfilter(i, sobel_x);
Gy = imfilter(i, sobel_y);

im_magnitude = sqrt(Gx .^ 2 + Gy .^ 2);
im_direction = atan(Gy ./ Gx);

threshold = im_magnitude < k;
im_magnitude(threshold) = 0;

end
