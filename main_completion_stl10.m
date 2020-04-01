%   This script is the application of the Bayesion completion approach [1] 
%   to the STL-10 image dataset [2].  
%   
%   This script:
%      1. Loads the STL-10 database from the web [2]
%      2. Computes the 2D Hadamard transform of each image
%      3. Reconstruct an image from few of its Hadamard coefficients [1]
%
%   [1] N. Ducros, A Lorente Mur, F Peyrin. 'A completion network for 
%   reconstruction from compressed acquisition', IEEE ISBI, 2020.
%   PDF: https://hal.archives-ouvertes.fr/hal-02342766/
%
%   [2] A. Coates, H. Lee, A.Y. Ng. 'An Analysis of Single Layer Networks 
%   in Unsupervised Feature Learning', AISTATS, 2011.
%   PDF: http://cs.stanford.edu/~acoates/papers/coatesleeng_aistats_2011.pdf

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 01 April 2020
%   Toolbox: SPIRiT 2.1 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/


%%   Download the stl-10 (NOT TESTED YET!)
%- This can be done manually if the gunzip or untar functions are not available.
%- http://ai.stanford.edu/~acoates/stl10/stl10_matlab.tar.gz
url = 'http://ai.stanford.edu/~acoates/stl10/stl10_matlab.tar.gz';
disp('-- Loading stl-10 dataset')
gunzip(url, 'data');
untar('.\data\stl10_matlab.tar','data');

%% User-defined
dataFolder = '.\data\stl10_matlab\';
saveFolder = dataFolder; 
testset = 'test';       %-    8'000 images. 'train' works too (5'000 images)
trainset = 'unlabeled'; %-  100'000 images
%- compression ratio
ratio = 0.1;            %- retain 1% of the measurements

%% Preprocess training data
X = preprocess_stl10(dataFolder, trainset, saveFolder);

%% Hadamard transform of training data
disp('-- Hadamard transform')
X = double(X);
Y = zeros(size(X));
for ii=1:size(X,3), Y(:,:,ii) = fwht2(X(:,:,ii)); end

%% Mean and covariance
disp('-- Computing mean and covariance')
[C,mu] = datstat(Y, trainset, saveFolder, true);

%% Preprocess testing data
X = preprocess_stl10(dataFolder, testset, saveFolder);

%% Hadamard transform of testing data
disp('-- Hadamard transform')
X = double(X);
Y = zeros(size(X));
for ii=1:size(X,3), Y(:,:,ii) = fwht2(X(:,:,ii)); end

%% Subsampling
%- variance of Hadamard coefficients
sigma = sqrt(diag(C));
%-- we keep the coefficients with high variance
[~, ind_acq] = maxk(sigma(:), floor(ratio*size(X,1)*size(X,2)));

%% Reconstruction of one of the test images
ii = 5;     % <- change this to test reconstruction of other images
Y_test = Y(:,:,ii);

%-- zero padding
Y_zp = zeros(size(Y,1),size(Y,2));
Y_zp(ind_acq) = Y_test(ind_acq);
X_zp = iwht2(Y_zp);

%-- Bayesian completion
Y_bc = datcomp(Y_zp, C, mu);
X_bc = iwht2(Y_bc);
    
%% Plot results
figure;
subplot(131); 
imagesc(X(:,:,ii),[0 255]); axis image; colorbar;
title('Ground-truth');
%
subplot(132); 
imagesc(X_zp,[0 255]); axis image; colorbar;
title(sprintf('Zero-padding - PSNR = %.2f dB', psnr(X(:,:,ii),X_zp)));
%
subplot(133); 
imagesc(X_bc(:,:,1),[0 255]); axis image; colorbar;
title(sprintf('Bayesian completion - PSNR = %.2f dB', psnr(X(:,:,ii),X_bc)));