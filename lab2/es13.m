I = imread('./images/cameraman.png');

thresh = 40; % frequency threshold (radius)

S = fftshift(fft2(double(I))); % spectrum

M = circularMask(size(I), thresh); % circular mask

SJ = S .* M; % cut high frequencies outside the mask

J = ifft2(ifftshift(SJ)); % inverse transform

imagesc(J);
axis image; axis off; colormap gray;
