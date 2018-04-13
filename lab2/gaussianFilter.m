function G = gaussianFilter(n, sigma)
if nargin < 2
    sigma = .5;
end
if nargin < 1
    n = 3;
end
if sigma <= 0
    error('Sigma must be positive');
end
if n < 1
    error('Invalid filter size');
end

d = floor(n/2);

[x,y] = meshgrid(-d:n-d-1,-d:n-d-1);
G = gaussian2(x, y, sigma);