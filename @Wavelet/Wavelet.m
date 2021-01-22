function res = Wavelet(wavName, wavScale)
% res = Wavelet(wavName, wavScale)
%
% implements a wavelet operator
%
% (c) Zengli Yang 2011

res.adjoint = 0;
res.wavName = wavName;
res.wavScale = wavScale;
res = class(res,'Wavelet');
