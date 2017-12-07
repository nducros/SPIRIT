% Predict_triplets -- Function used to predict the location of the
% p_j % significant wavelet coefficients of H_j_WT
%
%  --> Input  
%    H_j_WT  1-level WT of the image on which we want to predict the
%            location of p_j % wavelet coefficient
%    k_max   size of the approximation image k_max x k_max
%    p_j     percentage of the coefficient to retain
%
%  --> Ouput
%   i_j      significant wavelet coefficient location
%
%  --> Usage
%   i_j = Predict_triplets(H_j_WT,k_max,p_j)
%
%  See Also
%    ABS_WP
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function i_j = Predict_triplets(H_j_WT,k_max,p_j)

map_to_eliminate = zeros(2*k_max,2*k_max);
map_to_eliminate(1:k_max,1:k_max) = 1; % Prediction on the detail coefficients only
ind_to_sort = find(map_to_eliminate == 0);
coeff_to_sort = H_j_WT(ind_to_sort); % coeff_to_sort = detail coefficients at j

nb_coeff = round(p_j * 3*k_max*k_max);  
[~,i_j] = sort(abs(coeff_to_sort),'descend');
i_j = i_j(1:nb_coeff); % Retain the first nb_coeff details coefficients
i_j = ind_to_sort(i_j); % Obtain the corresponding locations

end