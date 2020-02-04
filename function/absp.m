function [F_rec,W_acq,M] = absp(F,W,opt)
% ABSWP     Adaptive basis scan
%   F_rec = ABS(F,[],opt) acquires and reconstructs the P-by-P image F
%   using the parameters specified in opt. It returns the recontructed 
%   P-by-P image F_rec.
% 
%   opt is a structure containing all the acquisition and reconstruction 
%   parameters. Type 'help spiritopt' for a description of the fields of 
%   this structure.
%   
%   [F_rec, W_acq] = ABS(F,[],opt) also returns a P-by-P matrix that
%   contains the wavelet coefficients that have been acquired
%
%   [F_rec,W_acq, M] = ABS(F,[],opt) also returns a P-by-P matrix M
%   that indicates the location of the wavelet coefficients acquired at
%   each iteration
% 
%   F_rec = ABS([],W,opt) acquires and reconstructs the P-by-P image
%   F_rec from the wavelet transform W of the image of the scene, where W 
%   is a P-by-P matrix. It can be used to simulate adaptive acquisition 
%   a posteriori from a full basis scan. 
%
%   Example 1:
%   [F_rec,F_WT_rec,M] = ABS(F,[],opt);
%
%   Example 2:
%   [F_rec,F_WT_rec,M] = ABS([],F_WT,opt);
%
%   See also DISPPARAM, FWT2, GETWAVPAR, IWT2, SAVEPATSPLIT, SPC, SPIRITOPT

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 21 Dec 2018
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
J = length(opt.p);
%
R = log2(N);
l = R - J;
W_acq = zeros(N,N);     % Coefficients sampled by ABS-WP
M = zeros(N,N,'uint8'); % Location of the coefficients during ABS

%% Display acquisition parameters
opt.dotprod = dotprod; 
opt.N = N; 
opt.J = J;

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
   
    %% Coarse image : recover the coarse image at resolution j
    F_WT_Extr = W_acq(1:k_max,1:k_max); % Extract the sampled coefficients so far    
    A_j = iwht2(F_WT_Extr); % First pass J-j = 0 since we already 
                                                   % acquired the approximation image
                                                       
    %% Interpolation
    H_j = imresize(A_j,2,'bicubic'); % H_j is twice the size of A_j that is 2k_max x 2k_max
        
    %% Inverse transform
    H_j_WT = iwht2(H_j);
     
    %% 4) Location of significant coefficient (prediction)
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
    fprintf('ABS iteration: %i\n', j)
end

%% Reconstruct image
F_rec = iwht2(W_acq); % Recover from the coefficients sampled by ABS-WP
%
t = toc;
fprintf('ABS-WP strategy performed in %0.2f s\n',t);
fprintf('---------------------------------------------------------------------\n');

end

