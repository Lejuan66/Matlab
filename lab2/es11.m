function es11(image)
I = imread(image);
spectrum = log(abs(fftshift(fft2(double(I)))));

% image of the spectrum
imagesc(spectrum);

% 3D graph of the spectrum
figure; surf(1:size(I,1), 1:size(I,2), spectrum);