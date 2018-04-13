function es4()

cameraman = double(imread('./images/cameraman.png'));
wagon = double(imread('./images/wagon.png'));

p = {cameraman wagon};
n = [3 5 25];    % kernel size
a = [.5 .9 2.5]; % alpha values 

h = size(n,2);
w = size(a,2);

for k = 1:size(p,2) % iterate over images
    figure;
    for i = 1:h     % iterate over kernel sizes
        for j = 1:w % iterate over alpha values
            subplot(h, w, (i-1)*w+j);
            imagesc(conv2(p{:,k}, unsharpenFilter(n(i),a(j)), 'same'));
            axis image; axis off; colormap gray; caxis([0 255]);
        end
    end
end
