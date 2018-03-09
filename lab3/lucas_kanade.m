function [Vx, Vy] = lucas_kanade(img_path1, img_path2, window_size, sigma, visualise)
%
% params:
%   img_path1, img_path2
%   window_size - the image is divided in square regions of this size 
%   sigma - the stdev of the gaussian smoothing filter (0 -> no smoothing)
%   visualise - 'true' to show images with optical flow vectors


frame1 = imread(img_path1);
frame2 = imread(img_path2);

assert(all(size(frame1) == size(frame2)), "The two images must have the same size.");

if size(frame1, 3) == 3
    img1 = im2double(rgb2gray(frame1));
    img2 = im2double(rgb2gray(frame2));
else
    img1 = im2double(frame1);
    img2 = im2double(frame2);
end

[h, w] = size(img1);


% Divide input images into non-overlapping regions of size 15x15
region_size = [window_size window_size];
n_rows = floor(h / region_size(1));
n_cols = floor(w / region_size(2));

row_sizes = [region_size(1) * ones(1, n_rows), rem(h, region_size(1))];
col_sizes = [region_size(2) * ones(1, n_cols), rem(w, region_size(2))];

regions_1 = mat2cell(img1, row_sizes, col_sizes, 1);
regions_2 = mat2cell(img2, row_sizes, col_sizes, 1);


% These contain the optical flow (Vx, Vy) of each region 
Vx = zeros(size(regions_1));
Vy = zeros(size(regions_1));

for j = 1:size(regions_1, 1)
    for k = 1:size(regions_1, 2)
        region1 = cell2mat(regions_1(j, k));
        region2 = cell2mat(regions_2(j, k));
        
        % compute image gradient in the x and y direction
        [Ix, Iy] = imgradientxy(region1, 'sobel');
        
        % partial derivative of the image with respect to time
        if sigma == 0
            It = region2 - region1;
        else
            It = imgaussfilt(region2, sigma) - imgaussfilt(region1, sigma);
        end
        
        % solve for v = inv(A' * A) * A' * b
        A = [Ix(:) Iy(:)]; 
        b = -It(:); 
        v = pinv(A) * b;  % pinv(A) = inv(A' * A) * A'
        
        Vx(j, k) = v(1);
        Vy(j, k) = v(2);
    end
end

% position flow vectors at the center of their respective cells
start = ceil(region_size(1) / 2);
offset = start + 1;

% get coordinates for u and v in the original frame
[X, Y] = meshgrid(start : w+offset,  start : h+offset);
X = X(1 : region_size(1) : end,  1 : region_size(1) : end);
Y = Y(1 : region_size(2) : end,  1 : region_size(2) : end);

% plot optical flow 
if visualise
    figure();
    imshow(frame2);
    hold on;
    quiver(X, Y, Vx, Vy, 'y')
end

end