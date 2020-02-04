function [Y, Y2] = datcompn(X, ind, mu, C, v)

ind1 = setdiff(1:size(X,1)*size(X,2),ind)'; % index of missing coefficients

%-- split mean and covariance
C12 = C(ind1,ind);   
C22 = C(ind,ind);
mu1 = mu(ind1);
mu2 = mu(ind);

%-- Noisy data
m = X(ind);        

%-- Init output
Y = zeros(size(X));

%-- Denoising step
y2 = mu2 + C22*((C22 + diag(v))\(m-mu2));
Y(ind) = y2;    % Completion and denoising 
%
if nargout > 1, Y2 = Y; end

%-- Completion step
y = mu1 + C12*(C22\(y2 - mu2));
Y(ind1) = y;

end