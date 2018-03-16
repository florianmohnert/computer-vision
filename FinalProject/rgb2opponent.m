function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
[m,n,k] = size(input_image);

output_image = zeros(m,n,k);

R = input_image(:,:,1);
G = input_image(:,:,2);
B = input_image(:,:,3);

output_image(:,:,1) = double((R-G)) ./ double(sqrt(2));
output_image(:,:,2) = double(R+G-2*B) ./ double(sqrt(6));
output_image(:,:,3) = double(R+G+B) ./ double(sqrt(3));


end

