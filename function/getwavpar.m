% GETWAVPAR Return wavelet parameters as defined in the Wavelab850 toolbox.
%   wpar = getwavpar(wav,par) returns a cell array wpar, where wpar{1} is 0
%   for orthogonal wavelets and 1 for biorthogonal wavelets, wpar{2} 
%   contains the high-pass wavelet filter h, and wpar{3} contains the dual
%   of filter h (for biorthogonal wavelets only). Typically, wpar is used
%   as an input parameter for FWT2.m and IWT2.m.
%
%   wav is one of the following strings, which specifies the wavelet basis:
%   'Haar', 'Db', 'Battle', 'LeGall', 'CDF'. See GETWAVELETPARAM.m for 
%   details.
%
%   par is an integer that indicates the number of vanishing moments. For 
%   wav = 'Db', par is one of 2,3,4,5,6,7,8,9, or 10. For wav = 'Battle', 
%   par is one of 2,4, or 6. See MAKEONFILTER.m for details.
%
%   See also MAKEONFILTER, MAKEBSFILTER, FWT2, IWT2, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/


function wpar = getwavpar(wav,par)

%% Orthogonal wavelets
if strcmp(wav,'Haar') + strcmp(wav,'Db') + strcmp(wav,'Battle') > 0  
   
    wpar = cell(1,2);
    wpar{1} = 0; 
    
    if strcmp(wav,'Haar')
        wpar{2} = MakeONFilter('Haar');
    elseif strcmp(wav,'Db')
        
        if ismember(par,[2,3,4,5,6,7,8,9,10])
            wpar{2} = MakeONFilter('Daubechies',par*2);
        else
            error(['par = ' num2str(par) ' is not a valid parameter for ' wav ' wavelet']);
        end
        
    else
        if ismember(par,[2,4,6])
            wpar{2} = MakeONFilter('Battle',par-1);
        else
            error(['par = ' num2str(par) ' is not a valid parameter for ' wav ' wavelet']);
        end
    end
    
%% Biorthogonal wavelet    
elseif strcmp(wav,'LeGall') + strcmp(wav,'CDF') > 0
    
    wpar = cell(1,3);
    wpar{1} = 1; % Biorthogonal wavelet
    
    if strcmp(wav,'LeGall')
        [wpar{2},wpar{3}] = MakeBSFilter('CDF',[2 2]);
    else
        [wpar{2},wpar{3}] = MakeBSFilter('CDF',[4 4]);
    end
else
    error([wav ' is not a valid wavelet name']);
end

end