function [Gx, Gy, im_magnitude, im_direction] = compute_gradient(image)

i = double(image);
sobel_x = [1 0 -1; 2 0 -2; 1 0 -1];
sobel_y = [1 2 1; 0 0 0; -1 -2 -1];

Gx = imfilter(i, sobel_x);
Gy = imfilter(i, sobel_y);

im_magnitude = sqrt(Gx .^ 2 + Gy .^ 2);

% atan(y/x) is held back some information and can only assume that the
% input came from quadrants I or IV. In contrast, atan2(y,x) gets all 
% the data and thus can resolve the correct angle.

% im_direction = atan(Gy ./ Gx);
im_direction = atan2(Gy, Gx);

end

