function [C, mu] = datstat(Y, dataFolder, dataFilename, plotTag)
% DATSTAT Computes or loads data statistics
%   C = DATSTAT(Y) returns the covariance matrix C corresponging to the
%   image database Y.  The Nx-by-Ny-by-K database consists of K images each
%   os size Nx-by-Ny. The covariance C is an N-by-M matrix, with N = Nx*Ny.
%   The covariance matrix is either computed/saved or loaded from the
%   disk.
% 
%   C = DATSTAT(Y, DATAFOLDER, DATAFILENAME) saves/loads the
%   covariance from the file DATAFILENAME in the folder DATAFOLDER. The
%   default folder is the current folder; the default filename is
%   'mydata.mat'
% 
%   C = DATSTAT(..., PLOTTAG) plots the statistics when PLOTTAG is TRUE.
%
%   [C, MU] = DATSTAT(...) also computes or loads the Nx-by-Ny mean image
%   MU.
%
%   Example:
%   Todo!!
%
%   See Also: DATCOMP

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: April 2019
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/

%% Default values for inputs
if nargin<4, plotTag = false; end
if nargin<3, dataFilename = 'mydata'; end
if nargin<2, dataFolder = '.\'; end

%% Compute or load covariance matrix
fullfilename = fullfile(dataFolder,['cov_',dataFilename]);
if ~isfile(fullfilename) 
    C = cov(reshape(Y,size(Y,1)*size(Y,2),[])');
    save(fullfilename,'C');
else
   load(fullfilename,'C');
end

%% Compute or load save mean
if nargout>1
    fullfilename = fullfile(dataFolder,['mean_',dataFilename]);
    if ~isfile(fullfilename) 
        mu = mean(Y,3);
        mu = mu(:);
        save(fullfilename,'mu');   
    else
       load(fullfilename,'mu');
    end
end

%% Plot
if plotTag
    if nargout>1
        figure; 
        subplot(121);
        imagesc(abs(C)); axis image; colorbar;
        title(['Covariance matrix ',dataFilename]);
        %
        subplot(122);
        plot(mu);
        title(['Mean vector ',dataFilename]);
    else
        figure;
        imagesc(abs(C)); axis image; colorbar;
        title(['Covariance matrix ',dataFilename]);
    end
end