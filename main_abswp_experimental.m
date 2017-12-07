% ------------------------------------------------------------------------
%  Author : F. Rousset, N Ducros
%  Institution : Creatis laboratory, University of Lyon, France
%  Date : 15th Dec 2016
%
% Main script implementing ABS-WP technique [1] on experimentally acquired
% data.
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

%% I - Image for simulation or Experimental dataset
% data_set:  specify an image (simulation) or provide an experimental .mat 
% file. If the latter is chosen, only the set of percentages p can be changed.
data_set = 'data/Jaszczak_LeGall_4_128x128.mat'; 


%% II - ABS-WP parameters
% p = [p_J, ... , p_1]: gives the percentage of detail coefficients to
% keep at each scale j = 1 ... J, where J is the decomposition level
% Note that the length of p defines the value of J. 
% Example for p : p = [0.7 0.15 0.005 0]; % CR = 98%
%                 p = [0.85 0.5 0.05 0.0045]; % CR = 95%
%                 p = [0.9 0.75 0.21 0.015]; % CR = 90%
%                 p = [0.9 0.8 0.45 0.019]; % CR = 85%
%                 p = [0.9 0.8 0.71 0.02]; % CR = 80%
%                 p = [0.95 0.85 0.84 0.05]; % CR = 75%
%                 p = [0.95 0.85 0.77 0.4]; % CR = 50%
opt.p = [1 0.87 0.5 0]; % CR = 80%

% In our datasets, the wavelet transform of the image was not acquired at 
% the the finest scale j = 1. Hence, p(end) should be set to 0. If not, the
% function Read_and_Check_Dataset.m will automatically change the given set
% of percentages. Note also that J = 4, for the provided datasets.

% The rest of the options will be field in opt by Read_and_Check_Dataset.m.


%% ABS-WP simulation
[F_CCD,F_WT,opt] = Read_and_Check_Dataset(data_set,opt);
Display_ABS_WP_Parameters(opt);
[F_rec,F_WT_rec,M,CR] = ABS_WP([],F_WT,opt); % ABS_WP strategy

% Rescale and register the sample SPC image to the CCD for visual and numerical comparisons
F_rec = imwarp(F_rec,opt.tform,'OutputView',imref2d(size(F_CCD)));
F_rec = Normalize_to_Range(F_rec,[min(F_CCD(:)) max(F_CCD(:))]);


%% Image quality metric
PSNR_rec = Compute_PSNR(F_CCD,F_rec); % Compare to CCD

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
imagesc(F_CCD), colorbar, axis image,
title('Ground truth (CCD) image');
colormap(h3,gray);
%
h4 = subplot(224);
imagesc(F_rec), colorbar, axis image, 
title(sprintf('Image recovery using ABS-WP with %s\nPSNR_{rec} = %0.2f dB',opt.wavelet_name,PSNR_rec));
colormap(h4,gray);
