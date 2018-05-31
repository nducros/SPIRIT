function out = cr(p,N)
% CR Compression ratio
%   OUT = CR(p,N) computes the compression ratio of a N-by-N image acquired
%   using ABSWP with the percentage set p.
%
%   Example 1:
%   p = [1 1 1 0];              
%   CR(p,64)
%
%   Example 2:
%   p = [1 1 1 1 0];              
%   CR(p,64)
%
%   See also ABSWP, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

J = length(p);
L = log2(N) - J;
w = 0:J-1;
n = 4^L*(1+3*sum(4.^w.*p));

out = 1-n/N/N;