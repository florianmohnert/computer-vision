function G = gauss1D(sigma, kernel_size)
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end

    %% solution
    N = floor(kernel_size / 2);
    x = linspace(-N, N, kernel_size);
    
    G = exp( -x .^ 2 / (2 * sigma^2) ) / sigma * sqrt(2*pi);
    G = G ./ sum(G);  % normalise
end
