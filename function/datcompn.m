% DATCOMPN Data completion for noisy data
%   Y = DATCOMPN(X, C, mu, v) returns an array with the same non-zero 
%   elements as in X but it also fills the zero elements using the 
%   matrix C,the mean mu, and the noise variance v.
%   X can be a N-by-1 vector or a Nx-by-Ny matrix; C is a N-by-N vector, 
%   with N = Nx Ny when X is a matrix; mu ahas the same dimension as X. 
%   Setting mu = 0 is equivalent but faster tha setting mu =
%   zeros(size(X)). v has the same dimension as X.
% 
%   Example 1:
%   Todo!!
%
%   See also DATCOMPN

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 12 Feb 2020
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/

function [Y, Y2] = datcompn(X, C, mu, v, a)

%% Default Arguments
if nargin <5, a = 0; end

%%
%ind1 = setdiff(1:size(X,1)*size(X,2),ind)'; % index of missing coefficients

ind1 = find(X==0);  % index of missing entries
ind2 = find(X~=0);  % index of existing entries

%-- split mean and covariance
C12 = C(ind1,ind2);   
C22 = C(ind2,ind2);

if a~=0, c22 = diag(C22); end 

%%  Denoising Step
%-- Noisy data
m = X(ind2);        
%-- Init output
Y = zeros(size(X));
%
if mu == 0
    fprintf('Noisy completion (assuming zero mean')
    if a==0
        fprintf(', full covariance)\n')
        y2 = C22*((C22 + diag(v))\m);
    elseif a==1
        fprintf(', semi-diagonal covariance)\n')
        y2 = C22*(m./(c22+v));
    elseif  a==2
        fprintf(', diagonal covariance)\n')
        y2 = c22./(c22+v).*m;
    end
    Y(ind2) = y2;    % Completion and denoising 
else
    disp('Noisy completion')
    mu1 = mu(ind1);
    mu2 = mu(ind2);
    if a==0
        y2 = C22*((C22 + diag(v))\(m-mu2));
    elseif a==1
        y2 = C22*((m-mu2)./(c22+v));
    elseif  a==2
        y2 = c22./(c22+v).*(m-mu2);
    end
    Y(ind2) = y2 + mu2;    % Completion and denoising 
end

%
if nargout > 1, Y2 = Y; end

%% Completion step
if mu == 0
    y = C12*(C22\y2);
else
    y = mu1 + C12*(C22\y2);
end
Y(ind1) = y;

end