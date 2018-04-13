% Generate normalised gaussian weights
% 
% x      X coordinates
% y      Y coordinates
% sigma  standard deviation (symmetric)
% mu     mean [mux muy]

function g = gaussian2(x, y, sigma, mu)
if nargin < 4
    mu = [0 0];
end
g = 1/(2*pi*sigma^2) .* exp(-((x-mu(1)).^2+(y-mu(2)).^2)/(2*sigma^2));
g = g / sum(sum(g)); % normalise