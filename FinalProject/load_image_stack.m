function [image_stack] = load_image_stack(dir_path, n)
%
% Args:
%   dir_path: path of image dataset
%   n:        number of images to load
%
% Return: a cell array of n images

files = dir(dir_path);
n_sources = length(files); % the number of images

image_stack = {};

random_indices = randperm(n_sources);
img_count = 0;

for idx = 1:length(random_indices)
    
    f_name = files(random_indices(idx)).name;
    
    % ignore everything but images
    if (length(f_name) < 4) || (f_name(end-3:end) ~= ".jpg")
        continue;
    end
    
    I = imread(strcat(files(random_indices(idx)).folder, '/', f_name));
    
    % TODO: we only load RGB images for now
    if ndims(I) == 3 && size(I, 3) == 3
        image_stack{idx} = I;
        img_count = img_count + 1;
    end
    
    % stop when n images have been loaded
    if img_count == n  break;  end
end
end
