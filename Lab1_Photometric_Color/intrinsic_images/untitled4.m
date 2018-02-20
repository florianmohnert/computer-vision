

new = (ball(:,:,1) + ball(:,:,2) + ball(:,:,3)) ./3;
figure
subplot(1,2,1)
imshow(ball)
subplot(1,2,2)
imshow(new)