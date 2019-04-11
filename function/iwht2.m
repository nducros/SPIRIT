% IWHT2   2-D Inverse Walsh-Hadamard Transform
%   Y = FWT2(X) is the 2-D inverse Walsh-Hadamard transform of the N-by-N 
%   image X. The inverse transform coefficients are stored in the 
%   N-by-N image Y. 
%
%   See Also IFWHT FWHT FWHT2 SPIRITOPT

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Dec 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function Y = iwht2(X)
    Y = ifwht(ifwht(X)')';
    %- To get unitary transformation
    % N = size(X,1);
    % Y = Y/N;
end

