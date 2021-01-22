function MW = perform_wavelet_transform(M,dir)

% number of dimension
ndim = length(size(M));
if ndim==2 && ( size(M,2)==1 || size(M,1)==1 )
    ndim=1;
end

% compute biorthogonal wavelet transform
if ndim==1
    temp=log2(length(M));
    if dir ==1
        MW=wavedec(M,temp-1,'haar'); 
    elseif dir == -1
        L=2.^(1:temp);
        L=L(:);
        L=[L(1);L];
        MW=waverec(M,L,'haar');
    end
else
    MW = perform_haar_transform(M,dir);
end