function [C, mu] = datstat(Y, dataSuffix, dataFolder,  plotTag)
% DATSTAT Computes (and saves) database statistics
%   C = DATSTAT(Y) returns the covariance matrix C corresponging to the
%   image database Y.  The Nx-by-Ny-by-K database Y consists of K images 
%   each of size Nx-by-Ny. The covariance C is an N-by-M matrix, with 
%   N = Nx*Ny.
%
%   [C, MU] = DATSTAT(Y) also computes the N-by-1 mean vector MU.
%   
%   [C, MU] = DATSTAT(Y, DATASUFFIX) also saves as MAT-files the covariance
%   and mean on in the current folder on the disk. DATASUFFIX is used as a 
%   suffix for the filename. C is saved as 'cov_DATASUFFIX.mat' and MU as 
%   'mean_DATASUFFIX.mat'.
%
%   [C, MU] = DATSTAT(Y, DATASUFFIX, DATAFOLDER) saves the MAT-files in the
%   folder DATAFOLDER.
% 
%   [...] = DATSTAT(..., PLOTTAG) plots the statistics when PLOTTAG is TRUE.
%
%   Example:
%   Todo!!
%
%   See Also: DATCOMP
%
%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Contact: nicolas.ducros@creatis.insa-lyon.fr
%   Date: April 2019
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/

%% Default values for inputs
if nargin<4, plotTag = false; end
if nargin<3, dataSuffix = 'mydata'; end
if nargin<2, dataFolder = '.\'; end

%% Compute and save covariance matrix
fullfilename = fullfile(dataFolder,['cov_',dataSuffix]);
C = cov(reshape(Y,size(Y,1)*size(Y,2),[])');
save(fullfilename,'C');

%% Compute or load save mean
if nargout>1
    fullfilename = fullfile(dataFolder,['mean_',dataSuffix]);
    mu = mean(Y,3);
    mu = mu(:);
    save(fullfilename,'mu');   
end

%% Plot
if plotTag
    if nargout>1
        figure; 
        subplot(121);
        imagesc(log(abs(C))); axis image; colorbar;
        title(['Covariance matrix (log of magnitude)',dataSuffix]);
        %
        subplot(122);
        semilogy(log(abs(mu)));
        title(['Mean vector (magnitude)',dataSuffix]);
    else
        figure;
        imagesc(log(abs(C))); axis image; colorbar;
        title(['Covariance matrix (log of magnitude)',dataSuffix]);
    end
end