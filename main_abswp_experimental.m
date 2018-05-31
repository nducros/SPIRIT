% ------------------------------------------------------------------------
%   SPIRIT main script. It implements the adaptive basis scan method 
%   described in [1] considering experimental datasets.
% 
%   The SPIRIT parameters are defined in the 'opt' structure. Type 'help 
%   spiritopt' for a description of the fields of this structure.
   
%   References
%   [1] F. Rousset et al., "Adaptive basis scan by wavelet prediction for
%   single-pixel imaging", IEEE Transactions on Computational Imaging, 3,
%   36-46, 2017. 
%   http://dx.doi.org/10.1109/TCI.2016.2637079
 
%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/
% ------------------------------------------------------------------------

set(0,'DefaultFigureColor',[1 1 1]); % White background
set(0,'DefaultFigureUnits','Normalized'); % Use normalized units
set(0,'DefaultFigurePosition',[0.1 0.1 0.7 0.7]); % Almost full screen image
clear;
close all;
clc;

%% Set Matlab Search path (just once)
wavelabdir = 'D:\Creatis\Programmes\Matlab\Wavelab850'; % Set YOUR path here!
path(fullfile(genpath(wavelabdir)),path);
path([pwd filesep 'function'],path);

%% I - Image or dataset
%- data_set:  either an image (simulation) or an experimental mat-file. 
%- If the latter is chosen, only the set of percentages p can be changed.
opt.datadir = 'data';
%opt.dataset = 'Jaszczak_Haar_4_128x128.mat';
opt.dataset = 'Jaszczak_LeGall_4_128x128.mat';

%% II - Simulating single-pixel camera
%- This section is not relevant when loading already data

%% III - ABS-WP parameters
%- Only specify opt.p here. The other necessary parameters are loaded from
%- the datasets.

%- p = [p_J, ... , p_1] specifies the percentage of the detail  
%- coefficients that are kept at each scale j = 1 ... J. Note that the 
%- decomposition level J is chosen through the length of p, i.e., J = length(p).
%- Basis scan examples (all p_j set to 1 or 0)
%-           p = [1 1 0];                % J = 3, CR = 75%
%-           p = [1 1 1 0];              % J = 4, CR = 75%
%-           p = [1 1 1 1 0];            % J = 5, CR = 75%
%- Adaptive basis scan examples (At least one p_j s.t. 0 < p_j < 1) 
%-           p = [0.7 0.15 0.005 0];     % J = 4, CR = 98%

opt.p = [1 0.87 0.5 0];     % J = 4, CR = 80%
%opt.p = [0.7 0.15 0.005 0]; % J = 4, CR = 98%

%- In our datasets, the wavelet transform of the image was not acquired at 
%- the finest scale j = 1. Hence, p(end) should be set to 0. If not, the
%- function readcheckdataset.m will automatically change the given set
%- of percentages. Note also that J = 4, for all the datasets we provide.

%% IV - Handling experimental contraints
%- Pattern splitting is the only valid option with our experimental data
opt.exp = 'split';

%% V - ABS-WP. Adaptive basis scan by wavelet prediction
[F,W,opt] = readcheckdataset(opt);
[F_rec,W_rec,M] = abswp([],W,opt);   % Note the first argument is empty

%% VI - Register SPC image to CCD image for visual and numerical comparisons
F_rec = imwarp(F_rec,opt.tform,'OutputView',imref2d(size(F)));
F_rec = normrange(F_rec,[min(F(:)) max(F(:))]);

%% VII - Image quality metric
PSNR_rec = psnr(F,F_rec); % Compare to CCD

%% VII - Plot
CR =  100*cr(opt.p, size(F,1));
%
figure; 
h1 = subplot(221);
imagesc(M), axis image, 
title(sprintf('Locations of the acquired coefficients\nCR = %0.2f %%',CR));
colormap(h1,hot);
%
h2 = subplot(222);
imagesc(W_rec), colorbar, axis image,
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
title(sprintf('Image recovery using ABS-WP with %s\nPSNR_{rec} = %0.2f dB',opt.wav,PSNR_rec));
colormap(h4,gray);
