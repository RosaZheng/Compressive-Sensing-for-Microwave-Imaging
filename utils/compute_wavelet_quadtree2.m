function [QT,Theta] = compute_wavelet_quadtree2(M,Jmin,T,j_min,j_max,s, use_single_qt)

% compute_wavelet_quadtree - compute the wavelet-bandelet quadtree
%                               for best basis compressed sensing
%
%   [QT,Theta] = compute_wavelet_quadtree2(M,Jmin,T,j_min,j_max,s, use_single_qt);
%
%   Copyright (c) 2011 Zengli Yang

n = size(M,1); 
nT = length(T);

% perform the wavelet transform
MW = perform_wavelet_transform(M,1);

Jmax = log2(n)-1;
QT = zeros(n,n,nT);
Theta = zeros(n,n,nT);

% compute the transform for each scale and each direction
for j=Jmax:-1:Jmin  % for each scale
    j_max = min(j_max, j);
    if use_single_qt
        MWc = zeros(2^j, 2^j, 3);
    end
    for q=1:3   % for each orientation
        [selx,sely] = compute_quadrant_selection(j,q);
        %disp(['--> computing quadtree at scale ' num2str(j) ' orientation ' num2str(q) '.']);
        if ~use_single_qt
            [QT(selx,sely,:),Theta(selx,sely,:)] = compute_quadtree2(MW(selx,sely),T,j_min,j_max,s);
        else
            MWc(:,:,q) = MW(selx,sely);
        end
    end
    if use_single_qt
        [QTc,Thetac] = compute_quadtree2(MWc,T,j_min,j_max,s);
        for q=1:3   % for each orientation
            [selx,sely] = compute_quadrant_selection(j,q);
            QT(selx,sely,:) = QTc;
            Theta(selx,sely,:) = Thetac;
        end
    end
end