function[H,r,c] = demo_harris_corner_detector(img)

degrees = randi([1,360],1);

im = imrotate(img,degrees);

[H,r,c] = harris_corner_detector(im,100000,31);


end