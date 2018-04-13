function es7(image)
I = imread(image);

% median filter
subplot(1,3,1);
imagesc(medfilt2(I));
title('median');
axis image; axis off;

% gaussian filter
subplot(1,3,2);
imagesc(conv2(I, fspecial('gaussian', 5, 2), 'same'));
title('gaussian');
axis image; axis off;

% mean filter
subplot(1,3,3);
imagesc(conv2(I, fspecial('average', 5), 'same'));
title('mean');
axis image; axis off;
