function U = histogramUniformity(I)

H = histcounts(I,255);
U = sum(H.^2);