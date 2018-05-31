% READCHECKDATASET Read dataset and check acquisition parameters.
%   [F, W] = readcheckdataset(OPT) returns the image to acquire F and its
%   wavelet transform W. Both F and W are N-by-N matrices. OPT is a
%   structure, where OPT.datadir specifies the dataset folder and 
%   OPT.dataset the dataset filename.
%   
%   OPT.dataset is either a PNG-file or a MAT-file. Use a PNG-file to 
%   simulate data acquisition. Use a MAT-file to load (experimental) data.
% 
%   In the MAT-file datasets that are provided with the SPIRIT toolbox, F 
%   is a CCD camera image while W contains the measurements (i.e., measured
%   wavelet coefficients).
%
%   Type 'help spiritopt' for details about the OPT structure.
% 
%   [F,W,OPT] = readcheckdataset(OPT) also check and provide defaults 
%   values to empty OPT fields
%   
%   See also FWT2, GETWAVPAR, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/


function [F,W,opt] = readcheckdataset(opt)

%% Init
p_ok = true;
[~,~,ext] = fileparts(opt.dataset);

%% Default parameters
%-- patterns
if ~isfield(opt,'wav');    opt.wav = 'LeGall'; end
if ~isfield(opt,'par');    opt.par = 0; end
if ~isfield(opt,'patdir'); opt.patDir = 'Patterns'; end
%-- simulation
if strcmp(ext,'.png')
if ~isfield(opt,'b');      opt.b = 8; end
if ~isfield(opt,'noise');  opt.noise = false; end
if ~isfield(opt,'alpha');  opt.alpha = 1e2; end
end
%-- abswp
if ~isfield(opt,'p'); opt.p = [0.9 0.8 0.71 0.02]; end % CR = 80%
%-- pattern generalization
if ~isfield(opt,'exp'); opt.exp = 'split'; end
if ~isfield(opt,'maxitr') && strcmpi(opt.exp,'snmf'); opt.maxitr = 500; end
if ~isfield(opt,'epsilon')&& strcmpi(opt.exp,'snmf'); opt.epsilon = 1e-3; end

%% Check or read dataset
if strcmp(ext,'.mat')
    
    fprintf('-------------------------- Check and Load dataset ----------------------\n');
   
    %-- This loads F_WT (of the CW), wav, J, tform, F (CCD or CW
    %-- image), p (default set) and F_WT_lambda_t for
    %-- multispectral/time-resolved data
    load(fullfile(opt.datadir,opt.dataset));
    
    %-- Fill OPT parameters from dataset
    opt.wav = wav;
    opt.par = par;
    
    %-- Check set of percentages and fill OPT
    if  J ~= length(opt.p) || opt.p(J) ~= 0 
        L_p = length(opt.p);
        new_p = zeros(1,J);
        
        if L_p < J
            new_p(1:L_p) = opt.p(1:L_p);
        else
            new_p(1:J-1) = opt.p(1:J-1); % The finest details have not been acquired
        end                              % --> force p(J) to 0
        
        
        opt.p = new_p;
        p_ok = false;
    end
    
    %-- Mapping that registers SPC and CCD images, for visual comparison
    if exist('tform','var'); opt.tform = tform; end 

else %-- Image file
    fprintf('------------------------- Load image --------------------------------\n\n');

    F = imread(fullfile(opt.datadir,opt.dataset));

    %-- RGB image ?
    if size(F,3) == 3; F = rgb2gray(F); end
    F = double(F);
    N = size(F,1);   
    
    %-- F square ?
    if N ~= size(F,2)
        N = min(N,size(F,2)); % Resize to minimum side
        F = imresize(F,[N N]); 
    end
    
    %-- Size of F = power of 2 ?
    if round(log2(N)) ~= log2(N) % N is not a power of 2
        N = 2^floor(log2(N)); 
        F = imresize(F,[N N]); % Make sure that F is square
    end
    
    if opt.noise 
        %-- Set the maximum number of photons of F to n0
        F = opt.n0 * F / max(F(:));
    end   
    
    J = length(opt.p);
    wpar = getwavpar(opt.wav,opt.par);
    W = fwt2(F,J,wpar); % Whole WT of F
end

%% Check that given p is a set of percentages
for i = 1:length(opt.p)
   if opt.p(i) < 0
       opt.p(i) = 0;
       p_ok = false;
   elseif opt.p(i) > 1
       opt.p(i) = 1;
       p_ok = false;
   end
end

if ~p_ok
    disp('The percentage set were not correct and has been changed to:');
    disp(opt.p);
end

end