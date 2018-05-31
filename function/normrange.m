function G = normrange(F,r)
% NORMRANGE Normalize in a range.
%   G = NORMRANGE(F) produces the image G by normalizing the image F in the
%   range 0 to 1.
%
%   G = NORMRANGE(F,r) produces the image G by rescaling F in the range 
%   specified by the two-element vector r. The image G is such that 
%   min(G(:)) = r(1) and max(G(:)) = r(2).
%
%   Example 1:
%   F = 0.1*rand(5,3),              
%   G = normrange(F),
%
%   Example 2:
%   F = 0.1*rand(5,3),              
%   G = normrange(F,[2,4]),
%
%   See also SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

%% Default
if nargin==1
    r(1)=0;
    r(2)=1;
end

%% Main
M = max(F(:));
m = min(F(:));
G = (F - m) / (M - m); % 0 to 1 values
G = G * (r(2) - r(1)) + r(1); % range(1) to range(2) values

end

