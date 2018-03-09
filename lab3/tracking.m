function [Vx, Vy] = tracking(dir_path, harris_threshold, harris_k, kanade_sigma, region_size, scale, thresholds, make_frames)
%
% params:
%   dir_path
%   harris_threshold - cornerness threshold in the Harris corner detector
%   harris_k - neighborhood size in the Harris corner detector to check if 
%        a point is a local maximum 
%   kanade_sigma - stdev of Gaussian smoothing filter used before taking 
%       temporal partial derivatives. (sigma = 0 -> no smoothing)
%   region_size - the region size in Lukas-Kanade
%   scale - scaling factor for flow vectors
%   thresholds - [threshold_x threshold_y] for flow vectors
%   make_frames - 'true' to save output images to folder

frames = dir(dir_path);
n_frames = length(frames);
im = imread(strcat(frames(3).folder, '/', frames(3).name));

[H,r,c] = harris_corner_detector(im, harris_threshold, harris_k, false);
C = zeros(length(r), 2);
C(:,1) = c;
C(:,2) = r;

Vx = zeros(n_frames, length(C));
Vy = zeros(n_frames, length(C));

if make_frames
    system('rm -rf video_frames/*');
end

for frame = 3:n_frames-1
    
    f1_name = strcat(frames(frame).folder, '/', frames(frame).name);
    f2_name = strcat(frames(frame).folder, '/', frames(frame + 1).name);
      
    img1_rgb = imread(f1_name);
    img1 = im2double(rgb2gray(img1_rgb));
    img2 = im2double(rgb2gray(imread(f2_name)));
  
    img1 = imgaussfilt(img1, 1);
    img2 = imgaussfilt(img2, 1);

    [h, w] = size(img1);
    
    [V_x, V_y] = lucas_kanade(f1_name, f2_name, region_size, kanade_sigma, false);
 
    for j = 1:length(C)
        corner_xy = C(j, :);
        c_x = corner_xy(1);
        c_y = corner_xy(2);
        
        region_row = ceil(c_y / region_size);
        region_col = ceil(c_x / region_size);
        
        if region_row < 1              region_row = 1;              end %#ok<*SEPEX>
        if region_row > size(V_x, 1)   region_row = size(V_x, 1);   end
        if region_col < 1              region_col = 1;              end
        if region_col > size(V_x, 2)   region_col = size(V_x, 2);   end
        
        Vx(frame, j) = V_x(region_row, region_col);
        Vy(frame, j) = V_y(region_row, region_col);
        
    end

    % plot optical flow 
    fig = figure();
    imshow(img1_rgb);
    hold on;
    quiver(C(:, 1), C(:, 2), Vx(frame, :)', Vy(frame, :)', 'y')

    for j = 1:length(C)
        if abs(Vx(frame, j)) > thresholds(1)
            C(j, :) = C(j, :) + round(scale * [Vx(frame, j) 0]);
        else
            C(j, :) = C(j, :) + round([Vx(frame, j) 0]);
        end
        
        if abs(Vy(frame, j)) > thresholds(2)
            C(j, :) = C(j, :) + round(scale * [0 Vy(frame, j)]);
        else
            C(j, :) = C(j, :) + round([0 Vy(frame, j)]);
        end          
    end
    
    if make_frames
        folder = 'video_frames';
        baseFileName = sprintf('%d.jpg', frame);
        fullFileName = fullfile(folder, baseFileName);
        saveas(fig, fullFileName, 'jpeg');
    end
end

end