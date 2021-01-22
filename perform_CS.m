function [img_rec,pctg_rec] = perform_CS(img,transform,pctg,param_input)
%PERFORM_CS implements compressive sensing image reconstruction
%
%   (c) Zengli Yang 2011

img = im2double(img);
factor = max(abs(img(:)));
img = img/factor;
[nx,ny] = size(img);
pctg_rec=pctg;

% param_input.saDomain  
% 0 - sampling image itself, 1 - sampling Fourier domain 

% generate Fourier/Identity sampling operator and data
FT = p2DFT(param_input.mask,2-param_input.saDomain);  
img_ft = FT*img;
img_init = FT'*img_ft;

switch transform
    case 'Identity'
        XFM=1;  % identity transform
    case 'FFT'
        XFM = p2DFT(ones(nx,ny),1); % FFT
    case 'Wavelet'
        XFM = Wavelet(param_input.waveletBasis,param_input.waveletScale);
    case 'DCT'
        XFM = TIDCT(param_input.blocksize);		% Local DCT - blocksize
    case 'Bandelet'  % use haar wavelet
        img_rec = best_basis_bandelet(img,FT,param_input.tBand, ...
                      param_input.sBand, param_input.maxNBand, param_input.Jmin,...
                      param_input.single_qt);
        img_rec = img_rec*factor;
        return;
    case 'SAR'
        XFM=SAR(param_input.kz_exp);        
end

%parameters for CS recon
TVWeight = param_input.TVWeight;
xfmWeight = param_input.xfmWeight;
Itnlim = param_input.Itnlim;
maxN = param_input.maxN;	% repeat each recon many times while reducing lambda

% initialize Parameters for reconstruction
param = init;
param.FT = FT;   % undersampling matrix
param.XFM = XFM;
param.TV = TVOP;
param.data = img_ft;  % partial sampling(FFT or Identity) coefficients
param.TVWeight =TVWeight;     % TV penalty 
param.xfmWeight = xfmWeight;  % L1 wavelet penalty
param.Itnlim = Itnlim;

img_xfm=XFM*img_init;

% do iterations
for n=1:maxN
	img_xfm = fnlCg(img_xfm,param);
	param.TVWeight = param.TVWeight*0.8;  % decrease Lambda every iteration
	param.xfmWeight = param.xfmWeight*0.8;
end

img_rec=XFM'*img_xfm;

img_rec = img_rec*factor;
if isreal(img)
    img_rec=real(img_rec);
end

