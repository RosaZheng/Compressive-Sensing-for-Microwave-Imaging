function res = FDCT(x,blkSize)

% res = FDCT(x,blkSize)
%
%   local dct implementation blkSize x blkSize blocks
%
% (c) Zengli Yang 2011

fun = @(block_struct) dct2(block_struct.data);
res = blockproc(x,[blkSize,blkSize],fun);
	
