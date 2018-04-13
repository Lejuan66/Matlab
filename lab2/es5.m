function es5(image)

I = imread(image);

% create Sobel filter for y
sy = fspecial('sobel');

% create Sobel filter for x
sx = sy';

r1 = conv2(I, sx, 'same');
r2 = conv2(I, sy, 'same');
r3 = sqrt(r1.^2 + r2.^2); % gradient magnitude

figure;

subplot(1,3,1);
imagesc(r1);
title('d/dx');
axis image; axis off; colormap gray;

subplot(1,3,2);
imagesc(r2);
title('d/dy');
axis image; axis off; colormap gray;

subplot(1,3,3);
imagesc(r3);
title('||(d/dx, d/dy)||');
axis image; axis off; colormap gray;
