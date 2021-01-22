function res = ifft2c(x)
%
%
% res = ifft2c(x)
% 
% orthonormal centered 2D ifft
%
% (c) Zengli Yang 2011

%res = sqrt(length(x(:)))*ifftshift(ifft2(fftshift(x)));
%res = sqrt(length(x(:)))*ifft2(ifftshift(x));
res = sqrt(length(x(:)))*ifft2(ifftshift(x)); % centered 2D ifft
%res=ifft2(x);  
