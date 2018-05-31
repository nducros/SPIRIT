% WAVDETLOC Location of significant wavelet detail coefficients
%   IND = WAVDETLOC(H,P) returns the location of the largest P percent of 
%   the detail coefficients in H_j, where H_j is a square matrix (typically
%   a one-level wavelet transformed image).
%
%   See also ABSWP, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function ind = wavdetloc(H,p)

%% Wavelet detail coefficients
k_max = size(H,1)/2;

%- Location of detail coefficients
indexmap = zeros(2*k_max,2*k_max);
indexmap(1:k_max,1:k_max) = 1; 
ind_detail = find(indexmap == 0);

%- detail coefficient to sort
coeff_to_sort = H(ind_detail);

%% Sort coefficients
nb_coeff = round(p * 3*k_max*k_max);  
[~,ind] = sort(abs(coeff_to_sort),'descend');
ind = ind(1:nb_coeff); % Retain the first nb_coeff details coefficients
ind = ind_detail(ind); % Obtain the corresponding locations

end