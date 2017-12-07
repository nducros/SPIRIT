% Create_Pattern_Indexing_map -- Function used to create a map affecting a
% different index to each wavelet pattern (coefficient) in the order
% obtained with the E_map from Create_E_map.
%
%  --> Input  
%    E_map   map giving the different values of the areas of the wavelet
%            transform, see Create_E_map
%    nb_e    # of areas = 3*J (3 details per level) + 1 (approximation)
%
%  --> Ouput
%    PI_map  map giving the pattern index for each wavelet coefficient
%
%  --> Usage
%    PI_map = Create_Pattern_Indexing_map(E_map,nb_e)
%
%  See Also
%    Create_Pattern_map, Create_E_map, Create_and_Save_Wavelet_Patterns
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function PI_map = Create_Pattern_Indexing_map(E_map,nb_e)

PI_map = zeros(size(E_map));
pattern_cpt = 1;
for n = nb_e:-1:1 % For each areas of the E_map
    
    ind = find(E_map == n);
    PI_map(ind) = pattern_cpt:pattern_cpt+length(ind)-1; % Assign new indices
    pattern_cpt = pattern_cpt + length(ind);
    
end

end
