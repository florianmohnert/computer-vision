
function [ albedo, normal ] = estimate_alb_nrm(image_stack, scriptV, shadow_trick, rgb_method)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   rgb_method: "gray", "1to3" "3"
%   albedo : the surface albedo
%   normal : the surface normal

if nargin == 2
    shadow_trick = true;
end
rgb = false;

if ndims(image_stack) == 3
    [h, w, n_sources] = size(image_stack);
    channels = 1;
elseif ndims(image_stack) == 4
    [h, w, channels, n_sources] = size(image_stack);
    rgb = true;
    if rgb_method == "gray"
        gray_stack = zeros(h, w, n_sources);
        for src = 1:n_sources
            gray_stack(:, :, src) = rgb2gray(image_stack(:, :, :, src));
        end
    end
end
    

% create arrays for 
%   albedo (1/3 channel)
%   normal (3 channels)
albedo = zeros(h, w, channels);
normal = zeros(h, w, 3);


% =========================================================================
% YOUR CODE GOES HERE
for x = 1:h
    for y = 1:w
        
        % RGB IMAGE
        if rgb
            i_rgb = squeeze(image_stack(x, y, :, :));
            i_r = i_rgb(1, :);
            i_g = i_rgb(2, :);
            i_b = i_rgb(3, :);
            
            % solve for N using one channel
            if rgb_method == "gray"
                i = squeeze(gray_stack(x, y, :));
            end
            if rgb_method == "1to3"
                i = i_r';
            end
            
            % begin < Solve linear system(s) >
            if shadow_trick
                if (rgb_method == "gray") || (rgb_method == "1to3")
                    I = diag(i); 
                    [g, ~]  = linsolve(I * scriptV, I * i);
                elseif rgb_method == "3"
                    I_r = diag(i_r);
                    I_g = diag(i_g);
                    I_b = diag(i_b);
                    [g_r, ~]  = linsolve(I_r * scriptV, I_r * i_r');
                    [g_g, ~]  = linsolve(I_g * scriptV, I_g * i_g');
                    [g_b, ~]  = linsolve(I_b * scriptV, I_b * i_b');
                end 
            elseif ~ shadow_trick
                if (rgb_method == "gray") || (rgb_method == "1to3")
                    [g, ~]  = linsolve(scriptV, i);
                elseif rgb_method == "3"
                    [g_r, ~]  = linsolve(scriptV, i_r');
                    [g_g, ~]  = linsolve(scriptV, i_g');
                    [g_b, ~]  = linsolve(scriptV, i_b');
                end
            end
            % end < Solve linear system(s) >
            
            % begin < Normal >
            if (rgb_method == "gray") || (rgb_method == "1to3")
                normal(x, y, :) = g / norm(g);
                N = g / norm(g);
            elseif rgb_method == "3"
                max_norm = max([norm(g_r), norm(g_g), norm(g_b)]);
                
                if norm(g_r) == max_norm
                    normal(x, y, :) = g_r / norm(g_r);
                elseif norm(g_g) == max_norm
                    normal(x, y, :) = g_g / norm(g_g);
                else
                    normal(x, y, :) = g_b / norm(g_b);
                end
            end
            % end < Normal >
            
            % begin < Albedo >
            if rgb_method == "gray"
                k_r = sum((i_r * scriptV * N)) / sum((scriptV * N) .^ 2);
                k_g = sum((i_g * scriptV * N)) / sum((scriptV * N) .^ 2);
                k_b = sum((i_b * scriptV * N)) / sum((scriptV * N) .^ 2);
                albedo(x, y, :) = [k_r k_g k_b];
                
            elseif rgb_method == "1to3"
                k_r = norm(g);
                k_g = sum((i_g * scriptV * N)) / sum((scriptV * N) .^ 2);
                k_b = sum((i_b * scriptV * N)) / sum((scriptV * N) .^ 2);
                albedo(x, y, :) = [k_r k_g k_b];
                
            elseif rgb_method == "3"
                albedo(x, y, :) = [norm(g_r) norm(g_g) norm(g_b)];   
            end
            % end < Albedo >
            
        % GRAYSCALE IMAGE
        else
            i = squeeze(image_stack(x, y, :));
        
            if shadow_trick
                I = diag(i);  % construct the diagonal matrix I
                [g, ~]  = linsolve(I * scriptV, I * i);
            else
                [g, ~]  = linsolve(scriptV, i);
            end  
            
            albedo(x, y, 1) = norm(g);
            normal(x, y, :) = g / albedo(x, y, 1);
        end
   
    end 
end

end

