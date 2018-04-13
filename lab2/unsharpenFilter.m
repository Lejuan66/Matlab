% Unsharpen filter
% 
% n      Size of the filter mask
% alpha  Amount of filtering

function S = unsharpenFilter(n, alpha)
if nargin < 2
    alpha = .9;
end
if nargin < 1
    n = 3;
end
c = ceil(n/2);
I = zeros(n);
I(c,c) = 1;
A = 1/(n*n) * ones(n);
S = I + alpha * (I - A);