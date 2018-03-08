clear all;
close all;

% frames = dir('pingpong');
frames = dir('person_toy');
n_frames = length(frames);

levels = 3;

image1 = im2double(rgb2gray(imread(strcat(frames(3).folder, '/', frames(3).name))));
    
for level = 1: levels
    image1 = impyramid(image1, 'reduce');
end

C = corner(imgaussfilt(image1, 2));

Vx = zeros(levels, length(C));
Vy = zeros(levels, length(C));
region_size = [15 15];

for frame = 3:n_frames
    
    f1_name = frames(frame).name;
    f2_name = frames(frame + 1).name;
    
    img1 = im2double(rgb2gray(imread(strcat(frames(frame).folder, '/', f1_name))));
    img2_rgb = imread(strcat(frames(frame).folder, '/', f2_name));
    img2 = im2double(rgb2gray(img2_rgb));
  
    [h, w] = size(img1);
    
    
    
    img1_pyramid{1}(:,:) = img1;
    img2_pyramid{1}(:,:) = img2;
    
    for level = 2: levels
        img1_pyramid{level}(:,:) = impyramid(img1_pyramid{level-1}(:,:), 'reduce');
        img2_pyramid{level}(:,:) = impyramid(img2_pyramid{level-1}(:,:), 'reduce');
    end

        
%     imshow(img1);
%     hold on
%     plot(C(:,1), C(:,2), 'r*');

    for level = levels: -1 : 1
    
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

            region1 = img1_pyramid{level}(rows, cols);         
            region2 = img2_pyramid{level}(rows, cols);

            % compute image gradient in the x and y direction
            [Ix, Iy] = imgradientxy(region1, 'intermediate');

            % partial derivative of the image with respect to time
    %         It = imgaussfilt(region2, 2) - imgaussfilt(region1, 2); 
            It = region2 - region1;

            % solve for v = inv(A' * A) * A' * b
            A = [Ix(:) Iy(:)]; 
            b = -It(:); 
            v = pinv(A) * b;  % pinv(A) = inv(A' * A) * A'

            Vx(level, j) = v(1);
            Vy(level, j) = v(2);
            
            if level > 1
                exp = 1;
                for l = level:levels
                    Vx(level-1, j) = Vx(level-1, j) + 2^exp * Vx(l, j);
                    Vy(level-1, j) = Vy(level-1, j) + 2^exp * Vy(l, j);
                    exp = exp + 1;
                end
            end
        end
        
        if level > 1 
            C = C + round([Vx(level-1, :)' Vy(level-1, :)']);
        end
        
    end

    % plot optical flow 
    figure();
    imshow(img2_rgb);
    hold on;
    quiver(C(:, 1), C(:, 2), Vx(levels, :)', Vy(levels, :)', 'y')
end
