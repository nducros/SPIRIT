function Y = datcomp(X, C, mu)
% DATCOMP Data completion
%   Y = DATCOMP(X, C, mu) fills the zero elements in X using the covariance
%   matrix C and the mean mu. The argument X can be a N-by-1 vector or a 
%   Nx-by-Ny matrix; C is a N-by-N vector, with N = Nx Ny when X is a 
%   matrix; mu has the same dimension as X. By default, mu is assumed to be
%   zero.
%
%   The completion approach is described in [1].
% 
%   Example 1:
%   Todo!!
%
%   [1] N. Ducros, A Lorente Mur, F Peyrin. 'A completion network for 
%   reconstruction from compressed acquisition', IEEE ISBI, 2020.

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 12 Feb 2020
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/


%%
ind1 = find(X==0);  % index of missing entries
ind2 = find(X~=0);  % index of existing entries

C12 = C(ind1,ind2);   
C22 = C(ind2,ind2);

y2 = X(ind2);

%% Completion of missing entries
if nargin == 3
    disp('Completion')
    mu1 = mu(ind1);
    mu2 = mu(ind2);
    y = mu1 + C12*(C22\(y2 - mu2));
elseif nargin == 2
    disp('Completion (assuming zero mean)')
    y = C12*(C22\y2);
end

%% Output full array
Y = X;
Y(ind1) = y;

end