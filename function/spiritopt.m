%  opt is the structure containing all the SPIRIT toolbox parameters. The
%  fields in this structure are:
%
%   -- SPC SIMULATION PARAMETERS
%   datadir   - A string that specifies the data directory.
%   dataset   - A string that specifies the dataset filename.
%   patdir    - A string that specifies the pattern directory.
%   b         - An integer that specifies the dynamic range (in bits) of
%             the patterns.
%   n0        - A real value that sets the maximum photon flux, i.e.,
%             max(F(:)) = n0 (in photon per second).
%   alpha     - A real value that sets the the dark current, i.e.,
%             m = alpha (in photon per second) if F=0.
%   dt        - A real value specyfying the collection time (in 
%             second) for each pattern.
%   noise     - A boolean indicating if Poisson noise is applied to
%             measurements.
%
%   -- ABSWP PARAMETERS
%   wav       - One of the following strings, which specifies the 
%             wavelet basis: 'Haar', 'Db', 'Battle', 'LeGall', 
%             'CDF'.
%   par       - An integer that specifies the number of vanishing moments.
%             For wav = 'Db', par is one of 2,3,4,5,6,7,8,9, or 10. 
%             For wav = 'Battle', par is one of 2,4, or 6.
%   p         - Set of percentages [p_J,...,p_1].
%
%   -- PATTERN GENERALIZATION PARAMETERS
%   exp       - One of the following strings, which indicates the way to 
%             handle experimental constraints:
%             'split' or 'snmf'.
%   batch     - ['snmf' only] An integer that indicates the number of 
%             patterns that are processed together
%   maxitr    - ['snmf' only] An interger that specifies the maximum number
%             of iterations
%   epsilon   - ['snmf' only] A real value that specifies the factorization
%             tolerance
% 
%   See also   ABSWP, CR, dispparam, fwt2, getwavpar, iwt2, map, ncsnmf, 
%   normrange, psnr, readcheckdataset, savepatsplit, spc, spiritopt, 
%   wavdetloc, wavpatmat

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/