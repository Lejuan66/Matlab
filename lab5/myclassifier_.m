function output = myclassifier(image)
    I = image;
    
    % noise removal
    J = ~imerode(~I, strel('line', 4, pi/4));
    %J = medfilt2(J, [5 5]);

    % binary
    thresh = multithresh(double(J));
    J = J < thresh;

    % get connected components and related properties
    CC = bwconncomp(J);
    p = regionprops(CC, 'all');
    
    % filter components whose size is above average
    %A = [p.ConvexArea];
    
    A = zeros(1, CC.NumObjects);
    BB = {p.BoundingBox};
    for i = 1:CC.NumObjects
        Z = uint32(BB{i});
        A(i) = Z(4);
    end   
     
    if max(A) > 3 * min(A)
        K = find(A > mean(A(:)));
    else
        K = 1:length(A);
    end

    
    % sort components in horizontal order
    % TODO
    
    % get components
    Components = {};
    for i = 1:length(K)
        Components{i} = component(CC, p, K(i));
    end

    
%     for i = 1:length(Components)
%         figure; imagesc(Components{i}); axis image
%         figure; imagesc(slice_h(Components{i})); axis image
%     end
%     return
    
    % black magic
    inters = zeros(2,3);
    k = 1;
    for i = 1:length(Components)
        R = Components{i};
        if width(R) / height(R) < .8
            inters(:, k) = intersections(R);
            k = k + 1;
            
            %figure; imagesc(S);
        else
            D = bwdist(~J);
            
            s = floor(width(R) / 4);
            s = [s 3*s];
            
            S1 = slice_v(R, s(1));
            props = bwconncomp(S1);
            inters_h(k) = props.NumObjects;
            k = k + 1;
            
            S2 = slice_v(R, s(2));
            props = bwconncomp(S2);
            inters_h(k) = props.NumObjects;
            k = k + 1;
            
            %figure; imagesc(S1);
            %figure; imagesc(S2);
        end
    end
    
    output = cellfun(@mapResult, {inters(:,1) inters(:,2) inters(:,3)});
    
    % FIXME debug check
    if length(output) ~= 3
        fprintf('nope\n');
        output = [1 1 1];
    end
end

function res = mapResult(x)
    % one
    if x(1) == 1 && x(2) == 1
        res = 1;
    % zero
    elseif x(1) == 2 && x(2) == 2
        res = 0;
    % maybe one
    elseif x(1) == 1 && x(2) == 2
        res = 1;
    % two
    else
        res = 2;
    end
end
    
function res = component(CC, p, k)
    BB = {p.BoundingBox};
    BB = uint32(BB{k});
    I = CC.PixelIdxList;
    JJ = zeros(CC.ImageSize);
    JJ(I{k}) = 1;
    res = JJ(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3));
end

function res = slice_v(I, c, w)
    if nargin < 3
        w = ceil(width(I) / 15);
    end
    if nargin < 2
        c = floor(width(I) / 2);
    end
    d = ceil(w / 2);
    res = I(:,c-d:c+d);
end

function res = slice_h(I, c, w)
    if nargin < 3
        w = ceil(height(I) / 15);
    end
    if nargin < 2
        c = floor(height(I) / 2);
    end
    d = ceil(w / 2);
    res = I(c-d:c+d,:);
end

function res = intersections(R)
        Sv = slice_v(R);
        Sh = slice_h(R);
        propsv = bwconncomp(Sv);
        propsh = bwconncomp(Sh);
        res = [propsh.NumObjects propsv.NumObjects];
end

% plot segments and centroids
%  J: image
%  p: properties
%  K: region indices
function plotRegions(J, p, K)
    figure;
    imagesc(J); axis image; axis off;
    hold on;
    c = [p.Centroid];
    for k = K
        plot(c(1+2*(k-1)), c(2*k), 'g+', 'MarkerSize', 10, 'LineWidth', 2);
    end
    hold off;
end

function x = width(A)
    x = size(A,2);
end

function x = height(A)
    x = size(A,1);
end