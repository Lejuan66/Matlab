I = imread('./images/wagon_shot_noise.png');

s = [3 5 7]; % filter sizes
n = size(s,2);

for i = 1:n
    subplot(1,n,i);
    imagesc(medfilt2(I, [s(i) s(i)]));
    title(sprintf('%d × %d', s(i), s(i)));
    axis image; axis off; colormap gray;
end