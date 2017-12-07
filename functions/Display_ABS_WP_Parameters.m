% Display_ABS_WP_Parameters -- Function used to display the chosen
% parameters for the ABS_WP strategy.
%
%  --> Input  
%   opt         structure containing the different options and parameters
%                - opt.wavelet_name : wavelet to be used, see
%                  Get_Wavelet_Parameters for details
%                - opt.par : additional parameters for certain wavelet
%                  giving the number of vanishing moments
%                - opt.p = [p_J,...,p_1] : set of percentages
%                - opt.SPC_simu : boolean to specify wether the acquisition 
%                  of the wavelet coefficients should be performed exactly 
%                  as it would be by the SPC or not.
%                - opt.noise : boolean to apply Poisson noise the
%                measurements
%                - opt.Delta_t : collection time at the detector (s)
%                - opt.N_0 : number of average photons emitted by the 
%                object in one sec (ph/s)
%
%  --> Ouput
%    no output, display on the Matlab's console the chosen parameters
%
%  --> Usage
%   Display_ABS_WP_Parameters(opt)
%
%  See Also
%    ABS_WP, Read_and_Check_Dataset
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/19/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function Display_ABS_WP_Parameters(opt)
    
fprintf('------------------------- ABS-WP parameters -------------------------\n');

if strcmp(opt.wavelet_name,'Db') + strcmp(opt.wavelet_name,'Battle') > 0
    fprintf('Chosen wavelet: %s with %d vanishing moments\n',opt.wavelet_name,opt.par);
else
    fprintf('Chosen wavelet: %s\n',opt.wavelet_name);
end

fprintf('Decomposition level J = %d with set of percentages p =\n',length(opt.p));
disp(opt.p);

if opt.SPC_simu
   fprintf('Dot product simulation and quantization of the pattern ON with b = %d\n',opt.b);
   fprintf('Patterns will be stored in ''%s''\n',opt.pattern_folder);
   
   if opt.noise
      fprintf('Poisson noise ON with N0 = %d ph/s and collection time = %0.3f s\n',opt.N_0,opt.Delta_t); 
   end
end

fprintf('---------------------------------------------------------------------\n\n');
end

