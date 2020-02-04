% ACQUIRE Simulate single-pixel measurements !!TODO: Help below!!
%   m = ACQUIRE(f,P) returns the measurement vector obtained acquiring 
%   the image f using the patterns P.
%   
%   indexed by IND and the simulation 
%   parameters specified in OPT. F is a real-valued column vector 
%   (typically a vectorized image). IND is a column vector whose length 
%   determines the length of M. Type 'help spiritopt' for a description of 
%   the field in the OPT structure. 
%
%   See also ABSWP,  NCSNMF, SPIRITOPT, WAVPATMAT 

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: May 2019
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function m = acquire(f,P,dt,sigma,d,b,noise,s)

%% Default input 
if nargin<=7, s=0; end
if nargin<=6, noise=true; end
if nargin<=5, b=0; end
if nargin<=4, d=0; end
if nargin<=3, sigma=0; end % Pure Poisson noise
if nargin<=3, dt=1; end 

%% Main
if noise
   rng(s); % to get predictable sequence of numbers
   m = poissrnd(P*f*dt + d*dt + b);
   m = m + sigma*randn(size(m));
   %- For several repetitions of the same acquisition
   % poissrnd(repmat(Hpos*c + d*dt + b,1,K)) + sigma*randn(N,K);
else
   m = P*f*dt + d*dt + b + sigma;
end
   m(m<=0)=0; % negative counts set to 0
end

