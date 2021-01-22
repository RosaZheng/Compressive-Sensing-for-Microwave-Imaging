function res = mtimes(a,b)

persistent s;
if a.adjoint
    res = waverec2(b,s,a.wavName);
    res = conj(res);
else
    [res,s] = wavedec2(b,a.wavScale,a.wavName);
end


