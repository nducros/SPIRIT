% FWHT2   2-D Forward Walsh-Hadamard Transform
%   Y = FWHT2(X) is the 2-D forward Walsh-Hadamard transform of the N-by-N 
%   image X. The transform coefficients are stored in the N-by-N image Y. 
% 
%   Y = FWHT2(X,[],ORDERING) specifies the order of the Walsh-Hadamard
%   transform coefficients. ORDERING can be 'sequency', 'hadamard' or 
%   'dyadic'. Default ORDERING type is 'sequency'.
%
%   See Also IWHT2 FWHT HADPATMAT SPIRITOPT

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Dec 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function Y = fwht2(X,ORDERING)
if nargin==1
    Y = fwht(fwht(X)')';
elseif nargin==2
    Y = fwht(fwht(X,[],ORDERING)',[],ORDERING)';
end
%- To get unitary transformation
% N = size(X,1);
% Y = Y*N;