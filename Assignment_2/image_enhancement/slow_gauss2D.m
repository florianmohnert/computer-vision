function G = slow_gauss2D(sigma, kernel_size)
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end

    %% solution
    N = floor(kernel_size / 2);
    [x, y] = meshgrid(-N:N, -N:N);
    
    G = exp( -(x .^ 2 + y .^ 2) / (2 * sigma^2) ) / sigma^2 * sqrt(2*pi);
    G = G ./ sum(G(:));  % normalise
end
