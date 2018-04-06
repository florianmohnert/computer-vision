function [image_stack] = load_image_stack(dir_path, n, test)
%
% Args:
%   dir_path: path of image dataset
%   n:        number of images to load
%   test:     'true' for testing phase
%
% Return: a cell array of n images

files = dir(dir_path);
n_sources = length(files); % the number of images in the directory

image_stack = {};

% Do not take a random sample for testing  
if test == true
    indices = 1:n_sources;
else
    indices = randperm(n_sources);
end
    
img_count = 0;

for idx = 1:n_sources
    
    f_name = files(indices(idx)).name;
    
    % ignore everything but images
    if (length(f_name) < 4) || (f_name(end-3:end) ~= ".jpg")
        continue;
    end
    
    I = imread(strcat(files(indices(idx)).folder, '/', f_name));
    
    % For vocabulary building, do not consider grayscale images
    if test == true
        image_stack{idx} = I;
        img_count = img_count + 1;
    else
        if ndims(I) == 3 && size(I, 3) == 3
            image_stack{idx} = I;
            img_count = img_count + 1;
        end
    end
    
    % stop when n images have been loaded
    if img_count == n  break;  end
end
end
