% Create a notch mask
%
% s        Size [sy sx] of the mask
% c        Centre [cy cx] of the mask
% gaussian If 1, gaussian notch, otherwise binary circular notch
% sigma    Sigma for gaussian (or radius for circular) notch

function N = notchFilter(s, c, gaussian, sigma)

if nargin < 4
    sigma = 3;
end
if nargin < 3
    gaussian = 0;
end

% create first notch
[X,Y] = meshgrid(1:s(2),1:s(1));
if gaussian
    N1 = gaussian2(X, Y, sigma, c);
else
    N1 = circularMask(s, sigma, fliplr(c), 0, 0);
end

% center if the spectrum has even size
k = [1 1] - mod(s, 2);
c = c - k;

% create second notch, specular to N1
N2 = zeros(s);
N2(1+k(1):s(1),1+k(2):s(2)) = N1(s(1):-1:1+k(1),s(2):-1:1+k(2));

% add and normalise
N = N1 + N2;
N = N / max(N(:));
N = ones(s) - N;
