%
% Exercise 16
% And finally, histogram equalization, revisited.
% 
% • Load the image.
% • Convert the image to grayscale using e.g. rgb2gray.
% • Perform histogram equalization on this image using your own algorithm,
%   without using histeq. Efficiency is not so important, you may use 
%   for-loops or other ways to compute the transformation and apply it 
%   to the image.
% • Present the original and equalized images in a figure. Compare with 
%   Matlabs native histeq function.
% • Make your own histogram equalization into a callable function, e.g. 
%   Inew = myhist(I).

function exercise16(image)

I = imread(image);       % read image
grayImage = rgb2gray(I); % convert to grayscale

% histogram equalisation
result = myhist(grayImage);

% plot

figure;

subplot(3,1,1);
imagesc(grayImage);
axis image; axis off;
title('Original');

subplot(3,1,2);
imagesc(result);
axis image; axis off;
title('Equalised');

subplot(3,1,3);
histeq(grayImage);
title('histeq');

colormap gray;

