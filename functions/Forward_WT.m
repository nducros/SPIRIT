% Forward_WT -- Generates the 2D wavelet transform of F for a given wavelet
% and a given decomposition level.
%
%  --> Input  
%    F               image of size NxN
%    wavelet_param   cell containing the parameters for a given wavelet
%                    obtained by the function Get_Wavelet_Parameters
%    J               number of decomposition level of the WT
%
%  --> Ouput
%   F_WT             J-level wavelet transform of F
%
%  --> Usage
%   F_WT = Forward_WT(F,wavelet_param,J)
%
%  See Also
%    Get_Wavelet_Parameters, Inverse_WT, FWT2_PO, FWT2_PBS
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function F_WT = Forward_WT(F,wavelet_param,J)

L = log2(size(F,1)) - J;

if ~wavelet_param{1} % Orthogonal wavelet
    F_WT = FWT2_PO(F,L,wavelet_param{2});
else % Biorthogonal wavelet
    F_WT = FWT2_PBS(F,L,wavelet_param{2},wavelet_param{3});
end


end