% Bilateral filter with gaussian weights
%
% On the border, only pixels inside the image are considered, 
% indices falling outside of the image are ignored.
%
% I        Input image
% n        Size of the filter mask
% sigma_f  Standard deviation for intensity values
% sigma_g  Standard deviation for pixel distance

function J = bilateralFilter(I, n, sigma_f, sigma_g)

if n < 1
    error('Invalid kernel size');
elseif sigma_f <= 0 || sigma_g <= 0
    error('Sigma value must be positive');
end

I = double(I); % convert to float for computation purpose

s = size(I);
J = zeros(s); % matrix for the result (floating point)

d = floor(n / 2); % radius of the neighborhood

% gaussian weights for pixels
[x,y] = meshgrid(-d:n-d-1,-d:n-d-1);
W_g = gaussian2(x, y, sigma_g);

for i = 1:s(1)
    for j = 1:s(2)
        % index intervals for the neighborhood of the current pixel
        x1 = max(i-d, 1);
        x2 = min(i-d+n-1, s(1));
        y1 = max(j-d, 1);
        y2 = min(j-d+n-1, s(2));
        
        % neighborhood
        N = I(x1:x2,y1:y2);
        
        % index intervals for weights (always centre the W_g matrix)
        xx = (x1:x2) - (i-d) + 1;
        yy = (y1:y2) - (j-d) + 1;
        
        % compute actual filter kernel for the current pixel
        W = normpdf(N - I(i,j), 0, sigma_f) .* W_g(xx,yy);
        
        % filter!
        J(i,j) = sum(sum(W .* N)) / sum(sum(W));
    end
end

J = uint8(J); % convert result to integers
