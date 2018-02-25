% denoising analyses
%%
im1 = imread('images/image1_saltpepper.jpg');
im2 = imread('images/image1_gaussian.jpg');
%% saltpepper
figure(1)
denoised_box_3 = denoise(im1,'box', 3);
subplot(2,3,1)
p1 = imshow(denoised_box_3);
title('box 3x3');
denoised_box_5 = denoise(im1,'box', 5);
subplot(2,3,2)
p1 = imshow(denoised_box_5);
title('box 5x5');
denoised_box_7 = denoise(im1,'box', 7);
subplot(2,3,3)
p1 = imshow(denoised_box_7);
title('box 7x7');
denoised_median_3 = denoise(im1,'median', 3);
subplot(2,3,4)
p1 = imshow(denoised_median_3);
title('median 3x3');
denoised_median_5 = denoise(im1,'median', 5);
subplot(2,3,5)
p1 = imshow(denoised_median_5);
title('median 5x5');
denoised_median_7 = denoise(im1,'median', 7);
subplot(2,3,6)
p1 = imshow(denoised_median_7);
title('median 7x7');

%%  PSNR 
disp('image 1')
psnr_box3_im1 = myPSNR(im1,denoised_box_3);
psnr_box5_im1 = myPSNR(im1,denoised_box_5);
psnr_box7_im1 = myPSNR(im1,denoised_box_7);
psnr_median3_im1 = myPSNR(im1,denoised_median_3);
psnr_median5_im1 = myPSNR(im1,denoised_median_5);
psnr_median7_im1 = myPSNR(im1,denoised_median_7);

%% gaussian
figure(2)
denoised_box_3 = denoise(im2,'box', 3);
subplot(2,3,1)
p1 = imshow(denoised_box_3);
title('box 3x3');
denoised_box_5 = denoise(im2,'box', 5);
subplot(2,3,2)
p1 = imshow(denoised_box_5);
title('box 5x5');
denoised_box_7 = denoise(im2,'box', 7);
subplot(2,3,3)
p1 = imshow(denoised_box_7);
title('box 7x7');
denoised_median_3 = denoise(im2,'median', 3);
subplot(2,3,4)
p1 = imshow(denoised_median_3);
title('median 3x3');
denoised_median_5 = denoise(im2,'median', 5);
subplot(2,3,5)
p1 = imshow(denoised_median_5);
title('median 5x5');
denoised_median_7 = denoise(im2,'median', 7);
subplot(2,3,6)
p1 = imshow(denoised_median_7);
title('median 7x7');

%%
disp('image2')
psnr_box3_im2 = myPSNR(im2,denoised_box_3);
psnr_box5_im2 = myPSNR(im2,denoised_box_5);
psnr_box7_im2 = myPSNR(im2,denoised_box_7);
psnr_median3_im2 = myPSNR(im2,denoised_median_3);
psnr_median5_im2 = myPSNR(im2,denoised_median_5);
psnr_median7_im2 = myPSNR(im2,denoised_median_7);

