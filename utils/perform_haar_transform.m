function MW = perform_haar_transform(M,dir)

persistent S;
if dir==1
    [MW,S] = wavedec2(M,log2(size(M,1))-1,'haar');
    MW = reorder_coefs(MW,S,dir);
elseif dir==-1
    M = reorder_coefs(M,S,dir);
    MW = waverec2(M,S,'haar');
end

