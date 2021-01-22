function MB = perform_wavelet_bandelet_transform(M,Jmin,QT,Theta,dir)

% perform_wavelet_bandelet_transform - perform the wavelet-bandelet transform
%
%   [MB,m_geom] = perform_wavelet_bandelet_transform(M,Jmin,QT,Theta,dir);
%
%   Copyright (c) 2005 Gabriel Peyré

MB = M;
if dir==1
    % perform the wavelet transform
    MB = perform_wavelet_transform(M,1);
end

n = size(M,1); Jmax = log2(n)-1; 
% compute the transform for each scale and each direction
for j=Jmax:-1:Jmin  % for each scale
    for q=1:3   % for each orientation
        if q==1 % 1st quadrant
            selx = 1:2^j; sely = (2^j+1):2^(j+1);
        elseif q==2
            selx = (2^j+1):2^(j+1); sely = 1:2^j;
        else
            selx = (2^j+1):2^(j+1); sely = (2^j+1):2^(j+1);
        end
        MB(selx,sely)= perform_bandelet_transform(MB(selx,sely),QT(selx,sely),Theta(selx,sely),dir);
    end    
end

if dir==-1
    % perform the inverse wavelet transform
    MB = perform_wavelet_transform(MB,-1);
end