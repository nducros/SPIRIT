% ABS_WP -- Function to simulate the ABS-WP (Adaptive Basis Scan by Wavelet
% Prediction) strategy as described in the following paper:
% F. Rousset et al., "Adaptive Basis Scan by Wavelet Prediction for
% Single-pixel Imaging", IEEE Transactions on Computational Imaging, 2016
% http://dx.doi.org/10.1109/TCI.2016.2637079
%
%  --> Input  
%   F         image on which to simulate ABS-WP or CCD experimental image
%   F_WT      wavelet transform of F or experimental acquired wavelet transform
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
%   F_rec     image recovered by ABS-WP
%   F_WT_rec  acquired wavelet coefficients by ABS-WP
%   M         map highlighting the acquired wavelet coefficients by ABS-WP
%   CR        compression rate obtained by the set of percentages opt.p
%
%  --> Usage
%   [F_rec,F_WT_rec,M,CR] = ABS_WP(F,F_WT,opt)
%
%  See Also
%    Get_Wavelet_Parameters, SPC_Measurements, Forward_WT, Inverse_WT
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/


function [F_rec,F_WT_rec,M,CR] = ABS_WP(F,F_WT,opt)

%% Parameters from inputs  
N = size(F_WT,1);
J = length(opt.p); % p = [p_J, ... ,p_1]
R = log2(N);
l = R - J;
F_WT_rec = zeros(N,N); % Will contain the sampled coefficients by ABS-WP
M = zeros(N,N,'uint8'); % Map to mark the sampled coefficients
wavelet_param = Get_Wavelet_Parameters(opt.wavelet_name,opt.par);

if strcmp(opt.wavelet_name,'Db') + strcmp(opt.wavelet_name,'Battle') > 0
    opt.wavelet_type = sprintf('%s%d_%d_%dx%d',opt.wavelet_name,opt.par,J,N,N); % Ex : Battle4_4_128x128'
else
    opt.wavelet_type = sprintf('%s_%d_%dx%d',opt.wavelet_name,J,N,N); % Ex : Haar_4_128x128'
end

%% Main algorithm
if opt.SPC_simu; [Q_f,PI_map] = Create_and_Save_Wavelet_Patterns(N,opt); end

fprintf('-------------------------- ABS-WP strategy --------------------------\n');
tic;

% 1) Coarse image/coefficients acquisition
M(1:2^l,1:2^l) = J+1; % The whole approximation image is sampled
ind = find(M > 0); % Indices to sample
if opt.SPC_simu
    ind_pattern = PI_map(ind);
    F_WT_rec(ind) = SPC_Measurements(F(:),ind_pattern,opt,Q_f(ind));
else
    F_WT_rec(ind) = F_WT(ind); % Choose the coefficient to sample directly in the whole WT of F
end

% Detail coefficients acquisition with ABS-WP strategy
for j = J:-1:1
   
    l = R - j;
    k_max = 2^l; % k_max * k_max = size of the approximation image at j   
   
    %% 1) Coarse image : recover the coarse image at j
    F_WT_Extr = F_WT_rec(1:k_max,1:k_max); % Extract the sampled coefficients so far    
    A_j = Inverse_WT(F_WT_Extr,wavelet_param,J-j); % First pass J-j = 0 since we already 
                                                   % acquired the approximation image
                                                       
    %% 2) Interpolation
    H_j = imresize(A_j,2,'bicubic'); % H_j is twice the size of A_j that is 2k_max x 2k_max
    
    
    %% 3) Wavelet transform
    H_j_WT = Forward_WT(H_j,wavelet_param,1); % 1-level WT of H_j
    
    
    %% 4) Predicted triplets
    p_j = opt.p(J-j+1); % p_j % of the detail coefficients
    i_j = Predict_triplets(H_j_WT,k_max,p_j);
    
          
    %% 5) Acquisition
    [x1,x2] = ind2sub([2*k_max 2*k_max],i_j); % Convert the indices into subscripts
    ind = sub2ind([N,N],x1,x2); % Convert the subscripts into linear indices of the whole image
    M(ind) = j;  % Mark the sampled coefficients  
    
    if opt.SPC_simu      
        ind_pattern = PI_map(ind);
        F_WT_rec(ind) = SPC_Measurements(F(:),ind_pattern,opt,Q_f(ind));   
    else
        F_WT_rec(ind) = F_WT(ind); % Sample directly from the 
    end   
    
end

%% Restored image
F_rec = Inverse_WT(F_WT_rec,wavelet_param,J); % Recover from the coefficients sampled by ABS-WP
CR = sum(sum( M > 0 )) / N^2; % # of sampled coefficients / # of pixels
CR = (1 - CR)*100; % CR = compression rate
t = toc;
fprintf('ABS-WP strategy performed in %0.2f s\n',t);
fprintf('---------------------------------------------------------------------\n');

end

