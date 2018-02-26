function [normalized] = normalize_magnitude(x)

normalized = (x - min(x(:))) ./ (max(x(:)) - min(x(:)));

end