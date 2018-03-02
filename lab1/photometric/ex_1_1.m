[image_stack_5, V_5] = load_syn_images('photometrics_images/SphereGray5', 1);
[image_stack_25, V_25] = load_syn_images('photometrics_images/SphereGray25', 1);

% =========================================================================
% With shadow trick
% =================
[albedo_5, normal_5] = estimate_alb_nrm(image_stack_5, V_5, true);

figure(1);
subplot(2, 3, 1);
imshow(albedo_5);

subplot_idx = 2;

for i = 5:5:25
    [albedo, normal] = estimate_alb_nrm(image_stack_25(:, : , 1:i), V_25(1:i, :), true);
    
    subplot(2, 3, subplot_idx);
    imshow(albedo);
    
    subplot_idx = subplot_idx + 1;
end


% =========================================================================
% Without shadow trick
% ====================

[albedo_5_notrick, normal_5_notrick] = estimate_alb_nrm(image_stack_5, V_5, false);

figure(2);
subplot(2, 3, 1);
imshow(albedo_5_notrick);

subplot_idx = 2;

for i = 5:5:25
    [albedo, normal] = estimate_alb_nrm(image_stack_25(:, : , 1:i), V_25(1:i, :), false);
    
    subplot(2, 3, subplot_idx);
    imshow(albedo);
    
    subplot_idx = subplot_idx + 1;
end