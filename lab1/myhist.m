function result = myhist(image)

s = size(image); % get image size

% Compute the histogram 
histogram = histcounts(image,255);

% Compute cumulative histogram distribution
cdf = cumsum(histogram);

% Equalise
result = cdf(image + 1);

% Normalise
result = (256 / (s(1) * s(2))) * result;

% Convert back to unsigned eight-bit integer
result = uint8(result);
