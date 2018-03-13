% demo ransac transform

clear all;
close all;

im1 = imread('boat1.pgm');
im2 = imread('boat2.pgm');

A_total = [];
[h,w] = size(im1);

[num_matches, ~, best_model, best_model_score] = ransac(im1, im2, 10, 50);

top_left = round([1 1 0 0 1 0; 0 0 1 1 0 1] * best_model);
top_right = round([1 w 0 0 1 0; 0 0 1 w 0 1] * best_model);
bottom_left = round([h 1 0 0 1 0; 0 0 h 1 0 1] * best_model);
bottom_right = round([h w 0 0 1 0; 0 0 h w 0 1] * best_model);

leftmost_point = min(top_left(2), bottom_left(2));
highest_point = min(top_left(1), top_right(1));

width = max(top_right(2), bottom_right(2)) - leftmost_point;
height = max(bottom_left(1), bottom_right(1)) - highest_point;

w_offset = - leftmost_point + 1;   
h_offset = - highest_point + 1;

transformed_image = zeros(height, width);

for x = 1:h
    for y = 1:w
    
    A = [x y 0 0 1 0; 0 0 x y 0 1]; 
    new_coords = round(A * best_model);
    new_coords = new_coords + [h_offset; w_offset];
     
    transformed_image(new_coords(1), new_coords(2)) = im2(x,y) ;

    end
end



figure(3)
imshow(uint8(transformed_image))

    