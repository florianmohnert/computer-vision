clear all;
close all;

% frames = dir('pingpong');
frames = dir('person_toy');
n_frames = length(frames);

image1 = im2double(rgb2gray(imread(strcat(frames(3).folder, '/', frames(3).name))));
C = corner(imgaussfilt(image1, 2));

Vx = zeros(n_frames, length(C));
Vy = zeros(n_frames, length(C));
region_size = [15 15];

for frame = 3:n_frames
    
    f1_name = frames(frame).name;
    f2_name = frames(frame + 1).name;
    
    img1 = im2double(rgb2gray(imread(strcat(frames(frame).folder, '/', f1_name))));
    img2_rgb = imread(strcat(frames(frame).folder, '/', f2_name));
    img2 = im2double(rgb2gray(img2_rgb));
  
%     img1 = imresize(img1, 0.5);
%     img2 = imresize(img2, 0.5);
%     img2_rgb = imresize(img2_rgb, 0.5);

%     imshow(img1);
%     hold on
%     plot(C(:,1), C(:,2), 'r*');

    [h, w] = size(img1);
    
    
    for j = 1:length(C)
        C(j, :) = round(C(j, :) + [Vx(frame-1, j) Vy(frame-1, j)]);
    end
    
    for j = 1:length(C)
        corner_xy = C(j, :);
        c_x = corner_xy(1);
        c_y = corner_xy(2);

        span_rows = floor(region_size(1) / 2);
        span_cols = floor(region_size(2) / 2);

        rows = c_x - span_rows : c_x + span_rows;
        cols = c_y - span_cols : c_y + span_cols;

        rows(rows < 1) = 1;
        rows(rows > h) = h;
        cols(cols < 1) = 1;
        cols(cols > w) = w;

        region1 = img1(rows, cols);         
        region2 = img2(rows, cols);
        
        % compute image gradient in the x and y direction
        [Ix, Iy] = imgradientxy(region1, 'intermediate');

        % partial derivative of the image with respect to time
%         It = imgaussfilt(region2, 2) - imgaussfilt(region1, 2); 
        It = region2 - region1;

        % solve for v = inv(A' * A) * A' * b
        A = [Ix(:) Iy(:)]; 
        b = -It(:); 
        v = pinv(A) * b;  % pinv(A) = inv(A' * A) * A'
        
        scale = 5;
        threshold = 0.4;
        
        if abs(v(1)) > threshold
            Vx(frame, j) = scale * v(1);
        else
            Vx(frame, j) = 0;
        end
        
        if abs(v(2)) > threshold
            Vy(frame, j) = scale * v(2);
        else
            Vy(frame, j) = 0;
        end
    end

    % plot optical flow 
    figure();
    imshow(img2_rgb);
    hold on;
    quiver(C(:, 1), C(:, 2), Vx(frame-1, :)', Vy(frame-1, :)', 'y')
end
