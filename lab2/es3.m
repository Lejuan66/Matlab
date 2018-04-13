function es3(image)
I = double(imread(image));
width = 5;
sigma1 = 1;
sigma2 = 4;

% two low-pass filters
L1 = fspecial('gaussian', width, sigma1);
L2 = fspecial('gaussian', width, sigma2);
% low-pass filtered image
figure; imagesc(conv2(I, L2, 'same'));
axis image; axis off; caxis([1 255]);

% an high-pass filter
H = zeros(size(L1));
H(ceil(size(H,1)/2), ceil(size(H,2)/2)) = 1;
H = H - L2;
% high-pass filtered image
figure; imagesc(conv2(I, H, 'same'));
axis image; axis off; caxis([1 255]);

% a band-pass filter
B = L1 - L2;
% band-pass filtered image
figure; imagesc(conv2(I, B, 'same'));
axis image; axis off; caxis([1 255]);
