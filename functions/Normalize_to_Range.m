% Normalize_to_Range -- This function normalizes a given image dynamic
% range to a new specified input range.
%
%  --> Input  
%   F           image to normalize to the range
%   range       vector with range(1) = desired min and range(2) = desired max
%
%  --> Ouput
%   F_norm      normalized image to range
%
%  --> Usage
%   F_norm = Normalize_to_Range(F,range)
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function F_norm = Normalize_to_Range(F,range)

F_norm = (F - min(F(:))) / (max(F(:)) - min(F(:))); % 0 to 1 values
F_norm = F_norm * (range(2) - range(1)) + range(1); % range(1) to range(2) values

end

