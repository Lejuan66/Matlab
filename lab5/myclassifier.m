% Lab 5
% Lejuan Hu, Martino Pilia
%
% =================================
% Description of the Adopted Method
% =================================
%
% The general idea is to look at the intersection between each digit
% and its vertical axis. If there are two intersections it is a zero,
% with one intersection it is a one, with three it is a two.
%
% The classifier is a trivia function which just maps the number of
% intersections with the expected digit. No statistical classification,
% so no training. Quite primitive, but it seems to work for this problem.
%
% Firstly the image is filtered, with a gaussian smoothing followed
% by a thresholding on a fixed (and quite aggressive) threshold, followed
% by a hit-or-miss transform to clean the border of the segments, 
% removing some bulges which can interfer with classification. The
% combination of smoothing and fixed-threshold is used not just to remove 
% sparse noise (which is easy to do by looking at the connected components)
% but in order to try to minimize the influence of noise on the image 
% border, at the same time without adding artifacts or connections 
% between separte digits.
% 
% Then connected components are isolated, and if there is high variability 
% due to the presence of spurious components due to noise, only the 
% biggest one are kept (whose height is above the average of the (up to) 
% six higher components).
%
% The next problem is to segment attached digits. The aspect ratio of 
% each component suggests wheter it is a single digit or a couple of 
% digits stuck together. If two digits are connected, a distance transform
% is performed, because probably it has a maximum in the connection point,
% which is used as a reference to divide the image in two. If this maximum
% is quite far from the centre, then the maximum is ignored and the
% image is split along its vertical axis (unless the aspect ratio suggests
% a one is contained in the couple of digits, in that case the high 
% distance from the centre is probably justified).
%
% Finally, for each digit isolated so far, a vertical slice of the image
% along the vertical axis is obtained, and it is counted the number of
% connected components of foreground object contained in it, which is used
% to classify the object.
%
% ============
% Expectations
% ============
% 
% The function should run in definitely less than one minute on the 1200 
% images of the sample data.
% In all our tests it always completed the whole dataset in less than
% 20 seconds (running MATLAB R2016a on a 64 bit Arch Linux installation on
% a machine equipped with an Intel(R) Core(TM) i7-6560U CPU @ 2.20GHz).
% 
% We observed a 1.00 average accurancy over the sample data, so we expect
% an accurancy close to that value as long as the data used for evaluation
% does not have different features (foreground color, orientation, etc.).
% Otherwise, it could change dramatically, because the solution is very
% tailored on the particular features of the specific problem.
%
% =============
% Pros and Cons
% =============
%
% We think the proposed solution has the following advantages:
%  · Extremely easy to implement;
%  · Runs fast (and the code is not optimized, there is a wide margin for 
%    purely numerical optimization);
%
% And disadvantages:
%  · Very problem specific;
%  · Does not scale (e.g. adding different digits is a huge problem 
%    to handle without reconsidering the whole approach);
%  · Some procedures adopted (like filtering) use parameters that are very 
%    sensitive to the features (e.g. foreground color or font thickness)
%    of the data images. Adaptability was sacrificed in favour of
%    accurancy on the given data.
%
% ==============
% Other Attempts
% ==============
% 
% For the filtering and noise removal process, we tried different 
% approaches. The first attempts where obviously with median filtering
% and histogram thresholding, but a median filter with a wide window,
% while being very good at noise removal, may create connections between
% very close objects. Using median filter, we reached 0.98 average 
% accurancy.
%
% We also tried a less aggressive filter combined with erosion (using an 
% horizontal SE to remove bulges from vertical edges), which also worked 
% well (0.97 average accurancy).
%
% At the end we opted for the gaussian + fixed threshold, which is very
% problem dependand, less flexible and very sensitive to changes in the 
% color (which must be black) and thickness of the foreground objects,
% but for this very specific problem it works better.
%
% For the recognition, we tried to add a second feature, a similar scan to 
% also count intersections with the horizontal axis, but it decreased 
% performance (probably due to shreds of foreground object left while 
% separating two connected digits, which interfere).
%
function output = myclassifier(image)
    
    I = double(image);
    
    % Segmentation and noise removal.
    % Gaussian filtering followed by a very aggressive thresholding.
    J = conv2(I, fspecial('gaussian', [6 6], .5), 'same');
    J = J < 1.5; % Fixed threshold.
    
    % Border cleanup.
    % Disconnect some annoying bulges with hit-or-miss transform.
    SE = {
        [-1 -1 -1  1  1
         -1 -1  1  1  1
         -1 -1 -1  1  1]
         
        [-1 -1 -1  1  1
         -1  1  1  1  1
         -1 -1 -1  1  1]
         
        [-1 -1  1  1  1
         -1  1  1  1  1
         -1 -1 -1  1  1]
         
        [-1 -1 -1  1  1
         -1  1  1  1  1
         -1 -1  1  1  1]};
     
     for i = 1:length(SE)
         J = J - bwhitmiss(J, SE{i});
     end

    % Get connected components and related properties
    CC = bwconncomp(J, 4);
    p = regionprops(CC, 'all');
    
    % Get the height of all the connected components
    A = zeros(1, CC.NumObjects);
    BB = {p.BoundingBox};
    for i = 1:CC.NumObjects
        Z = uint32(BB{i});
        A(i) = Z(4);
    end   
    
    % Keep only the biggest ones (whose size is above the average of the
    % six biggest). Do this only if there is high variability in sizes.
    if max(A) > 3 * min(A)
        biggest = sort(A, 'Descend');
        K = find(A > mean(biggest(1:min(length(biggest),6))));
    else
        K = 1:length(A);
    end
    
    % Sort components in horizontal order? Apparently they are already
    % sorted.
    
    % Copy all the components in separate images. Not very efficient, but
    % makes everything easier to follow.
    Components = cell(1, length(K));
    for i = 1:length(K)
        Components{i} = component(CC, p, K(i));
    end
    
    % Black magic here.
    % All the thresholds and magic numbers involved are absolutely
    % arbitrary.
    % The general idea is to look at the intersection between each digit
    % and its vertical axis. If there are two intersections it is a zero,
    % with one intersection it is a one, with three it is a two.
    
    inters = zeros(1,3); % variable for intersections.
    k = 1; % count components
    
    for i = 1:length(Components)
        
        % Variable for the component. Still not efficient (unless the JIT 
        % runtime is able to do some inlining...), but makes everything 
        % more readable.
        segment = Components{i};
        
        % Compute some info about its size.
        width = size(segment,2);
        aspectRatio = width / size(segment,1);
        
        % Use the aspect ratio to guess wether it is a single digit or two
        % sticked digits
        if aspectRatio < .8
            % Single digit
            inters(:, k) = intersections(segment);
            k = k + 1;
        else
            % Two sticked digits
            % Try to separate then looking for a maximum of the distance
            % transform, which hopefully will be in the contact point.
            
            % Add one pixel of zero padding frame around the image.
            % This avoids to have false maxima of the distance transform
            % if a digit is touching the border of the image.
            segment_pad = zeros(size(segment) + [2 2]);
            segment_pad(2:size(segment,1)+1,2:size(segment,2)+1) = segment;
            
            % Distance transform.
            D = bwdist(~segment_pad);
            
            % Get the position [u v] of the maximum.
            [u,v] = ind2sub(size(D), find(D == max(D(:))));
            u = uint32(mean(u)) - 1; % -1 because of the zero-padding.
            v = uint32(mean(v)) - 1;
            
            % If the maximum is unusually far from the centre, then
            % probably it is not the contact point between the digits
            % (unless the aspect ratio suggests that one of the two digits
            % is a one). In that case, ignore the maximum and split the
            % image along its vertical axis.
            if abs(double(v) - width / 2) > width / 4 && aspectRatio > 1.2
                v = floor(width / 2);
            end

            % Split the image and count the intersections in both the
            % halves.
            inters(k) = intersections(segment(:,1:v));
            k = k + 1;
            inters(k) = intersections(segment(:,v:width));
            k = k + 1;
        end
    end
    
    % The actual classification.
    % Convert the number of intersections to the corresponding digit.
    output = arrayfun(@mapResult, inters);
    
    % Emergency exit here.
    % If something went so wrong to have a wrong number of digits, then
    % just return some well-formatted garbage in order to prevent a 
    % possible crash of the test script.
    if length(output) ~= 3
        fprintf('nope\n');
        output = [9 9 9];
    end
