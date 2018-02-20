im = imread('color_constancy/awb.jpg');

awb = zeros(320,256,3);

 
R = im(:,:,1);

R_m = mean(R(:));



G = im(:,:,2);

G_m = mean(G(:));


B = im(:,:,3);

B_m = mean(B(:));

%Avg = mean([R_m,G_m,B_m]);

r = 128/R_m;
b = 128/B_m;
g = 128/G_m;


awb(:,:,1) = r*im(:,:,1);
awb(:,:,2) = g*im(:,:,2);
awb(:,:,3) = b*im(:,:,3);
awb = uint8(awb);

figure 
subplot(1,2,1)
title('original')
imshow(im)
subplot(1,2,2)
title('color constant')
imshow(awb)