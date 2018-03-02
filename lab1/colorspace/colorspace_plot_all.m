% viz all

I = imread('peppers.png');

I1 = ConvertColorSpace(I,'opponent');
close all
I2 = ConvertColorSpace(I,'rgb');
close all

I3 = ConvertColorSpace(I,'hsv');
close all

I4 = ConvertColorSpace(I,'ycbcr');
close all

I5 = ConvertColorSpace(I,'gray');
close all

figure

subplot(2,3,1);
p1 = imshow(I);
title('original')

subplot(2,3,2);
p2 = imshow(I1);
title('opponent')

subplot(2,3,3);
p3 = imshow(I2);
title('standardized rgb')


subplot(2,3,4);
p4 = imshow(I3);
title('hsv')


subplot(2,3,5);
p5 = imshow(I4);
title('ycbcr')

subplot(2,3,6);
p6 = imshow(rgb2gray(I));
title('grayscale')

