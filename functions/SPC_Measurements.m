% SPC_Measurements -- Function used to simulate the sequential Single-pixel
% Camera measurements with different patterns. Poisson noise can also be
% applied to the measurements if the option is specified.
%
%  --> Input  
%    f              vectorized version of the image F
%    ind_pattern    indices of the wavelet patterns to project
%    opt            structure containing different options and parameters
%    q_f_vec        quantization vector for the patterns corresponding to
%                   ind_pattern
%
%  --> Ouput
%    m              vector containing the different SPC measurements
%                   corresponding to the projection of f onto the patterns 
%                   specified by ind_pattern
%
%  --> Usage
%    m = SPC_Measurements(f,ind_pattern,opt,q_f_vec)
%
%  See Also
%    ABS_WP, Create_Pattern_Indexing_map, Create_and_Save_Wavelet_Patterns
%
%  Author : F. Rousset
%  Institution : University of Lyon - CREATIS
%  Date : 12/15/16
%  License : CC-BY-SA 4.0 http://creativecommons.org/licenses/by-sa/4.0/

function m = SPC_Measurements(f,ind_pattern,opt,q_f_vec)

nb_mes = length(ind_pattern);
m_pos = zeros(nb_mes,1);
m_neg = zeros(nb_mes,1);
wavelet_folder = [opt.pattern_folder filesep opt.wavelet_type];

tic
for i = 1:nb_mes
    % Read the pos and neg pattern corresponding to ind_pattern(i)
    p_pos = double(imread([wavelet_folder filesep opt.wavelet_type '_' num2str(2*ind_pattern(i)-1) '.png']));
    p_neg = double(imread([wavelet_folder filesep opt.wavelet_type '_' num2str(2*ind_pattern(i)) '.png']));
   
    m_pos(i) = f' * p_pos(:); % One SPC measurement
    m_neg(i) = f' * p_neg(:); % One SPC measurement
   
end

if opt.noise
   m = poissrnd(opt.Delta_t * q_f_vec .* m_pos) - poissrnd(opt.Delta_t * q_f_vec .* m_neg); 
else
    m = m_pos - m_neg;  % Final SPC measurement
    m = m .* q_f_vec;   % Scale back with the quantization factor
end
 


end
