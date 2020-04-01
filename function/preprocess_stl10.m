function X = preprocess_stl10(dataFolder, dataset, saveFolder)
%% PREPROCESS_STL10 Preprocess the STL-10 dataset 
%   X = PREPROCESS_STL10(DATAFOLDER, DATASET) returns a 64-by-64-by-K array
%   containing 8-bit images. It loads the raw data subset DATASET within 
%   the DATAFOLDER folder. The raw 96-by-96 color images are resized and 
%   converted to 64-by-64 grayscale images. 
% 
%   DATASET can be string among:
%      'unlabeled'   - K = 100'000 images
%      'test'        - K = 8'000 images
%      'train'       - K = 5'000 images
% 
%   X = PREPROCESS_STL10(DATAFOLDER, DATASET, SAVEFOLDER) saves the array X
%   in the SAVEFOLDER folder. By default, X is saved in DATAFOLDER.
%   
%   See also MAIN_COMPLETION_STL10
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

%% Default arguments
if nargin<3, saveFolder = dataFolder; end

%% Load raw data
disp('-- Loading raw data')
load([dataFolder, dataset,'.mat']);

%% Preprocessing
disp('-- Preprocessing')
%-- Convert to grayscale
X_im = double(reshape(X,[size(X,1),96,96,3]));
X_im = sum(X_im,4);
X_im = permute(X_im, [2,3,1]);

%-- init output
X = zeros(64,64,size(X_im,3));

%-- resize and normalize all images
for ii=1:size(X_im,3) 
    X(:,:,ii) = imresize(X_im(:,:,ii),[64,64]); % to get a power of two
    %X(:,:,ii) = X(:,:,ii)/max(max(X(:,:,ii)))*255;
end
X = X/max(X(:))*255;
X = round(X);

%% Save as preprocessed images (8-bit)
disp('-- Saving preprocessed data')
X = uint8(X);
fullfilename = fullfile(saveFolder,[dataset,'_gray_64x64.mat']);
save(fullfilename,'X','-v7.3');

end