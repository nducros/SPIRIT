function [F_rec,W_acq,M] = abswp(F,W,opt)
% ABSWP     Adaptive basis scan by wavelet prediction
%   F_rec = ABSWP(F,[],opt) acquires and reconstructs the P-by-P image F
%   using the parameters specified in opt. It returns the recontructed 
%   P-by-P image F_rec.
% 
%   opt is a structure containing all the acquisition and reconstruction 
%   parameters. Type 'help spiritopt' for a description of the fields of 
%   this structure.
%   
%   [F_rec, W_acq] = ABSWP(F,[],opt) also returns a P-by-P matrix that
%   contains the wavelet coefficients that have been acquired
%
%   [F_rec,W_acq, M] = ABSWP(F,[],opt) also returns a P-by-P matrix M
%   that indicates the location of the wavelet coefficients acquired at
%   each iteration
% 
%   F_rec = ABSWP([],W,opt) acquires and reconstructs the P-by-P image
%   F_rec from the wavelet transform W of the image of the scene, where W 
%   is a P-by-P matrix. It can be used to simulate adaptive acquisition 
%   a posteriori from a full basis scan. 
%
%   Example 1:
%   [F_rec,F_WT_rec,M] = ABS_WP(F,[],opt);
%
%   Example 2:
%   [F_rec,F_WT_rec,M] = ABS_WP([],F_WT,opt);
%
%   See also DISPPARAM, FWT2, GETWAVPAR, IWT2, SAVEPATSPLIT, SPC, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0 https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0 https://creativecommons.org/licenses/by-sa/4.0/


%% Init parameters from inputs 
if not(isempty(F))
    N = size(F,1);
    dotprod = true;
else
    N = size(W,1);
    dotprod = false;
end

J = length(opt.p);      % p = [p_J, ... ,p_1]
%
R = log2(N);
l = R - J;
W_acq = zeros(N,N);     % Coefficients sampled by ABS-WP
M = zeros(N,N,'uint8'); % Location of the coefficients sampled by ABS-WP

%% Display acquisition parameters
opt.dotprod = dotprod; 
opt.N = N;              
opt.J = J;
%
dispparam(opt);

%% Build wavelet patterns full name
if strcmp(opt.wav,'Db') + strcmp(opt.wav,'Battle') > 0
    opt.patname = sprintf('%s%d_%d_%dx%d', opt.wav, opt.par, J, N, N); % Ex : Battle4_4_128x128'
else
    opt.patname = sprintf('%s_%d_%dx%d', opt.wav, J, N, N); % Ex : Haar_4_128x128'
end

%% Get wavelet transform parameters
wpar = getwavpar(opt.wav,opt.par);

%% Create and save patterns
if dotprod && strcmpi(opt.exp, 'split'), opt = savepatsplit(opt); end

%==========================================================================
%% Main algorithm
%==========================================================================
fprintf('-------------------------- ABS-WP acquisition --------------------------\n');
tic;
%-- Coarse coefficients non adaptative acquisition ------------------------
M(1:2^l,1:2^l) = J+1;   % The whole approximation image is sampled
ind = find(M > 0);      % Indices to sample

if dotprod
    %-- Simulate acquisition
    W_acq(ind) = spc(F(:),ind,opt,J+1);
else    
    %-- Select coefficient to sample in the WT of F
    W_acq(ind) = W(ind); 
end

%-- Detail coefficients adaptive acquisition ------------------------------
for j = J:-1:1
   
    l = R - j;
    k_max = 2^l; % k_max * k_max = size of the approximation image at j   
   
    %% 1) Coarse image : recover the coarse image at j
    F_WT_Extr = W_acq(1:k_max,1:k_max); % Extract the sampled coefficients so far    
    A_j = iwt2(F_WT_Extr,J-j,wpar); % First pass J-j = 0 since we already 
                                                   % acquired the approximation image
                                                       
    %% 2) Interpolation
    H_j = imresize(A_j,2,'bicubic'); % H_j is twice the size of A_j that is 2k_max x 2k_max
        
    %% 3) One-level wavelet transform
    H_j_WT = fwt2(H_j,1,wpar);
     
    %% 4) Location of significant wavelet coefficient (prediction)
    p_j = opt.p(J-j+1); % p_j % of the detail coefficients
    i_j = wavdetloc(H_j_WT,p_j);
          
    %% 5) Acquisition
    [x1,x2] = ind2sub([2*k_max 2*k_max],i_j); % Convert the indices into subscripts
    ind = sub2ind([N,N],x1,x2); % Convert the subscripts into linear indices of the whole image
    M(ind) = j;  % Mark the sampled coefficients  
    %
    if ~isempty(ind)
        if dotprod
            %-- Simulate acquisition
            W_acq(ind) = spc(F(:),ind,opt,j);
        else
            %-- Select coefficient to sample in the WT of F
            W_acq(ind) = W(ind);
        end   
    end
end

%% Reconstruct image
F_rec = iwt2(W_acq,J,wpar); % Recover from the coefficients sampled by ABS-WP
%
t = toc;
fprintf('ABS-WP strategy performed in %0.2f s\n',t);
fprintf('---------------------------------------------------------------------\n');

end

