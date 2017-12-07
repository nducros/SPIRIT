% ABS_WP -- Function to simulate the ABS-WP (Adaptive Basis Scan by Wavelet
% 
%  --> Input  
%   data_set    path to a dataset, can be an image used for simulation or
%               an existing experimental dataset (.mat)
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
%   F         image on which to simulate ABS-WP or CCD experimental image
%   F_WT      wavelet transform of F or experimental acquired wavelet transform
%   opt       structure containing the different options and parameters, if
%             some were modified
%
%  --> Usage
%   [F,F_WT,opt] = Read_and_Check_Dataset(data_set,opt)
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/


function [F,F_WT,opt] = Read_and_Check_Dataset(data_set,opt)

%% Default parameters
if ~isfield(opt,'wavelet_name'); opt.wavelet_name = 'LeGall'; end
if ~isfield(opt,'par'); opt.par = 0; end
if ~isfield(opt,'p'); opt.p = [0.9 0.8 0.71 0.02]; end % CR = 80%
if ~isfield(opt,'SPC_simu'); opt.SPC_simu = false; end
if ~isfield(opt,'pattern_folder'); opt.pattern_folder = 'Patterns'; end
if ~isfield(opt,'b'); opt.b = 8; end
if ~isfield(opt,'noise'); opt.noise = false; end


%% Check or read dataset
p_ok = true;
[~,~,ext] = fileparts(data_set);
if strcmp(ext,'.mat') % Experimental file
    % This loads F_WT, wavelet_name, J, tform, F (CCD image), p (default set)
    load(data_set); 
    
    % Check set of percentages
    if  J ~= length(opt.p) || opt.p(J) ~= 0 
        L_p = length(opt.p);
        new_p = zeros(1,J);
        
        if L_p < J
            new_p(1:L_p) = opt.p(1:L_p);
        else
            new_p(1:J-1) = opt.p(1:J-1); % The finest details have not been acquired
        end                              % --> force p(J) to 0
        
        
        opt.p = new_p;
        p_ok = false;
    end
    
    opt.tform = tform; % Mapping SPC to CCD to register the SPC image on the CCD for visual comparison
    opt.wavelet_name = wavelet_name;
    opt.par = par;
    opt.SPC_simu = false; % These are experimental data already  

else % Image file
    
    F = imread(data_set);

    % RGB image ?
    if size(F,3) == 3; F = rgb2gray(F); end
    F = double(F);
    N = size(F,1);   
    
    % F square ?
    if N ~= size(F,2);
        N = min(N,size(F,2)); % Resize to minimum side
        F = imresize(F,[N N]); 
    end
    
    % Size of F = power of 2 ?
    if round(log2(N)) ~= log2(N); % N is not a power of 2
        N = 2^floor(log2(N)); 
        F = imresize(F,[N N]); % Make sure that F is square
    end
    
    if opt.SPC_simu && opt.noise 
        % Set the average number of photons sent by F to N_0
        F = opt.N_0 * F / mean(F(:));
    end   
    
    J = length(opt.p);
    wavelet_param = Get_Wavelet_Parameters(opt.wavelet_name,opt.par);
    F_WT = Forward_WT(F,wavelet_param,J); % Whole WT of F
end

%% Check that given p is a set of percentages
for i = 1:length(opt.p)
   if opt.p(i) < 0
       opt.p(i) = 0;
       p_ok = false;
   elseif opt.p(i) > 1
       opt.p(i) = 1;
       p_ok = false;
   end
end

if ~p_ok
    disp('Given set of percentages not correct. Changed to:');
    disp(opt.p);
end

end