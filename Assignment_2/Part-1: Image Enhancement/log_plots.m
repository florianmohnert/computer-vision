%% LoG plots

im2 = imread('images/image2.jpg');


figure(1)
method1 = compute_LoG(im2,1);
subplot(1,3,1)
p1 = imshow(method1);
title('method 1');

method2 = compute_LoG(im2,2);
subplot(1,3,2)
p2 = imshow(method2);
title('method 2');

method3 = compute_LoG(im2,2,1,0.5);
subplot(1,3,3)
p3 = imshow(method3);
title('method 3');
