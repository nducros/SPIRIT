% WAVPATMAT Create a matrix containing wavelet patterns.
%   Q = WAVEPATMAT(IND,OPT) produces a I-by-D matrix Q that contains I 
%   wavelet patterns. The column vector IND has length I and indicates the 
%   location of the patterns in the wavelet domain. The structure OPT 
%   specifies the wavelet transform. The wavelet type is specified in 
%   OPT.wav and OPT.par, the wavelet decomposition level in OPT.J, and the
%   number of wavelet basis function is OPT.N^2 = D.
% 
%   Example
%   -------
%   ind = [1,2,5];
%   opt.wav = 'Haar'; opt.J = 4; opt.N = 32;  
%   Q = wavpatmat(ind,opt);
%   figure; 
%   subplot(131); surf(reshape(Q(1,:),opt.N,opt.N));
%   subplot(132); surf(reshape(Q(2,:),opt.N,opt.N));
%   subplot(133); surf(reshape(Q(3,:),opt.N,opt.N));
%
%   See also IWT2_PBS, IWT2_PO, SPC, SPIRITOPT

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function Q = wavpatmat(ind,opt)
%% Init
D = opt.N*opt.N;
wpar = getwavpar(opt.wav,opt.par);
I = length(ind);
fprintf('Generating %d / %d wavelet patterns\n',I,D);
%
Q = zeros(I,D);
L = log2(opt.N) - opt.J;
Z = zeros(opt.N,opt.N);


%% Patterns from inverse wavelet transform
%- Orthogonal wavelets
if ~wpar{1}
    for i = 1:I
        % Set to 1 the location for which you want the pattern
        Z(ind(i)) = 1;          
        pattern = IWT2_PO(Z,L,wpar{2}); 
        Q(i,:) = pattern(:);

        % reinit for next pattern
        Z(ind(i)) = 0;
    end
%- Biorthogonal wavelets
else
    for i = 1:I
        % Set to 1 the location for which you want the pattern
        Z(ind(i)) = 1;
        % The h filter and its dual are inverted here!
        pattern = IWT2_PBS(Z,L,wpar{3},wpar{2}); 
        Q(i,:) = pattern(:);

        % reinit for next pattern
        Z(ind(i)) = 0;
    end
end        

end

