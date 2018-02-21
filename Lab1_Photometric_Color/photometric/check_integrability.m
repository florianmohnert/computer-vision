function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
[h, w, ~] = size(normals);

p = zeros(size(normals));
q = zeros(size(normals));
SE = zeros(size(normals));

% Compute p and q, where
% p measures value of df / dx
p = normals(:, :, 1) ./ normals(:, :, 3);
% q measures value of df / dy
q = normals(:, :, 2) ./ normals(:, :, 3);

p(isnan(p)) = 0;
q(isnan(q)) = 0;

dp_dy = zeros(size(p));
dq_dx = zeros(size(q));

% Approximate second derivative by neighbour difference
for y = 2:w-1
    dp_dy(:, y) = (q(:, y+1) - q(:, y-1)) / 2;
end 

for x = 2:h-1
    dq_dx(x, :) = (q(x+1, :) - q(x-1, :)) / 2;
end

% [~, dp_dy] = gradient(p);
% [dq_dx, ~] = gradient(q);

% Compute the Squared Errors of the second derivatives SE
SE = (dp_dy - dq_dx) .^ 2;

end

