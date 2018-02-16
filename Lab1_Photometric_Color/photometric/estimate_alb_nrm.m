
function [ albedo, normal ] = estimate_alb_nrm(image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, ~] = size(image_stack);
if nargin == 2
    shadow_trick = true;
end

% create arrays for 
%   albedo (1 channel)
%   normal (3 channels)
albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);

% =========================================================================
% YOUR CODE GOES HERE
[m, n, ~] = size(image_stack);

for x= 1:m
    for y= 1:n
        %   stack image values into a vector i
        i = image_stack(x, y, :);
        i = i(:);
        
        if shadow_trick
            I = diag(i);  % construct the diagonal matrix I
            [g, ~]  = linsolve(I * scriptV, I * i);
        else
            [g, ~]  = linsolve(scriptV, i);
        end
        
        % albedo at this point is |g|
        albedo(x, y) = norm(g);  
        
        % normal at this point is g / |g|
        normal(x, y, :) = cat(1, g / norm(g), 1);
    end 
end

end

