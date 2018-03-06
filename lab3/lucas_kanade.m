function [Vx, Vy] = lucas_kanade(image_pair)

assert( image_pair == "sphere" | image_pair == "synth");

if image_pair == "sphere"
    img1 = im2double(rgb2gray(imread('sphere1.ppm')));
    frame2 = imread('sphere2.ppm');
    img2 = im2double(rgb2gray(frame2));
else
    img1 = im2double(imread('synth1.pgm'));
    frame2 = imread('synth2.pgm');
    img2 = im2double(frame2);
end

assert( all(size(img1) == size(img2)), "The two images must have the same size.")
[h, w] = size(img1);


% Divide input images into non-overlapping regions of size 15x15
region_size = [15 15];
n_rows = floor(h / region_size(1));
n_cols = floor(w / region_size(2));

row_sizes = [region_size(1) * ones(1, n_rows), rem(h, region_size(1))];
col_sizes = [region_size(2) * ones(1, n_cols), rem(w, region_size(2))];

regions_1 = mat2cell(img1, row_sizes, col_sizes, 1);
regions_2 = mat2cell(img2, row_sizes, col_sizes, 1);


% These contain the optical flow (Vx, Vy) of each region 
Vx = zeros(size(regions_1));
Vy = zeros(size(regions_1));

for j = 1:length(regions_1)
    for k = 1:length(regions_1)
        region1 = cell2mat(regions_1(j, k));
        region2 = cell2mat(regions_2(j, k));
        
        % compute image gradient in the x and y direction
        [Ix, Iy] = imgradientxy(region1, 'sobel');
        
        % partial derivative of the image with respect to time
        It = double(conv2(region1, ones(2), 'same')) - double(conv2(region2, ones(2), 'same')); 
        
        % solve for v = inv(A' * A) * A' * b
        A = [Ix(:) Iy(:)]; 
        b = It(:); 
        v = pinv(A) * b;  % pinv(A) = inv(A' * A) * A'
        
        Vx(j, k) = v(1);
        Vy(j, k) = v(2);
    end
end

% position flow vectors at the center of their respective cells
start = ceil(region_size(1) / 2);
offset = start + 1;

% get coordinates for u and v in the original frame
[X, Y] = meshgrid(8 : h+offset,  8 : w+offset);
X = X(1 : region_size(1) : end,  1 : region_size(1) : end);
Y = Y(1 : region_size(2) : end,  1 : region_size(2) : end);

% plot optical flow 
figure();
imshow(frame2);
hold on;
quiver(X, Y, Vx, Vy, 'y')

end