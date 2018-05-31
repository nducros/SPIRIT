% SAVEPATSPLIT Save patterns obtained from the splitting method
%   opt = SAVEPATSPLIT(opt) create DMD patterns by splitting the patterns 
%   specified in opt.wav and opt.par into positive and negative patterns.
%   DMD patterns are saved as PNG images in the opt.patdir folder. Their
%   dynamic range is specified in opt.b. 
%    
%   DMD patterns are typically loaded by SPC.m to simulate single-pixel
%   acquisitions.
% 
%   opt = SAVEPATSPLIT(opt) also saves and loads the quantification map
%   opt.Q_f and compute the index map opt.PI_map (
%
%   See also MAP, SPIRITOPT, WAVPATMAT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function opt = savepatsplit(opt)


%% Parameters
J = length(opt.p); % p = [p_J, ... ,p_1] 

if ~exist(opt.patdir,'dir'); mkdir(opt.patdir); end

wfolder = [opt.patdir filesep opt.patname];
if ~exist(wfolder,'dir'); mkdir(wfolder); end


%% Pattern creation
D = dir([wfolder filesep '*.png']); % Check for already created patterns
nfig = length(D(not([D.isdir]))); % Number of .png files in the folder

%-- Load existing patterns ------------------------------------------------
if nfig == 2*opt.N*opt.N 
    fprintf('---------------------- Loading existing patterns --------------------\n\n');
    
    % Load quantification map
    load([wfolder filesep opt.patname '_Q_f_map.mat']);
    
    % compute index map
    I_map = map(opt.N,J);

%--Create new patterns ----------------------------------------------------
else     
    fprintf('---------------- Generating new patterns (just once)-----------------\n');

    Q_f = zeros(opt.N,opt.N); % Quantization map containing the q_f values
    
    % Two maps used for indexing the patterns that will be stored
    [I_map,OS_map,nos] = map(opt.N,J);
    
    % Loop over all orientation-scale wavelet quadrants
    for e = nos:-1:1  
        ind = find(OS_map == e);    % Matlab linear indices
        ind_pattern = I_map(ind);   % Pattern indices

        % Create the pattern and store them as row vectors on Pattern_map
        Q = wavpatmat(ind,opt);
        
        % Uniform quantization
        q_f = max(abs(Q(:))) / (2^opt.b - 1);
        Q_f(ind) = q_f; % Affect the value q_f to the Q_f map
        Pattern_map_q = round(1/q_f * Q); % Uniform quantization
        
        % Save each pattern in two images : positive and negative part
        for i = 1:length(ind)
           pattern = reshape(Pattern_map_q(i,:),[opt.N opt.N]);
           pattern = full(pattern);
           msq = pattern >= 0;
           p_pos = pattern .* msq;
           p_neg = abs(pattern) .* ~msq;         
           
           number_pos = sprintf('%d.png',2*ind_pattern(i) - 1);
           number_neg = sprintf('%d.png',2*ind_pattern(i));
           
           if opt.b <= 8
               imwrite(uint8(p_pos),[wfolder filesep opt.patname '_' number_pos]);
               imwrite(uint8(p_neg),[wfolder filesep opt.patname '_' number_neg]);
           else
               imwrite(uint16(p_pos),[wfolder filesep opt.patname '_' number_pos]);
               imwrite(uint16(p_neg),[wfolder filesep opt.patname '_' number_neg]);
           end
        end
    end
    save([wfolder filesep opt.patname '_Q_f_map.mat'],'Q_f');
    fprintf('---------------------------------------------------------------------\n\n');

end

opt.I_map = I_map;
opt.Q_f = Q_f;
end