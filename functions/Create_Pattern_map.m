% Create_Pattern_map -- Function used to create the wavelet patterns for
% some specified wavelet coefficient locations. The patterns are stored as
% vectors in a matrix used as output.
%
%  --> Input  
%    ind            indices ordered by Matlab for the desired wavelet
%                   patterns
%    ind_pattern    indices ordered differently according to the PI_map
%                   obtained by Create_Pattern_Indexing_map
%    J              maximum decomposition level of the wavelet transform
%    N              size of the patterns N x N
%    wavelet_param  gives the parameters for a given wavelet, see
%                   Get_Wavelet_Parameters
%
%  --> Ouput
%    Pattern_map    map containing the wavelet patterns for the indices ind
%                   stored as row vectors
%
%  --> Usage
%    Pattern_map = Create_Pattern_map(ind,ind_pattern,J,N,wavelet_param)
%
%  See Also
%    Create_E_map, Create_Pattern_Indexing_map, Create_and_Save_Wavelet_Patterns
%
%  Author : F. Rousset - 28/04/16

function Pattern_map = Create_Pattern_map(ind,ind_pattern,J,N,wavelet_param)

I = length(ind);
Pattern_map = sparse(zeros(I,N*N));
L = log2(N) - J;
Z = zeros(N,N);

for i = 1:I
    Z(ind(i)) = 1; % Set to 1 the location for which you want the pattern
    
    if ~wavelet_param{1}     
        pattern = IWT2_PO(Z,L,wavelet_param{2}); % Corresponding pattern
    else
        % Inversion between the wavelet and the dual for biorthogonal wavelets
        pattern = IWT2_PBS(Z,L,wavelet_param{3},wavelet_param{2});   
    end
        
    Pattern_map(i,:) = pattern(:);
    
    fprintf('Pattern %d / %d created and saved\n',ind_pattern(i),N*N);
    Z(ind(i)) = 0;
end
Pattern_map = sparse(Pattern_map);
