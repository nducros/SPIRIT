% Get_Wavelet_Parameters -- Returns a cell containing several parameters
% for a given wavelet name as input. This function needs the Wavelab850
% toolbox (http://statweb.stanford.edu/~wavelab/)
%
%  --> Input  
%    par             additional parameter for certain wavelets, see below
%    wavelet_name    string giving the wavelet name
%                    Choices are : 
%                       - 'Haar'
%                       - 'Db' with par vanishing moments (possible values 
%                          for par = 2,3,4,5,6,7,8,9,10)
%                       - 'Battle' with par vanishing moments (possible values 
%                          for par = 2,4,6)
%                       - 'LeGall' for CDF 2.2 (CDF 5/3)
%                       - 'CDF' for CDF 4.4 (CDF 9/7)
%
%  --> Ouput
%    wavelet_param   wavelet_parameters{1} contains either 0 (orthogonal wavelet) or 1 (biorthogonal)
%                    wavelet_parameters{2} contains the filter h
%                    wavelet_parameters{3} contains the dual filter of h for biorthogonal wavelets   
%
%  --> Usage
%    wavelet_param = Get_Wavelet_Parameters(wavelet_name,par)
%
%  See Also
%    MakeONFilter, MakeBSFilter, Forward_WT, Inverse_WT
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function wavelet_param = Get_Wavelet_Parameters(wavelet_name,par)

%% Orthogonal wavelets
if strcmp(wavelet_name,'Haar') + strcmp(wavelet_name,'Db') + strcmp(wavelet_name,'Battle') > 0  
   
    wavelet_param = cell(1,2);
    wavelet_param{1} = 0; 
    
    if strcmp(wavelet_name,'Haar')
        wavelet_param{2} = MakeONFilter('Haar');
    elseif strcmp(wavelet_name,'Db')
        
        if ismember(par,[2,3,4,5,6,7,8,9,10])
            wavelet_param{2} = MakeONFilter('Daubechies',par*2);
        else
            error(['par = ' num2str(par) ' is not a valid parameter for ' wavelet_name ' wavelet']);
        end
        
    else
        if ismember(par,[2,4,6])
            wavelet_param{2} = MakeONFilter('Battle',par-1);
        else
            error(['par = ' num2str(par) ' is not a valid parameter for ' wavelet_name ' wavelet']);
        end
    end
    
%% Biorthogonal wavelet    
elseif strcmp(wavelet_name,'LeGall') + strcmp(wavelet_name,'CDF') > 0
    
    wavelet_param = cell(1,3);
    wavelet_param{1} = 1; % Biorthogonal wavelet
    
    if strcmp(wavelet_name,'LeGall')
        [wavelet_param{2},wavelet_param{3}] = MakeBSFilter('CDF',[2 2]);
    else
        [wavelet_param{2},wavelet_param{3}] = MakeBSFilter('CDF',[4 4]);
    end
else
    error([wavelet_name ' is not a valid wavelet name']);
end

end