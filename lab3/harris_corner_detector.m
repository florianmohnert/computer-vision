function [H,r,c,corner_matrix,A] = harris_corner_detector(img, threshold, max_region, plot)

% args:
% img: image
% threshold: threshold of cornerness (experimentally at 10000)
% max_region: region to check if point is local maximum

% gray scale and double
im = double(rgb2gray(img));
% smoothing the image first
im = imgaussfilt(im,2.5);

% getting image derivatives
sobel_x = fspecial('sobel') ;
sobel_y = sobel_x' ;
derivative_x = imfilter(im,sobel_x,'replicate');
derivative_y = imfilter(im,sobel_y,'replicate');

% A,B and C according to equation 9
A = imgaussfilt(derivative_x .^ 2,2) ;
B = imgaussfilt(derivative_x .* derivative_y,2) ;
C = imgaussfilt(derivative_y .^ 2,2) ;

% cornerness matrix
H = (A .* C) - B .^2 - 0.04 .* (A + C) .^ 2; 

% checking local maxima and threshold assumption
max_matrix = ordfilt2(H, max_region ^ 2, ones(max_region));
corner_matrix = (max_matrix == H) & H > threshold; 

% plotting corners
[r,c] = find(corner_matrix==1);

if plot
    % plotting derivatives
    figure(1)
    subplot(1,3,1)
    plot1 = imshow(derivative_x);
    title('derivative x');
    subplot(1,3,2)
    plot2 = imshow(derivative_y);
    title('derivative y');

    subplot(1,3,3)
    plot3 = imshow(img);
    title('corners')
    hold on;
    plot(c,r, 'r+', 'MarkerSize', 10, 'LineWidth', 1);
end
end

