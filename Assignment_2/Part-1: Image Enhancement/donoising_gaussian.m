%% plots gaussian filter

denoised_gaussian_05 = denoise(im2,'gaussian', 3, 0.5);
denoised_gaussian_1 = denoise(im2,'gaussian', 5, 1);
denoised_gaussian_2 = denoise(im2,'gaussian', 5, 2);

figure(3)
subplot(1,3,1)
p1 = imshow(denoised_gaussian_05);
title('3x3 with sigma = 0.5');
subplot(1,3,2)
p2 = imshow(denoised_gaussian_1);
title('5x5 with sigma = 1');
subplot(1,3,3)
p2 = imshow(denoised_gaussian_2);
title('11x11 with sigma = 2');

%% PSNR
myPSNR(im1_original,denoised_gaussian_05)
myPSNR(im1_original,denoised_gaussian_1)
myPSNR(im1_original,denoised_gaussian_2)

