% HADPATMAT Create a matrix containing 2D Hadamard patterns.
%   Q = HADPATMAT(N) produces a D-by-D matrix Q that contains the Hadamard
%   patterns where D = N^2.
%
%   Q = HADPATMAT(N,IND) produces a I-by-D matrix Q that contains only the 
%   Hadamard patterns whose index are specified by the vector IND of length I.
%
%   Example: Create all the 4x4 Hadamard patterns
%   -------
%   N = 4;  
%   Q = hadpatmat(N);
%   figure; 
%   for ii=1:N^2
%       subplot(4,4,ii); 
%       imagesc(reshape(Q(ii,:),N,N)); axis image; colorbar
%   end
% 
%   Example: Create three 32x32 Hadamard patterns
%   -------
%   ind = [1,2,5];
%   N = 32;  
%   Q = hadpatmat(N,ind);
%   figure; 
%   subplot(131); imagesc(reshape(Q(1,:),N,N)); axis image;
%   subplot(132); imagesc(reshape(Q(2,:),N,N)); axis image;
%   subplot(133); imagesc(reshape(Q(3,:),N,N)); axis image;
%
%   See also FWHT2, IWHT2, SPC, SPIRITOPT

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 29 Nov 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function Q = hadpatmat(N,ind)
%% Init
D = N*N;
if nargin == 1, ind = 1:D; end
I = length(ind);
fprintf('Generating %d / %d Hadamard patterns\n',I,D);

Q = zeros(I,D);
Z = zeros(N);


%% Patterns from inverse hadamard transform
for i = 1:I
    % Set to 1 the location for which you want the pattern
    Z(ind(i)) = 1;          
    pattern = iwht2(Z); 
    Q(i,:) = pattern(:);

    % reinit for next pattern
    Z(ind(i)) = 0;
end  

%% TODO (much faster). Use hadamard(N^2) and reindex.

