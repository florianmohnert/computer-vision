clear all;

% frames = dir('pingpong');
frames = dir('person_toy');
    
for frame = 3:length(frames)
    
    f1_name = frames(frame).name;
    f2_name = frames(frame + 1).name;
    
    img1 = im2double(rgb2gray(imread(strcat(frames(frame).folder, '/', f1_name))));
    img2_rgb = imread(strcat(frames(frame).folder, '/', f2_name));
    img2 = im2double(rgb2gray(img2_rgb));
  
    
    C = corner(imgaussfilt(img1, 2));

%     imshow(img1);
%     hold on
%     plot(C(:,1), C(:,2), 'r*');

    assert( all(size(img1) == size(img2)), "The two images must have the same size.")
    [h, w] = size(img1);

    % Divide input images into non-overlapping regions of size 15x15
    region_size = [3 3];

    % These contain the optical flow (Vx, Vy) of each region 
    Vx = zeros(length(C), 1);
    Vy = zeros(length(C), 1);

    for j = 1:length(C)
        corner_xy = C(j, :);
        c_x = corner_xy(1);
        c_y = corner_xy(2);

        span_rows = floor(region_size(1) / 2);
        span_cols = floor(region_size(2) / 2);

        rows = c_x - span_rows : c_x + span_rows;
        cols = c_y - span_cols : c_y + span_cols;

        rows(rows < 1 | rows > h) = [];
        cols(cols < 1 | cols > w) = [];

        region1 = img1(rows, cols);

        % TODO: displace based on direction of flow
        region2 = img2(round(rows + Vx(j)), round(cols + Vy(j)));

        % compute image gradient in the x and y direction
        [Ix, Iy] = imgradientxy(region1, 'sobel');

        % partial derivative of the image with respect to time
        It = double(conv2(region1, ones(2), 'same')) - double(conv2(region2, ones(2), 'same')); 

        % solve for v = inv(A' * A) * A' * b
        A = [Ix(:) Iy(:)]; 
        b = It(:); 
        v = pinv(A) * b;  % pinv(A) = inv(A' * A) * A'

        Vx(j) = v(1);
        Vy(j) = v(2);
    end

    % plot optical flow 
    figure();
    imshow(img2_rgb);
    hold on;
    quiver(C(:, 1), C(:, 2), Vx, Vy, 'y')
end
