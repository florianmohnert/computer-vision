function visualize(input_image, gray)


figure;
subplot(2,2,1)
if strcmp(gray,'gray')
    imshow(input_image(:,:,1))
else
    imshow(input_image);
end
for i = 1:3
   subplot(2,2,i+1);
   imshow(input_image(:,:,i));
end


end

