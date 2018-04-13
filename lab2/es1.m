function es1(image)
I = double(imread(image));

sizes = [3 7 31];
l = length(sizes);

sigma = 2;
sigma_f = 5;
sigma_g = 5;
alpha = .9;

% gaussian filter (smoothing)
figure;
for i = 1:l
    subplot(1, l, i);
    imagesc(conv2(I, fspecial('gaussian', sizes(i), sigma), 'same'));
    title(sprintf('gaussian, n=%d, σ=%.2f', sizes(i), sigma));
    colormap gray; axis image; axis off;
end

% bilateral filter (smoothing, preserves edges)
figure
for i = 1:l
    subplot(1, l, i);
    imagesc(bilateralFilter(I, sizes(i), sigma_f, sigma_g));
    title(sprintf('bilateral, n=%d, σ_f=%.2f, σ_g=%.2f', sizes(i), sigma_f, sigma_g));
    colormap gray; axis image; axis off;
end

% sharpening
figure
for i = 1:l
    subplot(1, l, i);
    imagesc(conv2(I, unsharpenFilter(sizes(i), alpha), 'same'));
    title(sprintf('unsharpen, n=%d, α=%.2f', sizes(i), alpha));
    colormap gray; axis image; axis off; caxis([0 255]);
end
