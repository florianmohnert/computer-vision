close all
clear all
clc
 
disp('Part 1: Photometric Stereo')

% obtain many images in a fixed view under different illumination
disp('Loading images...')
% image_dir = 'photometrics_images/SphereGray5/'; 
image_dir = 'photometrics_images/SphereGray25/'; 
% image_dir = 'photometrics_images/MonkeyGray/'; 
% image_dir = 'photometrics_images/SphereColor/';
% image_dir = 'photometrics_images/MonkeyColor/';
%image_ext = '*.png';

% 2nd argument is either 1: gray-scale or 3: rgb
[image_stack, scriptV] = load_syn_images(image_dir, 1);

if ndims(image_stack) == 3
    [h, w, n] = size(image_stack);
elseif ndims(image_stack) == 4
    [h, w, c, n] = size(image_stack);
end
fprintf('Finish loading %d images.\n\n', n);

% compute the surface gradient from the stack of imgs and light source mat
disp('Computing surface albedo and normal map...')

% Estimate albedo and normals for grayscale images
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true);

% Three methods to estimate albedo and normals for 3-channel images
% [albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true, '1to3');
% [albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true, '3');
% [albedo, normals] = estimate_alb_nrm(image_stack, scriptV, true, 'gray');

% n_src = 10;
% [albedo, normals] = estimate_alb_nrm(image_stack(:, : , 1:n_src), scriptV(1:n_src, :), false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_row = construct_surface(p, q, 'row');
height_map_col = construct_surface(p, q, 'column');
height_map_avg = construct_surface(p, q, 'average');

% Display
show_results(albedo, normals, SE);
show_model(albedo, height_map_row);
show_model(albedo, height_map_col);
show_model(albedo, height_map_avg);
 
%% Face
[image_stack, scriptV] = load_face_images('photometrics_images/yaleB02/');
[h, w, n] = size(image_stack);
fprintf('Finish loading %d images.\n\n', n);
disp('Computing surface albedo and normal map...')
[albedo, normals] = estimate_alb_nrm(image_stack, scriptV, false);

%% integrability check: is (dp / dy  -  dq / dx) ^ 2 small everywhere?
disp('Integrability checking')
[p, q, SE] = check_integrability(normals);

threshold = 0.005;
SE(SE <= threshold) = NaN; % for good visualization
fprintf('Number of outliers: %d\n\n', sum(sum(SE > threshold)));

%% compute the surface height
height_map_row = construct_surface(p, q, 'row');
height_map_col = construct_surface(p, q, 'column');
height_map_avg = construct_surface(p, q, 'average'); 

% show_results(albedo, normals, SE);
show_model(albedo, height_map_row);
show_model(albedo, height_map_col);
show_model(albedo, height_map_avg);
