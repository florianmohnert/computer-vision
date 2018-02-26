disp("gauss1D(2, 5) = ");
gauss1D(2, 5)

disp("gauss2D(2, 3) = ");
gauss2d = gauss2D(2, 7)

disp("slow_gauss2D(2, 3) = ");
slow_gauss2d = slow_gauss2D(2, 7)

figure(1);
subplot(1, 2, 1);
imagesc(gauss2d);
subplot(1, 2, 2);
imagesc(gauss2d);

a1 = @() gauss2D(2, 11);
b1 = @() slow_gauss2D(2, 11);
timeit(a1) - timeit(b1)

a2 = @() gauss2D(2, 101);
b2 = @() slow_gauss2D(2, 101);
timeit(a2) - timeit(b2)

a3 = @() gauss2D(2, 1001);
b3 = @() slow_gauss2D(2, 1001);
timeit(a3) - timeit(b3)