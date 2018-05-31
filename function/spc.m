% SPC Simulate single-pixel measurements
%   M = SPC(F,IND,OPT) returns the measurement vector obtained acquiring 
%   the image F using the patterns indexed by IND and the simulation 
%   parameters specified in OPT. F is a real-valued column vector 
%   (typically a vectorized image). IND is a column vector whose length 
%   determines the length of M. Type 'help spiritopt' for a description of 
%   the field in the OPT structure. 
% 
%   M = SPC(F,IND,OPT,J) specifies the acquisition number. This is required
%   for adaptive acquisitions based on pattern generalization.
%
%   See also ABSWP,  NCSNMF, SPIRITOPT, WAVPATMAT 

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

function m = spc(f,ind,opt,j)

max_dyn = 2^opt.b-1;
I = length(ind);

if strcmpi(opt.exp,'split')
    m_pos = zeros(I,1);
    m_neg = zeros(I,1);
    wavelet_folder = [opt.patdir filesep opt.patname];
    ind_pattern = opt.I_map(ind);
    q_f_vec = opt.Q_f(ind);

    for i = 1:I
        %- Read the pos and neg pattern corresponding to ind_pattern(i)
        p_pos = double(imread([wavelet_folder filesep opt.patname '_' num2str(2*ind_pattern(i)-1) '.png']));
        p_neg = double(imread([wavelet_folder filesep opt.patname '_' num2str(2*ind_pattern(i)) '.png']));

        m_pos(i) = f' * p_pos(:); % One SPC measurement
        m_neg(i) = f' * p_neg(:); % One SPC measurement

    end

    if opt.noise
       rng(1); % to get predictable sequence of numbers
       m_pos = poissrnd(opt.dt/max_dyn * m_pos + opt.dt * opt.alpha);
       m_neg = poissrnd(opt.dt/max_dyn * m_neg + opt.dt * opt.alpha); 
       m_pos = (max_dyn * q_f_vec / opt.dt) .* m_pos;
       m_neg = (max_dyn * q_f_vec / opt.dt) .* m_neg;   
       m = m_pos - m_neg;
    else
        m = q_f_vec .* (m_pos - m_neg);  % Final SPC measurement
    end

    
elseif strcmpi(opt.exp,'SNMF')
    
    %- Desired patterns
    Q = wavpatmat(ind,opt);
    
    %- number of block of patterns
    if size(Q,1)<= opt.batch,   nB = 1;
    else,                       nB = fix(size(Q,1)/opt.batch);
    end
    fprintf('Generating %d positive patterns\n',I+nB);
    
    %- Preallocation
    T = zeros(I,I+nB);
    P = zeros(I+nB, size(Q,2));

    %- Factorizing the first batch (nb patterns = opt.batch)
    for nb = 1:nB-1
        i_min = (nb-1)*opt.batch + 1;
        i_max = nb*opt.batch;
        k_min = (nb-1)*(opt.batch+1) + 1;
        k_max = nb*(opt.batch+1);
        fprintf('Generating positive patterns %d to %d\n',k_min,k_max);
        %
        [T_temp, P_temp] = ncsnmf(Q(i_min:i_max,:), max_dyn, opt.maxitr, opt.epsilon);
        % 
        P(k_min:k_max,:) = P_temp;
        T(i_min:i_max,k_min:k_max) = T_temp;
    end

    %- Factorizing the last batch (nb patterns > opt.batch)
    i_min = (nB-1)*opt.batch + 1;
    k_min = (nB-1)*(opt.batch+1) + 1;
    fprintf('Generating positive patterns %d to %d\n', k_min, I+nB);
    %
    [T_temp, P_temp] = ncsnmf(Q(i_min:end,:), max_dyn, opt.maxitr, opt.epsilon);
    % 
    P(k_min:end,:) = P_temp;
    T(i_min:end,k_min:end) = T_temp;

    %- quantization   
    P = round(P); % NB: P already in [0, 2^b-1]

    %- Saving transformation matrix on hard drive (MAT-file)
    saving_name = [opt.dataset '_' opt.patname];
    saving_folder = [opt.patdir filesep saving_name];
    if ~exist(opt.patdir,'dir'); mkdir(opt.patdir); end
    if ~exist(saving_folder,'dir'); mkdir(saving_folder); end
    %
    save(sprintf('%s%s%s_j_%d_T.mat',saving_folder,filesep,saving_name,j),'T');
    
    %- Saving patterns on hard drive (PNG images)
    K = size(P,1);
    N = sqrt(size(P,2));
    for k = 1:K
        pattern = reshape(P(k,:),[N N]); 
        num_string = sprintf('j_%d_%d.png',j,k);
        
        if opt.b <= 8
           imwrite(uint8(pattern),[saving_folder filesep opt.patname '_' num_string]);
        else
           imwrite(uint16(pattern),[saving_folder filesep opt.patname '_' num_string]);
        end
    
    end
   
    %- Simulating SPC measurements
    m = P*f;
    if opt.noise
       rng(1); % to get predictable sequence of numbers
       m = poissrnd(opt.dt/max_dyn * m + opt.dt * opt.alpha); 
       m = (max_dyn / opt.dt) * T * m;
    else
       m = T * m;
    end
end
    
end

