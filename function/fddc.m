% fast denoised data completion

function [Y, Y2] = fddc(X, mu, Wc, ind, ind1, C, v)

%% default
if nargin<4
    % index of acquired coefficients
    ind1 = (X~=0);
end
if nargin<5
    % index of missing coefficients
    ind1 = setdiff(1:size(X,1)*size(X,2),ind)'; 
end

%% Init
%-- split mean
mu1 = mu(ind1);
mu2 = mu(ind);

%-- (noisy) data
y2 = X(ind);        

%% Main function
%-- Init output
Y = X;

%-- Denoising step (if required)
if nargin>5
    z = (C + diag(v))\(y2-mu2);
    y2 = mu2 + C*z;
    Y(ind) = y2;
    %
    if nargout > 1, Y2 = Y; end
       
end
%-- Completion step
y = mu1 + Wc*(y2 - mu2);
Y(ind1) = y;

end