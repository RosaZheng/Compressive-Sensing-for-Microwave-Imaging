function y = perform_quantization2(x, T)

% perform_quantization2 - perform a nearly uniform quantization of the signal.
%                           for best basis compressed sensing
%
%   [y, nbr_bits, nbr_bits_tot, y_quant] = perform_quantization2(x, T);
%
%   The quantizer is defined by y=Q_T(x) where:
%       Q_T(x) = x^2/2    if  |x|<T
%       Q_T(x) = T*|x|-T^2/2      otherwise
%
%   y is the quantified value
%   nbr_bit as same size as x and store the number of bits needed to code
%       each entry of x
%   nbr_bits_tot is just sum(nbr_bits_tot(:))
%   y_quant is the signed token representing each entry of y.
%
%   Copyright (c) 2011 Zengli Yang

I = find(abs(x)<T);
y = T*abs(x)-T*T/2;
y(I) = x(I).*x(I)/2;