function lab(image, closingRadius, minimaThresh)

% default value for optional arguments
if nargin < 3
    minimaThresh = 5;
end
if nargin < 2
    closingRadius = 2;
end

% open image
I = imread(image);

% convert to grayscale if needed
if size(I,3) > 1
    I = rgb2gray(I);
end

% threshold
thresh = multithresh(I);
J = I < thresh;

% show histogram and threshold
figure
histogram(I);
hold on;
line([thresh, thresh], ylim, 'Color', 'magenta');
hold off;

% morphological closure to remove noise
K = imclose(J, strel('disk', closingRadius));

% distance transform
D = bwdist(~K);
D = -D;
D(~K) = -Inf;

% suppress shallow minima to avoid oversegmentation
D = imhmin(D, minimaThresh);

% plot surface of distance transform
figure;
surf(1:size(D,2), 1:size(D,1), D);

% watershed
W = watershed(D);

% get segmentation props
p = regionprops(W, J, 'all');

% plot segments and centroids
figure;
imagesc(label2rgb(W)); axis image; axis off;
hold on;
c = [p.Centroid];
for k = 2:size(p,1) % first index is background region
	plot(c(1+2*(k-1)), c(2*k), 'w+', 'MarkerSize', 10, 'LineWidth', 2);
end
hold off;

% get areas
figure;
a = [p.Area];
a = a(2:size(a,2)); % first index is background region
histogram(a, 35);

