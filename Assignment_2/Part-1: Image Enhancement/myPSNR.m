function [ PSNR ] = myPSNR(orig_image, approx_image)

% Casting to double is essential
orig_image = double(orig_image);
approx_image = double(approx_image);

% Check input sizes
[m, n] = size(orig_image);
if size(approx_image) ~= [m, n]
    error('Original and corrupted image must have the same size.')
end

% Compute PSNR
sq_diff = (orig_image - approx_image) .^ 2;
MSE = sum(sq_diff(:)) / (m * n);
max_i = double(max(orig_image(:)));

PSNR = 20 * log10(max_i) - 10 * log10(MSE);
end

