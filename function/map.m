% MAP Orientation-scale wavelet quandrant maps
%   I = map(N,J) produces a N-by-N matrix I that contains increasing 
%   indices for increasing orientations (horizontal, vertical, diagonal) 
%   and incresing resolutions.
% 
%   [I,OS] = map(N,J) also returns a N-by-N matrix OS that indicates the 
%   location of the different orientations-scale wavelet quadrants.
% 
%   [I,OS,n] = map(N,J) also returns the number of orientations-scale 
%   quadrants.
%
%    Example:
%   [I,OS,n] = map(64,3);
%   figure; 
%   subplot(121); imagesc(OS); axis image; colorbar; colormap(jet)
%   subplot(122); imagesc(I); axis image; colorbar;
%   
%   See also SAVEPATSPLIT, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function [I,OS,n] = map(N,J)

%% init output
OS  = zeros(N,N,'uint8');
I = zeros(size(OS));

%% number of orientation-scale quadrants
n = 3*J + 1;    % 3*J for details + 1 for approximation at J

%% compute the oriention-resolution map
R = log2(N);
cpt = n;

for j = J:-1:1
    
    l = R - j;
    k_max = 2^l; % k_max * k_max = size of the approximation image at j
    ind = uint16(1:k_max);
    [y,x] = meshgrid(ind,ind); % Indices of the approximation at level j
    
    if j == J   % Approximation at level J
        OS(y,x) = cpt;
        cpt = cpt - 1;
    end

    % Details for each level
    OS(y,x+k_max) = cpt; % Horizontal
    cpt = cpt - 1;
    
    OS(y+k_max,x) = cpt; % Vertical
    cpt = cpt - 1;
    
    OS(y+k_max,x+k_max) = cpt; % Diagonal
    cpt = cpt - 1;
end

%% compute index map
pattern_cpt = 1;

for q = n:-1:1 % For each quadrant of the E_map    
    ind = find(OS == q);
    I(ind) = pattern_cpt:pattern_cpt+length(ind)-1; % Assign new indices
    pattern_cpt = pattern_cpt + length(ind);   
end

end