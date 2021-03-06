function MB = perform_bandelet_transform(M,QT,Theta,dir)

% perform_bandelet_transform - perform the bandelet transform
%
%   [MB,r_geom] = perform_bandelet_transform(M,QT,Theta,dir);
%
%   M is the data (either an image or a bandelet transform)
%   QT and Theta represent the quadtree, and should be computed using
%       [QT,Theta] = compute_quadtree(M,T,j_min,j_max,s);
%
%   MB is the bandelet transform.
%   r_geom is the number bit needed to specity the geometry.   
%
%   Copyright (c) 2005 Gabriel Peyr�

n = size(M,1);
MB = zeros(n);
j_min = min(QT(:)); j_max = max(QT(:));

% display subdivision
for j=j_max:-1:j_min
    for kx=0:n/2^j-1
        for ky=0:n/2^j-1
            selx = kx*2^j+1:(kx+1)*2^j;
            sely = ky*2^j+1:(ky+1)*2^j;
            if QT(kx*2^j+1, ky*2^j+1)==j
                % this is a leaf, transform it
                theta = Theta(kx*2^j+1, ky*2^j+1);
                MB(selx,sely) = perform_warped_wavelet(M(selx,sely),theta,dir); 
            end
        end
    end
end