tic
true_labels = importdata('labels.txt');
my_labels = zeros(size(true_labels));

N = size(true_labels,1);

for k = 1:N
    im = imread(sprintf('imagedata/train_%04d.png', k));
%    try
        my_labels(k,:) = myclassifier(im);
%    catch
%         my_labels(k,:) = myclassifier(im);
%         my_labels(k,:)
%         myclassifier(im, 1);
%         figure; imagesc(im)
%         return
%    end
%      if mean(true_labels(k,:) - my_labels(k,:) ~= 0)
%         k
%         %my_labels(k,:)
%         myclassifier(im, 1);
%         %figure; imagesc(im)
%         %return
%      end
end

fprintf('\n\nAverage precision: \n');
fprintf('%f\n\n',mean(sum(abs(true_labels - my_labels),2)==0));
toc

