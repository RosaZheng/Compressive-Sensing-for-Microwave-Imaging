function res = fft2c(x)

% res = fft2c(x)
% 
% orthonormal forward 2D FFT
%
% (c) Zengli Yang 2011

%res = 1/sqrt(length(x(:)))*fftshift(fft2(ifftshift(x)));
%res = 1/sqrt(length(x(:)))*fftshift(fft2(x));
res = 1/sqrt(length(x(:)))*fftshift(fft2(x)); % centered 2D FFT
%res=fft2(x);

