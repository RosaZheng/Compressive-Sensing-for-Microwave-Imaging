function  res = p2DFT(mask,gate)

%res = p2DFT(mask,imSize [ ,phase,mode])
%
%
%	Implementation of partial Fourier operator.
%	
%	input:
%			mask - 2D matrix with 1 in entries to compute the FT and 0 in ones tha
%				are not computed.
%			imSize - the image size (1x2)
%			phase - Phase of the image for phase correction
%			mode - 1- real, 2-cmplx
%
%	Output:
%			The operator
%
%	(c) Michael Lustig 2007


res.gate = gate;
res.adjoint = 0;
res.mask=mask;
res = class(res,'p2DFT');

