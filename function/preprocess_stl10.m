function X = preprocess_stl10(dataFolder, dataset, saveFolder)
%% PREPROCESS_STL10 Preprocess the STL-10 dataset 
%                  https://ai.stanford.edu/~acoates/stl10/
%   
%   X = PREPROCESS_STL10(DATAFOLDER, DATASET) returns a 64-by-64-by-K array
%   containing 8-bit images. The STL10 subset DATASET is assumed to be 
%   saved in the DATAFOLDER folder. The original 96-by-96 color images are 
%   loaded, resized and converted to 64-by-64 grayscale images. 
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
%   [1] A. Coates, H. Lee, A.Y. Ng. 'An Analysis of Single Layer Networks 
%   in Unsupervised Feature Learning', AISTATS, 2011.
%   PDF: http://cs.stanford.edu/~acoates/papers/coatesleeng_aistats_2011.pdf

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 02 April 2020
%   Toolbox: SPIRiT 2.1 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/

%% Default arguments
if nargin<3, saveFolder = dataFolder; end
saveFolder = fullfile(saveFolder); 
dataFolder = fullfile(dataFolder);

%% Load raw data
disp('-- Loading raw data')
load(fullfile(dataFolder, [dataset,'.mat']));

%% Preprocessing
disp('-- Preprocessing')
%-- Convert to grayscale
X_im = uint16(reshape(X,[size(X,1),96,96,3]));
clear X;
X_im = sum(X_im,4);

%-- set global max to 255
X_im = X_im/(double(max(X_im(:)))/255);
X_im = uint8(X_im);

X_im = permute(X_im, [2,3,1]);

%-- init output
X = zeros(64,64,size(X_im,3),'uint8');

%-- resize and normalize all images
for ii=1:size(X_im,3) 
    X(:,:,ii) = imresize(X_im(:,:,ii),[64,64]); % to get a power of two
end

%% Save as preprocessed images (8-bit)
disp('-- Saving preprocessed data')
fullfilename = fullfile(saveFolder,[dataset,'_gray_64x64.mat']);
save(fullfilename,'X','-v7.3');

end