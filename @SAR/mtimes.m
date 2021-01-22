function res = mtimes(a,b)
% res = mtimes(FT, x)
%
dx=a.dx;
dy=a.dy;
h=a.h;
f=a.f;
epr=a.epr;

if a.adjoint
    [res,~] = isar(b,dx,dy,h,f,epr);
else
    [res,~] = sar(b,dx,dy,h,f,epr);
end



    
