% PSNR   Compute the peak signal-to-noise ratio
%   [PSNR_val] = psnr(F_ref,F) returns the peak signal-to-noise ratio 
%   between two images F_ref and F, where F_ref is the reference
%   (noiseless or artifact free) image. The two images must have the same
%   size.
%   
%   [PSNR_val, MSE] = psnr(F_ref,F) also returns the mean squared error MSE
%
%   Example 1
%   ---------
%   load clown;
%   Y = conv2(X,ones(4)/16,'same');
%   figure; subplot(121),imagesc(X), subplot(122),imagesc(Y)
%   psnr(X,Y)
%
%   Example 2
%   ---------
%   load clown;
%   Y = conv2(X,ones(9)/81,'same');
%   figure; subplot(121),imagesc(X), subplot(122),imagesc(Y)
%   psnr(X,Y)
%
%   See also SPIRITOPT 

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function [PSNR_val,MSE] = psnr(F_ref,F)

[H,W] = size(F_ref);

if size(F,1) ~= H || size(F,2) ~= W
    error('Images must have the same size !');
end

max_I_ref = max(F_ref(:));
vect_diff = F_ref(:) - F(:);

MSE = 1/length(vect_diff) * sum(vect_diff .^ 2);
PSNR_val = 10*log10(max_I_ref^2 / MSE);

end

