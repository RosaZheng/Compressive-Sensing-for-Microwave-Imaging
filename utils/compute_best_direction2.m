function [theta,L] = compute_best_direction2(M,T,s)

% compute_best_direction2 - optimize the lagrangian over a single square
%                       for best basis compressive sensing
%
%   [MW,theta] = compute_best_direction2(M,T,s);
%
%   M is a 2D image, s is a super-resolution factor
%       (the # of tested direction is 2*n*s)
%   T is the threshold (the higher, the most you want to compress)
%   theta is the optimal direction, ie. the one that gives minimizes the
%   Lagrangian
%       L(theta) = | M - F_theta(M) |^2 + m * T^2
%   where :
%       F_theta(M) = perform_warped_haar(M,theta,1)
%       m = #{ coefficients of |F_theta(M)| above T }
%
%   Copyright (c) 2011 Zengli Yang

if nargin<3
    s = 2;
end

n = size(M,1);

% samples the direction with a step of pi/(2*n*s)
if s~=Inf
    t = pi/(2*n*s);
    Theta = [t/2:t:pi-t/2, Inf];
else
    % perform exhaustive search
    [Y,X] = meshgrid(0:n-1, 0:n-1); X = X(:); Y = Y(:);
    X(1) = []; Y(1) = [];
    Theta = atan2(Y(:),X(:));
    Theta = unique(Theta);
    Theta = [-Theta(end-1:-1:2); Theta]';
    % take mid points
    Theta = ( Theta + [Theta(2:end),Theta(1)+pi] )/2;
    Theta = [Theta, Inf];
end


% compute the lagrangian
L = []; % to store the lagrangian
for theta = Theta
    MW = perform_warped_wavelet(M,theta,1);
    LT = [];
    for t = T(:)'
        % compute the quantized vector
        MWt= perform_quantization2(abs(MW(:)),t);
        % compute the lagrangian 
        l = sum(MWt(:));
        LT = [LT, l];
    end
    L = [L;LT];
end

% find minimum of lagrangian
[L,I] = min(L); L = L(:);
theta = Theta(I); theta = theta(:);