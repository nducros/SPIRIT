
%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: April 2019
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/


function [C,mu] = datastat(Y, dataFolder, dataFilename, plotTag)

%% Default values for inputs
if nargin ==3, plotTag = false; end

%% Compute and save covariance matrix OR load it
fullfilename = fullfile(dataFolder,['cov_',dataFilename]);
%
if ~isfile(fullfilename) 
    %
    C = cov(reshape(Y,size(Y,1)*size(Y,2),[])');
    save(fullfilename,'C');
    %
else
   load(fullfilename,'C');
end

%% Compute and save mean vector matrix OR load it
fullfilename = fullfile(dataFolder,['mean_',dataFilename]);
%
if ~isfile(fullfilename) 
    %
    mu = mean(Y,3);
    mu = mu(:);
    save(fullfilename,'mu');
    %    
else
   load(fullfilename,'mu');
end

%%
if plotTag
    figure; 
    %
    subplot(121);
    imagesc(abs(C)); axis image; colorbar;
    title(['Covariance matrix ',dataFilename]);
    %
    subplot(122);
    plot(mu);
    title(['Mean vector ',dataFilename]);
end

