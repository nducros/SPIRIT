function X = loadprep_stl10(dataset, dataFolder)
%% LOADPREP_STL10 Load preprocessed STL-10 dataset 
%   
%   X = LOADPREP_STL10(DATASET) loads and returns a 64-by-64-by-K array 
%   containing 8-bit images. The proprocessed subset DATASET is assumed to 
%   be saved in the cuurent folder.
%
%   DATASET can be string among:
%      'unlabeled'   - K = 100'000 images
%      'test'        - K = 8'000 images
%      'train'       - K = 5'000 images
% 
%   X = LOADPREP_STL10(DATASET, DATAFOLDER) loads the proprocessed subset
%   DATASET from the folder DATAFOLDER.
%   
%   Example:
%   X = loadprep_stl10('test', './data/stl10_matlab/');
%
%   See also PREPROCESS_STL10 MAIN_COMPLETION_STL10
%
%   The original STL-10 dataset [1] is available at 
%   https://ai.stanford.edu/~acoates/stl10/

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 02 April 2020
%   Toolbox: SPIRiT 2.1 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/

%% Default arguments
if nargin<2, dataFolder = './'; end
dataFolder = fullfile(dataFolder); 

%% Save as preprocessed images (8-bit)
disp('-- Loading preprocessed data')
fullfilename = fullfile(dataFolder,[dataset,'_gray_64x64.mat']);
load(fullfilename,'X');

end