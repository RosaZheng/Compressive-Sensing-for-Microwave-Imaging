function MW = reorder_coefs(M,S,dir)

if dir == 1
    MW=zeros(S(end,:));
    for k=1:size(S,1)-2
        [H,V,D]=detcoef2('a',M,S,k);
        sel=S(end-k,1);
        MW(sel+1:sel*2,1:sel) = H;
        MW(1:sel,sel+1:sel*2) = V;
        MW(sel+1:sel*2,sel+1:sel*2) = D;
    end
    sel=S(1,1);
    MW(1:sel,1:sel)=reshape(M(1:sel*sel),sel,sel);
elseif dir == -1
    MW=zeros(S(end,1)*S(end,2),1);
    for k=1:size(S,1)-2
        sel=S(end-k,1);
        H=M(sel+1:sel*2,1:sel);
        V=M(1:sel,sel+1:sel*2);
        D=M(sel+1:sel*2,sel+1:sel*2);
        sel=S(end-k,1)*S(end-k,2);
        MW(sel+1:sel*2)=H(:);
        MW(sel*2+1:sel*3)=V(:);
        MW(sel*3+1:sel*4)=D(:);
    end
    sel=S(1,1);
    MW(1:sel*sel)=reshape(M(1:sel,1:sel),4,1);
end