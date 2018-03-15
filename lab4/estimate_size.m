function [width, height, w_offset, h_offset] = estimate_size(h, w, transfrom)
%
% Args: 
%   h - original height
%   w - original width
%   transform - transformation as a vertical vector of size 6

top_left = round([1 1 0 0 1 0; 0 0 1 1 0 1] * transfrom);
top_right = round([1 w 0 0 1 0; 0 0 1 w 0 1] * transfrom);
bottom_left = round([h 1 0 0 1 0; 0 0 h 1 0 1] * transfrom);
bottom_right = round([h w 0 0 1 0; 0 0 h w 0 1] * transfrom);

leftmost_point = min(top_left(2), bottom_left(2));
highest_point = min(top_left(1), top_right(1));

width = max(top_right(2), bottom_right(2)) - leftmost_point;
height = max(bottom_left(1), bottom_right(1)) - highest_point;

w_offset = - leftmost_point + 1;   
h_offset = - highest_point + 1;

end