end

% Convert the number of vertical intersections in the corresponding digit.
function res = mapResult(x)
    % one
    if x == 1
        res = 1;
    % zero
    elseif x == 2
        res = 0;
    % two, hopefully
    else
        res = 2;
    end
end

% Given the object `CC' representing the connected components, the object
% `P' containig their properties, and an index `k', return a new image 
% containing the `k'-th connected component.
function res = component(CC, p, k)
    BB = {p.BoundingBox};
    BB = uint32(BB{k});  % Get the bounding box.
    I = CC.PixelIdxList; % Get the pixel lists for all the components.
    JJ = zeros(CC.ImageSize); % Create a new black image.
    JJ(I{k}) = 1;             % Set to 1 the pixels of the component `k'.
    res = JJ( BB(2) : BB(2)+BB(4) , BB(1) : BB(1)+BB(3) ); % Slice.
end

% Given an image `I', return a new image containing a vertical slice of
% `I' centered in `c' and of width `w'.
function res = slice(I, c, w)
    d = ceil(w / 2);
    res = I(:,max(1,c-d):c+d);
end

% Given an image `I', return the number of intersections between the
% foreground region and its vertical axis.
function res = intersections(I, c, w)
    if nargin < 3
        w = ceil(size(I,2) / 15);
    end
    if nargin < 2
        c = ceil(size(I,2) / 2);
    end
    S = slice(I, c, w);
    props = bwconncomp(S);
    res = props.NumObjects;
end
