function [best_model, best_model_score, transformed_im, new_coords_all] = RANSAC(im1, im2, n_samples, n_iter)

radius = 10;

[matches, f1, f2] = keypoint_matching(im1, im2, false);
num_matches = size(matches, 2);
a = -130; b = -23; % matches returns indexes of points, coordinates can then be found in f1 and f2


% Initialise A and b for all matches.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_total = [];
b_total = [];
for i = 1:num_matches
    match_indexes = matches(:, i);
       
    % features vecs for both points
    im1_feat = f1(:, match_indexes(1));
    im2_feat = f2(:, match_indexes(2));

    % coordinates
    im1_x_coord = im1_feat(1);
    im1_y_coord = im1_feat(2);

    im2_x_coord = im2_feat(1);
    im2_y_coord = im2_feat(2);

    A = [im1_x_coord im1_y_coord 0 0 1 0; 0 0 im1_x_coord im1_y_coord 0 1];

    A_total = cat(1, A_total, A);
    b_total = cat(1, b_total, [im2_x_coord im2_y_coord]);
end



% RANSAC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
best_model_score = 0;
best_model = zeros(1, 6);
best_model_A_inliers = [];
best_model_b_inliers = [];

for iter = 1:n_iter
    
    rand_indexes = randperm(num_matches, n_samples);
    A_sample = [];
    b_sample = [];
    
    for rand_i = rand_indexes
        A_sample = cat(1, A_sample, A_total([rand_i*2-1,rand_i*2] , :));
        b_sample = cat(1, b_sample, b_total(rand_i, :)');
    end
    
    X = pinv(A_sample) * b_sample;
    preds = A_total * X;
   
    n_inliers = 0;
    % Also possible to re-estimate the model based on all the inliers:
    % A_inliers = [];
    % b_inliers = [];
    
    for i = 1:num_matches
        match = matches(:, i);

        x_coord = f2(1, match(2));
        y_coord = f2(2, match(2));
        
        offset = floor(radius / 2);
        
        for x_offset = -offset:offset
            for y_offset = -offset:offset
                if round([preds(i*2-1); preds(i*2)]) == round([x_coord + x_offset; y_coord + y_offset])
              
                    n_inliers = n_inliers + 1;
                    
                    % Also possible to re-estimate the model based on all the inliers:
                    % A_inliers = cat(1, A_inliers, A_total([i*2-1, i*2], :));
                    % b_inliers = cat(1, b_inliers, b_total(i, :)');
                    break
                end
            end
        end
    end
    
    if n_inliers > best_model_score
        best_model = X;
        best_model_score = n_inliers;
        % Also possible to re-estimate the model based on all the inliers:
        % best_model_A_inliers = A_inliers;
        % best_model_b_inliers = b_inliers;
    end 
end

% Also possible to re-estimate the model based on all the inliers:
% final_model = pinv(best_model_A_inliers) * best_model_b_inliers;

[h,w] = size(im2);
[width, height, w_offset, h_offset] = estimate_size(h, w, best_model);
transformed_image = zeros(height, width);
new_coords_all = zeros(h, w, 2);

for x = 1:h
    for y = 1:w
        A = [x y 0 0 1 0; 0 0 x y 0 1]; 

        new_coords_base = round(A * best_model);
        new_coords_all(x, y, :) = new_coords_base + [a; b];
        new_coords = new_coords_base + [h_offset; w_offset];

        transformed_image(new_coords(1), new_coords(2)) = im2(x,y);
    end
end

transformed_im = uint8(transformed_image);

end