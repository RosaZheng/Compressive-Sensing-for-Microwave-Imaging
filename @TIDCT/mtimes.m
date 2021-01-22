function res = mtimes(a,b)

if a.adjoint
	res = IDCT(b,a.blkSize);
else
	res = FDCT(b,a.blkSize);
end


