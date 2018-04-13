% Median filter
%
% At the border, the filter size is reduced asymmetrically to not exit 
% the image region.

function J = medianFilter(I, n)
if nargin < 2
    n = 3;
end
if n < 1
    error('Invalid filter size');
end

d = floor(n/2);

s = size(I);

J = uint8(zeros(s));

for i = 1:s(1)
    for j = 1:s(2)
        neighborhood = I(...
            max(i-d,1):min(i+n-d-1,s(1)) , max(j-d,1):min(j+n-d-1,s(2)) ...
        );
        J(i,j) = median(neighborhood(:));
    end
end