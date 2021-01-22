function res = mtimes(a,b)
% res = mtimes(FT, x)
%

if a.adjoint
    res=b.*a.mask;
    if a.gate
        res = ifft2c(res);
    end
else
    if a.gate
        b = fft2c(b);
    end
    res=b.*a.mask;
end



    
