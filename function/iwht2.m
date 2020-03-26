% IWHT2   2-D Inverse Walsh-Hadamard Transform
%   Y = IWHT2(X) is the 2-D inverse Walsh-Hadamard transform of the N-by-N 
%   image X. The inverse transform coefficients are stored in the 
%   N-by-N image Y. 
%
%   Y = IWHT2(X,[],ORDERING) specifies the order of the Walsh-Hadamard
%   inverse transform coefficients. ORDERING can be 'sequency', 'hadamard' 
%   or 'dyadic'. Default ORDERING type is 'sequency'.
%
%   See Also IFWHT FWHT2 SPIRITOPT

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: May 2019
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function Y = iwht2(X,ORDERING)
if nargin==1
    Y = ifwht(ifwht(X)')';
elseif nargin==2
    Y = ifwht(ifwht(X,[],ORDERING)',[],ORDERING)';
end

%- To get unitary transformation
% N = size(X,1);
% Y = Y/N;