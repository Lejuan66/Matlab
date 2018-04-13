%
% Exercise 15
%
% It is time to make a small computer program, to learn to automate things 
% and loop over an image. Make a script-file with the extension .m, e.g. 
% by the command edit myscript.m in Matlab. Run your program on some image 
% that you have downloaded from the internet.
% 
% • Load the image.
% • Convert the image to grayscale using e.g. rgb2gray.
% • Resize and/or crop your image to 128 × 128 pixel size, without 
%   changing the aspect ratio of the image.
% • Loop (!) over the image using a 5×5 pixel window. For each such 
%   window, compute the average pixel value and store the result in a 
%   new image. Treat borders in some controlled way and make sure the 
%   result has the same size in pixels as the original image. You will 
%   need at least two nested for-loops, to scan rows and columns in
%   your image.
% • Subtract the original image from your new filtered image.
% • Present the original, filtered and subtracted images in a figure, 
%   using e.g. subplot

function exercise15(image)

SIZE = 128; % size of the final image
W = 5;      % size of the pixel window

I = imread(image);          % read (RGB) image data
I = rgb2gray(I);            % convert to grayscale
I = double(I);              % convert to floating point type to avoid overflows and roundings
s = size(I);                % get size of the image
r = SIZE / min(s);          % ratio to scale image (minimum edge = SIZE)
I = imresize(I, r*s);       % resize
I = I(1:SIZE, 1:SIZE);      % crop to SIZE x SIZE if needed
s = size(I);                % update size after resizing
T = zeros(size(I));         % initialise transformed image

% zero padding around the image
d = floor(W/2);
I_pad = zeros(size(I) + 2*d);
I_pad((1:s(1))+d,(1:s(2))+d) = I;

% iterate over pixels
for i = 1:s(1)
    for j = 1:s(2)
        % assign to each pixel the average intensity over the window
        T(i,j) = mean(mean(I_pad( i : i+W-1 , j : j+W-1 )));
    end
end

% plot

figure;
subplot(3,1,1);
imagesc(I);
title('Original (grayscale scaled/cropped)');
axis image; axis off;

subplot(3,1,2);
imagesc(T);
title('Average over pixel windows');
axis image; axis off;

subplot(3,1,3);
imagesc(uint8(T - I));
title('Difference "average - original"');
axis image; axis off;

colormap gray;
