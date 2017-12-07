% Inverse_WT -- Inverse wavelet transform for a given wavelet and
% decomposition level
%
%  --> Input  
%    F_WT            J-level wavelet transform of F
%    wavelet_param   cell containing the parameters for a given wavelet
%                    obtained by the function Get_Wavelet_Parameters
%    J               number of decomposition level of the WT
%
%  --> Ouput
%   I_WT             inverse wavelet transform of F_WT
%
%  --> Usage
%   I_WT = Inverse_WT(F_WT,wavelet_param,J)
%
%  See Also
%    Get_Wavelet_Parameters, Forward_WT, IWT2_PO, IWT2_PBS
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function I_WT = Inverse_WT(F_WT,wavelet_param,J)

L = log2(size(F_WT,1)) - J;

if ~wavelet_param{1}
    I_WT = IWT2_PO(F_WT,L,wavelet_param{2});
else
    I_WT = IWT2_PBS(F_WT,L,wavelet_param{2},wavelet_param{3});
end


end
