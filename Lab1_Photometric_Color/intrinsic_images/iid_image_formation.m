% reconstructing ball.png

ball_reflectance = imread('intrinsic_images/ball_reflectance.png');
ball_shading = imread('intrinsic_images/ball_shading.png');
ball = imread('intrinsic_images/ball.png');



ball_approx =  double(ball_reflectance) .* (double(ball_shading));

ball_approx = uint16(ball_approx);

figure

subplot(2,2,1)

im1 = imshow(ball);
title('original')


subplot(2,2,2)


im2 = imshow(ball_approx);
title('reconstructed')
subplot(2,2,3)


im3 = imshow(ball_shading);
title('shading')
subplot(2,2,4)


im4 = imshow(ball_reflectance);
title('reflectance')

% green ball
ball_reflectance_green = ball_reflectance;
green_channel = ball_reflectance_green(:,:,2);

ball_reflectance_green(:,:,1) = zeros(266,480);
not_zero = green_channel ~= 0;
green_channel(not_zero) = 255;
ball_reflectance_green(:,:,2) = green_channel;
ball_reflectance_green(:,:,3) = zeros(266,480);
ball_approx_green =  double(ball_reflectance_green) .* (double(ball_shading));

ball_approx_green = uint16(ball_approx_green);
figure
subplot(1,3,1)

im1 = imshow(ball);
title('original')
subplot(1,3,2)
im5 = imshow(ball_approx_green);
title('Green')


% magenta ball
ball_reflectance_magenta = ball_reflectance;

red_channel = ball_reflectance_magenta(:,:,1);
green_channel = ball_reflectance_magenta(:,:,2);
blue_channel = ball_reflectance_magenta(:,:,3);

ball_reflectance_magenta(:,:,2) = zeros(266,480);
not_zero = red_channel ~= 0;
red_channel(not_zero) = 255;
ball_reflectance_magenta(:,:,1) = red_channel;
not_zero = blue_channel ~= 0;
blue_channel(not_zero) = 255;
ball_reflectance_magenta(:,:,3) = blue_channel;

ball_approx_magenta =  double(ball_reflectance_magenta) .* (double(ball_shading));

ball_approx_magenta = uint16(ball_approx_magenta);

subplot(1,3,3)
im6 = imshow(ball_approx_magenta);
title('Magenta')

