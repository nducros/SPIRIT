% FWT2   2-D forward wavelet transform
%   W = FWT2(X,J,wpar) produces the 2-D wavelet transform of the 
%   N-by-N image X at decomposition level J, and wpar is a cell
%   containing the parameters of the wavelet basis (typically obtained
%   using GETWAVPAR.m.)
% 
%   FWT2 is an interface between the wavelab850 and the spirit toolbox
%
%   See Also GETWAVPAR, IWT2, FWT2_PO, FWT2_PBS, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function W = fwt2(X,J,wpar)

L = log2(size(X,1)) - J;

% Orthogonal wavelet
if ~wpar{1} 
    W = FWT2_PO(X,L,wpar{2});
% Biorthogonal wavelet
else            
    W = FWT2_PBS(X,L,wpar{2},wpar{3});
end

end