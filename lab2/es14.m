% read image and get its spectrum
I = double(imread('images/freqdist.png'));
S = fftshift(fft2(I));

% noisy frequencies
f1 = [92 101];
f2 = [109 101];

% build a notch mask for the two frequencies
sigma = 5;
s = size(S);
gauss = 1;
mask = min(notchFilter(s, f1, gauss, sigma), notchFilter(s, f2, gauss, sigma));

% get filtered image
FI = uint8(ifft2(ifftshift(S .* mask)));

% show result (equalise to see details better)
imagesc(histeq(FI));
axis image; axis off; colormap gray;
