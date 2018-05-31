% ------------------------------------------------------------------------
%   SPIRIT main script. It simulates the acquisition and reconstruction of
%   an image by a single-pixel camera. It implements the adaptive basis 
%   scan described in [1]. Pattern positivity is addressed using either
%   pattern splitting or solving the pattern generalization problem as
%   described in [2].
% 
%   The spirit parameters are defined in the 'opt' structure. Type 'help 
%   spiritopt' for a description of the fields of this structure.
   
%   References
%   [1] F. Rousset et al., "Adaptive basis scan by wavelet prediction for
%   single-pixel imaging", IEEE Transactions on Computational Imaging, 3,
%   36-46, 2017. 
%   http://dx.doi.org/10.1109/TCI.2016.2637079
%   
%   [2] F. Rousset et al., "A semi nonnegative matrix factorization 
%   technique for pattern generalization in single-pixel imaging", IEEE 
%   Transactions on Computational Imaging, 
%   https://doi.org/10.1109/TCI.2018.2811910
 
%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
% ------------------------------------------------------------------------

set(0,'DefaultFigureColor',[1 1 1]);                % White background
set(0,'DefaultFigureUnits','Normalized');           % Normalized units
set(0,'DefaultFigurePosition',[0.1 0.1 0.7 0.7]);   % Almost full screen
clear;
%close all;
clc;

%% Set Matlab Search path (just once)
wavelabdir = 'D:\Creatis\Programmes\Matlab\Wavelab850'; % Set YOUR path here!
path(fullfile(genpath(wavelabdir)),path);
path([pwd filesep 'function'],path);


%% I - Image or dataset
%- data_set:  either an image (simulation) or an experimental mat-file. 
%- If the latter is chosen, only the set of percentages p can be changed.
opt.datadir = 'data';
% opt.dataset = 'Jaszczak_CCD_128x128.png';
opt.dataset = 'Jaszczak_CCD_64x64.png';


%% II - Simulating single-pixel camera
%- The following parameters ARE used if an image is provided to abswp. 
%- The following parameters are NOT used if wavelet coefficients 
%- (experimental or simulated data) are provided to abswp.

%- Patterns directory
opt.patdir = 'pattern'; 
%- DMD Patterns dynamic.
opt.b = 8;
%- Photon flux emitted by the object (in ph/s)
opt.n0 = 2100;   % 
%- Photon flux DC component (in ph/s)
opt.alpha = 20000; % (in ph/s) 
%- Collection time (in s)
opt.dt = 1;
%- Apply Poisson noise to measurement (true) or not (false)
opt.noise = true;
% opt.noise = false;

%% III - ABS-WP parameters
%- wavelet_name: orthogonal or biorthogonal wavelets can be used. 
%- Choices are:  'Haar' for Haar wavelet
%-               'Db' for Daubechies
%-               'Battle' for Battle-Lemarie
%-               'LeGall' for CDF 2.2 (5/3) biorthogonal wavelet
%-               'CDF' for CDF 4.4 (9/7) biorthogonal wavelet
%- For other wavelets, see Get_Wavelet_Parameters.m.
% opt.wav = 'Haar';
opt.wav = 'Db';

%- par: additional parameter for Daubechies or Battle wavelets giving the
%- number of vanishing moments.
%- Choices are: 2,3,4,5,6,7,8,9,10 for Daubechies
%              2,4,6 for Battle
opt.par = 4;

%- p = [p_J, ... , p_1] specifies the percentage of the detail  
%- coefficients that are kept at each scale j = 1 ... J. Note that the 
%- decomposition level J is chosen through the length of p, i.e., J = length(p).
%- Basis scan examples (all p_j set to 1 or 0)
%-           p = [1 1 0];                % J = 3, CR = 75%
%-           p = [1 1 1 0];              % J = 4, CR = 75%
%-           p = [1 1 1 1 0];            % J = 5, CR = 75%
%- Adaptive basis scan examples (At least one p_j s.t. 0 < p_j < 1) 
%-           p = [0.7 0.15 0.005 0];     % J = 4, CR = 98%
%-           p = [0.85 0.5 0.05 0.0045]; % J = 4, CR = 95%
%-           p = [0.9 0.75 0.21 0.015];  % J = 4, CR = 90%
%-           p = [0.9 0.8 0.45 0.019];   % J = 4, CR = 85%
%-           p = [0.9 0.8 0.71 0.02];    % J = 4, CR = 80%
%-           p = [0.95 0.85 0.84 0.05];  % J = 4, CR = 75%
%-           p = [0.95 0.85 0.77 0.4];   % J = 4, CR = 50%

% opt.p = [0.9 0.75 0.21 0.015];  % J = 4, CR = 90%
% opt.p = [0.9 0.8 0.45 0.019];   % J = 4, CR = 85%
opt.p = [0.95 0.85 0.84 0.05];  % J = 4, CR = 75%
% opt.p = [0.95 0.85 0.77 0.4]; % J = 4, CR = 50%

%% IV - Handling experimental contraints (choose pattern spliting OR SNMF)
%- Pattern splitting
opt.exp = 'split';

%- SNMF-based pattern generalization
% opt.exp = 'snmf'; 
% opt.batch = 10;
% opt.maxitr = 20000;
% opt.epsilon = 1e-5;

%% V - ABS-WP. Adaptive basis scan by wavelet prediction
[F,F_WT,opt] = readcheckdataset(opt);
[F_rec,F_WT_rec,M] = abswp(F,[],opt); % Note the second argument is empty

%% Image quality metric
PSNR_rec = psnr(F, F_rec);

%% Plot
CR =  100*cr(opt.p, size(F,1));
%
figure; 
h1 = subplot(221); 
imagesc(M), axis image, 
title(sprintf('Locations of the acquired coefficients\nCR = %0.2f %%',CR));
colormap(h1,hot);
%
h2 = subplot(222); 
imagesc(F_WT_rec), colorbar, axis image, 
title(sprintf('Acquired %s coefficients\nDecomposition level J = %d',...
               opt.wav, length(opt.p)));
colormap(h2,jet);
%
h3 = subplot(223); 
imagesc(F), colorbar, axis image, 
title('Ground truth (CCD) image');
colormap(h3,gray);
%
h4 = subplot(224); 
imagesc(F_rec), colorbar, axis image, 
title(sprintf('Image recovery using ABS-WP with %s\nPSNR_{rec} = %0.2f dB',opt.wav,PSNR_rec)); 
colormap(h4,gray);
