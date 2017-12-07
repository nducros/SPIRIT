% ------------------------------------------------------------------------
%  Author : F. Rousset, N Ducros
%  Institution : Creatis laboratory, University of Lyon, France
%  Date : 15th Dec 2016
%
% Main script to simulate acquisition and reconstruct an image using the
% ABS-WP technique. Details can be found in [1].
%
% [1] F. Rousset et al., "Adaptive Basis Scan by Wavelet Prediction for
% Single-pixel Imaging", IEEE Transactions on Computational Imaging, 2016
% http://dx.doi.org/10.1109/TCI.2016.2637079
%
% This code is given freely under Creative Commons (CC-BY-SA 4.0)
% ------------------------------------------------------------------------

set(0,'DefaultFigureColor',[1 1 1]); % White background
set(0,'DefaultFigureUnits','Normalized'); % Use normalized units
set(0,'DefaultFigurePosition',[0.1 0.1 0.7 0.7]); % Almost full screen image
clear;
close all;
clc;

path(path, [pwd filesep 'functions']);


%% I - Image for simulation or experimental dataset
% data_set:  specify an image (simulation) or provide an experimental .mat 
% file. If the latter is chosen, only the set of percentages p can be changed.
data_set = 'data/Jaszczak_CCD.png';


%% II - Wavelet parameters
% wavelet_name: orthogonal or biorthogonal wavelets can be used. 
% Choices are:  'Haar' for Haar wavelet
%               'Db' for Daubechies
%               'Battle' for Battle-Lemarie
%               'LeGall' for CDF 2.2 (5/3) biorthogonal wavelet
%               'CDF' for CDF 4.4 (9/7) biorthogonal wavelet
% For other wavelets, see Get_Wavelet_Parameters.m.
opt.wavelet_name = 'LeGall';

% par: additional parameter for Daubechies or Battle wavelets giving the
% number of vanishing moments.
% Choices are: 2,3,4,5,6,7,8,9,10 for Daubechies
%              2,4,6 for Battle
opt.par = 4;


%% III - ABS-WP parameters
% p = [p_J, ... , p_1]: give the percentage of detail coefficients to
% keep at each scale j = 1 ... J. 
% Note that the length of p enforces the value of J giving the decomposition
% level of the wavelet transform.
% Example for p : p = [0.7 0.15 0.005 0]; % CR = 98%
%                 p = [0.85 0.5 0.05 0.0045]; % CR = 95%
%                 p = [0.9 0.75 0.21 0.015]; % CR = 90%
%                 p = [0.9 0.8 0.45 0.019]; % CR = 85%
%                 p = [0.9 0.8 0.71 0.02]; % CR = 80%
%                 p = [0.95 0.85 0.84 0.05]; % CR = 75%
%                 p = [0.95 0.85 0.77 0.4]; % CR = 50%
opt.p = [0.9 0.8 0.71 0.02]; % CR = 80%

% SPC_simu: boolean that specify how the acquisition of the wavelet
% coefficients is performed. 
% > SPC_simu = true, the full set of wavelet patterns is created and stored
% in a folder. Each coefficients is obtained computing the dot product of 
% the wavelet pattern and the image.
% > SPC_simu = false, the full wavelet transform of the image is computed 
% and the ABS-WP strategy samples the transformed image.
% Note that SPC_simu = true is much more time consumming than SPC_simu = false
% since all patterns are created (only once).

opt.SPC_simu = false; 

% Folder to store the patterns, when SPC_simu = true
opt.pattern_folder = 'patterns'; 

% b: number of bits of the DMD, i.e., the dynamic range of the DMD is [0 2^b-1]. 
% This value will be used only if SPC_simu = true, to quantify the patterns. 
opt.b = 8;


%% IV - Noise parameters
% The following parameters will only be used if SPC_simu = true.
% Changing N_0 and Delta_t allows to change the noise level

% noise: boolean that specify if Poisson noise is applied to the SPC 
% measurements or not.
opt.noise = false;

% Delta_t: collection time (in s)
opt.Delta_t = 1;

% N_0: photon flux emitted by the object (in ph/s)
opt.N_0 = 1e3;


%% ABS-WP simulation
[F,F_WT,opt] = Read_and_Check_Dataset(data_set,opt);
Display_ABS_WP_Parameters(opt);
[F_rec,F_WT_rec,M,CR] = ABS_WP(F,F_WT,opt); % ABS_WP strategy

%% Image quality metric
PSNR_rec = Compute_PSNR(F,F_rec);

%% Plot
figure; 
h1 = subplot(221); 
imagesc(M), axis image, 
title(sprintf('Locations of the acquired coefficients\nCR = %0.2f %%',CR));
colormap(h1,hot);
%
h2 = subplot(222); 
imagesc(F_WT_rec), colorbar, axis image, 
title(sprintf('Acquired wavelet coefficients\nDecomposition level J = %d',length(opt.p)));
colormap(h2,jet);
%
h3 = subplot(223); 
imagesc(F), colorbar, axis image, 
title('Ground truth (CCD) image');
colormap(h3,gray);
%
h4 = subplot(224); 
imagesc(F_rec), colorbar, axis image, 
title(sprintf('Image recovery using ABS-WP with %s\nPSNR_{rec} = %0.2f dB',opt.wavelet_name,PSNR_rec)); 
colormap(h4,gray);
