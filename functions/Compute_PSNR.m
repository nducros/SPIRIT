% Compute_PSNR -- Compute the Peak Signal to Noise Ratio between two
% images, one being the reference image.
%
%  --> Inputs
%       F_ref       reference image
%       F           image to compare
%
%  --> Ouputs
%       PSNR        PSNR in decibels between F_ref and F
%       MSE         Mean Square Error between F_ref and F
%
%  --> Usage
%      [PSNR_val,MSE] = Compute_PSNR(F_ref,F)
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function [PSNR_val,MSE] = Compute_PSNR(F_ref,F)

[H,W] = size(F_ref);

if size(F,1) ~= H || size(F,2) ~= W
    error('Images must have the same size !');
end

max_I_ref = max(F_ref(:));
vect_diff = F_ref(:) - F(:);

MSE = 1/length(vect_diff) * sum(vect_diff .^ 2);
PSNR_val = 10*log10(max_I_ref^2 / MSE);

end

