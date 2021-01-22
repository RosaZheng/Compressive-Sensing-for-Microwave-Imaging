function res = isar2d(img,kz_exp)

invData=fftshift(fft2(img));
invData=invData.*conj(kz_exp);
res=ifft2(ifftshift(invData));

