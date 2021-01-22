%   best bandelet basis compressive sensing
%
%   Copyright (c) 2011 Zengli Yang

function img_rec = best_basis_bandelet(M,FT,t,s,maxN,Jmin,use_single_qt)

% generate Fourier/Identity sampling operator and data
MF = FT*M;

% parameter for computing wavelet quadtree
j_min = 2;  % minimum square 2^j_min
j_max = 4;   % maximum square 2^j_max

% initialization
f_image=zeros(size(M));
mu=1;

% do iterations
for n=1:maxN
    % update the estimate
    f_temp=FT'*(MF-FT*f_image);
    f_tilt=f_image+1/mu*f_temp; 

    % update best basis
    [QT,Theta] = compute_wavelet_quadtree2(f_tilt,Jmin,t,j_min,j_max,s,use_single_qt);

    % denoise the estimate
    f_temp=perform_wavelet_bandelet_transform(f_tilt,Jmin,QT,Theta,1);
    f_temp=max(0,1-t/mu./abs(f_temp)).*f_temp;
    f_temp=perform_wavelet_bandelet_transform(f_temp,Jmin,QT,Theta,-1);
    yita=norm(f_image-f_temp);
    f_image=f_temp;
    t=t*0.8;
    disp([num2str(n),'  Update difference is ',num2str(yita)]);
end
img_rec=f_image;



