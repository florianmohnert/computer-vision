function [ image_stack, V ] = load_image_stack(dir_path)

    % files = dir('photometrics_images/SphereGray5');
    files = dir(dir_path);
    n_sources = length(files) - 2; % the number of images
        
    image_stack = zeros(512, 512, n_sources);
    V = zeros(n_sources, 2);
    
    for file = 3:length(files)
        f_name = files(file).name;
        I = imread(strcat(files(file).folder, '/', f_name)) ;
    
        % -2 because we ignored the files . and ..
        image_stack(:, :, file-2) = I(:,:,1);
        
        f_name = char(f_name);     % file name as char vector
        f_name = f_name(1:end-4);  % remove '.png'
        
        split_f_name = split(f_name, "_");
        x1 = str2double(split_f_name(2));
        x2 = str2double(split_f_name(3));
        
        V(file, :) = [x1, x2];
    end
end