function res = IDCT(x,blkSize)

% res = IDCT(x,blkSize)
%
%   local idct implementation
%
% (c) Zengli Yang 2011

fun = @(block_struct) idct2(block_struct.data);
res = blockproc(x,[blkSize,blkSize],fun);
