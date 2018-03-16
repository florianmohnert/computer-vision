function [ image_stack] = load_image_stack(dir_path,n)

    % files = dir('photometrics_images/SphereGray5');
    files = dir(dir_path);
    n_sources = length(files); % the number of images
        
    image_stack = {};
   
    random_indices = randperm(n_sources);
    cnt = 0;
    for idx = 1:length(random_indices)
    
        f_name = files(random_indices(idx)).name;
       
        
        if (length(f_name) < 4) || (f_name(end-3:end) ~= ".jpg")
            continue;
        end 
            
        I = imread(strcat(files(random_indices(idx)).folder, '/', f_name)) ;
        
        if ndims(I) == 3
            image_stack{idx} = I;
            cnt = cnt+1;
        end
        
        if cnt == n
            
            break;
        end
        
        
    end
end