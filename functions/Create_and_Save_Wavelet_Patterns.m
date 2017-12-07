% Create_and_Save_Wavelet_Patterns -- Function used to create the wavelet
% patterns, quantify them and store them as .png files on the disk. Those
% patterns can then be loaded on the DMD for real acquisition or are used
% by SPC_Measurements.m to simulate the acquisition by the SPC.
%
%  --> Input  
%    N      size of the patterns N x N
%    opt    structure containing different options and parameters
%                - opt.wavelet_name : wavelet to be used, see
%                  Get_Wavelet_Parameters for details
%                - opt.par : additional parameters for certain wavelet
%                  giving the number of vanishing moments
%                - opt.p = [p_J,...,p_1] : set of percentages
%                - opt.pattern_folder : folder to store the created
%                patterns
%
%  --> Ouput
%    Q_f     map giving the quantization factor q_f for each wavelet
%            coefficient (size N x N)
%    PI_map  map used for indexing the patterns
%
%  --> Usage
%   [Q_f,PI_map] = Create_and_Save_Wavelet_Patterns(N,opt)
%
%  See Also
%    Create_E_map, Create_Pattern_Indexing_map, Create_Pattern_map, Get_Wavelet_Parameters
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function [Q_f,PI_map] = Create_and_Save_Wavelet_Patterns(N,opt)


%% Parameters
J = length(opt.p); % p = [p_J, ... ,p_1] 

if ~exist(opt.pattern_folder,'dir'); mkdir(opt.pattern_folder); end

wavelet_folder = [opt.pattern_folder filesep opt.wavelet_type];
if ~exist(wavelet_folder,'dir'); mkdir(wavelet_folder); end


%% Pattern creation
D = dir([wavelet_folder filesep '*.png']); % Check for already created patterns
Num = length(D(not([D.isdir]))); % Number of .png files in the folder
if Num == 2*N*N % Pattern have already been created
    load([wavelet_folder filesep opt.wavelet_type '_Q_f_map.mat']);
    [E_map,nb_e] = Create_E_map(N,J);
    PI_map = Create_Pattern_Indexing_map(E_map,nb_e);
   
else % First instance : create the patterns from scratch
    
    fprintf('-------------- WAVELET PATTERN GENERATION --------------\n');
    Q_f = zeros(N,N); % Quantization map containing the q_f values
    wavelet_param = Get_Wavelet_Parameters(opt.wavelet_name,opt.par);
    
    % 2 maps used for indexing the patterns that will be stored
    [E_map,nb_e] = Create_E_map(N,J);
    PI_map = Create_Pattern_Indexing_map(E_map,nb_e);
    
    for e = nb_e:-1:1  % For each areas of the wavelet transform
        ind = find(E_map == e);    % Matlab linear indices
        ind_pattern = PI_map(ind); % Corresponding pattern index
        
        % Create the pattern and store them as row vectors on Pattern_map
        Pattern_map = Create_Pattern_map(ind,ind_pattern,J,N,wavelet_param);
        
        % Uniform quantization
        q_f = max(abs(Pattern_map(:))) / (2^opt.b - 1);
        Q_f(ind) = q_f; % Affect the value q_f to the Q_f map
        Pattern_map_q = round(1/q_f * Pattern_map); % Uniform quantization
        clear Pattern_map;
        
        % Save each pattern in two images : positive and negative part
        for i = 1:length(ind)
           pattern = reshape(Pattern_map_q(i,:),[N N]);
           pattern = full(pattern);
           msq = pattern >= 0;
           p_pos = pattern .* msq;
           p_neg = abs(pattern) .* ~msq;         
           
           number_pos = sprintf('%d.png',2*ind_pattern(i) - 1);
           number_neg = sprintf('%d.png',2*ind_pattern(i));
           
           if opt.b <= 8
               imwrite(uint8(p_pos),[wavelet_folder filesep opt.wavelet_type '_' number_pos]);
               imwrite(uint8(p_neg),[wavelet_folder filesep opt.wavelet_type '_' number_neg]);
           else
               imwrite(uint16(p_pos),[wavelet_folder filesep opt.wavelet_type '_' number_pos]);
               imwrite(uint16(p_neg),[wavelet_folder filesep opt.wavelet_type '_' number_neg]);
           end
        end
    end
    fprintf('\n');
    save([wavelet_folder filesep opt.wavelet_type '_Q_f_map.mat'],'Q_f');
end

end