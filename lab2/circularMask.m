% create a circular mask
%
% s          size of the rectangular mask in the form [width height]
% r          radius of the circle
% c          centre of the circle (image centre as default)
% normalise  normalise the values in the resulting mask
% asymm      if 0, the disk is symmetric respect to the centre of 
%            the image; if 1 it is symmetric respect to the central pixel

function M = circularMask(s, r, c, normalise, asymm)

if nargin < 5
    asymm = 1;
end
if nargin < 4
    normalise = 0;
end
if nargin < 3
    c = s/2;
end

% translate the centre half pixel right in case of even size
if asymm
    c = c + .5 * (1 - mod(s, 2));
end

% set one in the pixels satisfying the equation of the circle
[X,Y] = ndgrid((1:s(1))-c(1)-.5, (1:s(2))-c(2)-.5);
M = X.^2 + Y.^2 <= r*r;

if normalise
    M = M / sum(M(:));
end

