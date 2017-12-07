% Create_E_map -- Function used to create a map affecting a different value
% to the different areas of the wavelet transform. For instance, the
% approximation area will have the value "nb_e" and the horizontal, vertical
% and diagonal areas at j = J will have the value nb_e-1, nb_e-2 and nb_e-3.
% This is useful for indexing the patterns in Create_Pattern_Indexing_map.
%
%  --> Input  
%    N      size of the patterns N x N
%    J      maximum decomposition level of the wavelet transform
%
%  --> Ouput
%    E_map   map giving the different values of the areas of the wavelet
%            transform
%    nb_e    # of areas = 3*J (3 details per level) + 1 (approximation)
%
%  --> Usage
%   [E_map,nb_e] = Create_E_map(N,J)
%
%  See Also
%    Create_Pattern_map, Create_Pattern_Indexing_map, Create_and_Save_Wavelet_Patterns
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function [E_map,nb_e] = Create_E_map(N,J)

R = log2(N);
E_map = zeros(N,N,'uint8');

nb_e = 3*J + 1; % 3*J details + 1 approximation at J
cpt = nb_e;
for j = J:-1:1
    
    l = R - j;
    k_max = 2^l; % k_max * k_max = size of the approximation image at j
    ind = uint16(1:k_max);
    [y,x] = meshgrid(ind,ind); % Indices of the approximation at level j
    
    if j == J   % Approximation at level J
        E_map(y,x) = cpt;
        cpt = cpt - 1;
    end

    % Details for each level
    E_map(y,x+k_max) = cpt; % Horizontal
    cpt = cpt - 1;
    
    E_map(y+k_max,x) = cpt; % Vertical
    cpt = cpt - 1;
    
    E_map(y+k_max,x+k_max) = cpt; % Diagonal
    cpt = cpt - 1;
end

end

