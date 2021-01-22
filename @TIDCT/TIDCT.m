function res = TIDCT(blkSize)
% res = TIDCT(blkSize)
% 
% Implements a segmented DCT operator
%
% (c) Zengli Yang 2011

res.adjoint = 0;
res.blkSize = blkSize;
res = class(res,'TIDCT');
