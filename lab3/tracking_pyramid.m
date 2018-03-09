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

[H,r,c] = harris_corner_detector(im,100000,11);
C = zeros(length(r),2);
C(:,1) = c;
C(:,2) = r;

Vx = zeros(levels, length(C));
Vy = zeros(levels, length(C));
region_size = [15 15];

for frame = 3:n_frames-1
    
    f1_name = frames(frame).name;
    f2_name = frames(frame + 1).name;
      
    img1_rgb = imread(strcat(frames(frame).folder, '/', f1_name));
    img1 = im2double(rgb2gray(img1_rgb));
    img2 = im2double(rgb2gray(imread(strcat(frames(frame).folder, '/', f2_name))));
  
    img1 = imgaussfilt(img1, 1);
    img2 = imgaussfilt(img2, 1);
  
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
        
        [V_x, V_y] = lucas_kanade(strcat(frames(frame).folder, '/', f1_name), strcat(frames(frame).folder, '/', f2_name), region_size, 0);
        
        for j = 1:length(C)
            corner_xy = C(j, :);
            c_x = corner_xy(1);
            c_y = corner_xy(2);

            region_row = ceil(c_y / region_size);
            region_col = ceil(c_x / region_size);

            if region_row < 1              region_row = 1;              end %#ok<*SEPEX>
            if region_row > size(V_x, 1)   region_row = size(V_x, 1);   end
            if region_col < 1              region_col = 1;              end
            if region_col > size(V_x, 2)   region_row = size(V_x, 2);   end

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
