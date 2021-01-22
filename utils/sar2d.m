function img = sar2d(rawData,kz_exp)

newData=fftshift(fft2(rawData));
newData=newData.*kz_exp;
img=ifft2(ifftshift(newData));



