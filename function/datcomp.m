function Y = datcomp(X, C, mu)
%% DATCOMP Data completion
%   Y = DATCOMP(X, C, MU) fills the zero elements in X using the covariance
%   matrix C and the mean MU. The argument X can be a N-by-1 vector or a 
%   Nx-by-Ny matrix; C is an N-by-N matrix, with N = Nx*Ny when X is a 
%   matrix; MU is an N-by-1 vector. By default, MU is assumed to be
%   zero.
%
%   The completion approach is described in [1].
% 
%   Example: see script below
%
%   See also MAIN_COMPLETION_STL10
%
%   [1] N. Ducros, A Lorente Mur, F Peyrin. 'A completion network for 
%   reconstruction from compressed acquisition', IEEE ISBI, 2020.
%   PDF: https://hal.archives-ouvertes.fr/hal-02342766/

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 01 Apr 2020
%   Toolbox: SPIRiT 2.1 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/


%% Split entries
ind1 = find(X==0);  % index of missing entries
ind2 = find(X~=0);  % index of existing entries

C12 = C(ind1,ind2);   
C22 = C(ind2,ind2);

y2 = X(ind2);

%% Completion of missing entries
if nargin == 3
    mu1 = mu(ind1);
    mu2 = mu(ind2);
    y = mu1 + C12*(C22\(y2 - mu2));
elseif nargin == 2
    y = C12*(C22\y2);
end

%% Output full array
Y = X;
Y(ind1) = y;

end