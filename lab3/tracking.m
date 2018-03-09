function [] = tracking(dir_path, harris_k, harris_sigma, region_size, scale, make_frames)

frames = dir(dir_path);
n_frames = length(frames);
image1 = im2double(rgb2gray(imread(strcat(frames(3).folder, '/', frames(3).name))));
im = imread(strcat(frames(3).folder, '/', frames(3).name));

[H,r,c] = harris_corner_detector(im, harris_k, harris_sigma);
C = zeros(length(r),2);
C(:,1) = c;
C(:,2) = r;

Vx = zeros(n_frames, length(C));
Vy = zeros(n_frames, length(C));

for frame = 3:n_frames-1
    
    f1_name = frames(frame).name;
    f2_name = frames(frame + 1).name;
      
    img1_rgb = imread(strcat(frames(frame).folder, '/', f1_name));
    img1 = im2double(rgb2gray(img1_rgb));
    img2 = im2double(rgb2gray(imread(strcat(frames(frame).folder, '/', f2_name))));
  
    img1 = imgaussfilt(img1, 1);
    img2 = imgaussfilt(img2, 1);
    
%     imshow(img1);
%     hold on
%     plot(C(:,1), C(:,2), 'r*');

    [h, w] = size(img1);
    
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

        
        Vx(frame, :) = V_x(region_row, region_col);
        Vy(frame, :) = V_y(region_row, region_col);
        
    end

    % plot optical flow 
    fig = figure();
    imshow(img1_rgb);
    hold on;
    quiver(C(:, 1), C(:, 2), Vx(frame, :)', Vy(frame, :)', 'y')
    
    C = C + round( scale * [Vx(frame, j)' Vy(frame, j)'] );
    
    if make_frames
        folder = 'video_frames';
        baseFileName = sprintf('%d.jpg', frame);
        fullFileName = fullfile(folder, baseFileName);
        saveas(fig,fullFileName, 'jpeg');
    end
end

end