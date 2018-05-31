% DISPPARAM Display SPIRIT parameters.
%   DISPPARAM(opt) displays some of the SPIRIT acquisition and 
%   reconstruction parameters that are specified in the structure opt.
%
%   Type 'help spiritopt' for a description of the fields in the opt
%   structure.
% 
%   See also ABSWP, CR, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function dispparam(opt)
    
fprintf('------------------------- ABS-WP parameters -------------------------\n');

if strcmp(opt.wav,'Db') + strcmp(opt.wav,'Battle') > 0
    fprintf('Wavelet:             %s with %d vanishing moments\n',opt.wav,opt.par);
else
    fprintf('Wavelet:             %s\n',opt.wav);
end

fprintf('Decomposition level: J = %d\n',length(opt.p));
fprintf('Set of percentages:  p = [ ');
fprintf('%d ',opt.p);
fprintf(']\n');
fprintf('Compression ratio:   CR = %0.2f%%\n',cr(opt.p,opt.N)*100)

if opt.dotprod
   fprintf('Computing dot products with %d-bit patterns\n',opt.b);
   fprintf('Saving patterns in:  ''%s''\n',opt.patdir);
   
   if opt.noise
      fprintf('Poisson noise:       N0 = %d ph/s\n',opt.n0); 
      fprintf('                     Collection time = %0.3f s\n',opt.dt); 
   end
end

fprintf('---------------------------------------------------------------------\n\n');
end

