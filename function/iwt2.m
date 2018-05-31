% IWT2   2-D inverse wavelet transform
%   
%   X = IWT2(W,J,wpar) produces the inverse wavelet transform of the  
%   N-by-N image wc at decomposition level J, and wpar is a cell containing
%   parameters of the wavelet basis (typically obtained using GETWAVPAR.m).
% 
%   IWT2 is an interface between the wavelab850 and the spirit toolbox
%
%   Example:
%
%   See Also GETWAVPAR, FWT2, IWT2_PO, IWT2_PBS, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function X = iwt2(W,J,wpar)

L = log2(size(W,1)) - J;

if ~wpar{1}
    X = IWT2_PO(W,L,wpar{2});
else
    X = IWT2_PBS(W,L,wpar{2},wpar{3});
end


end
