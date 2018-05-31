function [T,P,itr,err,errvec] = ncsnmf(Q, dyn, maxitr,tol)
% NCSNMF   Normalized constrained semi-non negative matrix factorization
%   [T,P] = NCSNMF(Q,dyn), where Q is M-by-N, produces an (M+1)-by-M 
%   matrix T and an M-by-N matrix P so that Q = T*P, where sum(T(i,:)) = 0 
%   and max(P(i,:)) = dyn, for all i. If dyn is [] then NCSNMF uses the
%   default, 2*M.
%
%   [T,P] = NCSNMF(Q,dyn,itrMax) specifies the maximum number of iterations.
%   If itrMax is [] then NCSNMF uses the default, 2*M.
%
%   [T,P] = NCSNMF(Q,dyn,itrMax,tol) specifies the tolerance for the 
%   relative factorization error ||Q-TP||_F^2/||Q||_F^2. If tol is [] then 
%   NCSNMF uses the default, 1e-3.
%
%   [T,P,itr] = NCSNMF(Q,...) also returns the number of iterations.
%
%   [T,P,itr,err] = NCSNMF(Q,...) also returns the relative factorization 
%   error ||Q-TP||_F^2/||Q||_F^2.
%   
%   [T,P,itr,err,errvec] = NCSNMF(Q,...) also returns the relative 
%   factorization error at each iteraction.
%
%   NCSNMF implements the constrained algorithm that was proposed in [1], 
%   which relies heavily on the SNMF method introduced in [2].
%
%   Examples:
%   Q = rand(15,100); [T,P] = ncsnmf(Q); sum(T,2)./max(T,[],2)
% 
%   See also ABSWP, SPC, SPIRITOPT

%   Reference : 
%   [1] F. Rousset et al., "A Semi Nonnegative Matrix Factorization 
%   Technique for Pattern Generalization in Single-Pixel Imaging", IEEE 
%   Transactions on Computational Imaging, 2018.
%
%   [2] N. Gillis and A. Kumar, “Exact and heuristic algorithms for semi-
%   nonnegative matrix factorization,” SIAM Journal on Matrix Analysis and
%   Applications, vol. 36, no. 4, pp. 1404–1424, 2015.

%   Author: F. Rousset, N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Apr 2018
%   Toolbox: SPIRiT 2.0, https://github.com/nducros/SPIRIT
%   License: CC-BY-SA 4.0, https://creativecommons.org/licenses/by-sa/4.0/

%% Initialization and default
% Discard the columns of Q that contain only zeros
q = sum(abs(Q)); % if q(i) == 0 then Q(:,i) is an null column
ind_not_null = (q ~= 0);
Q_r = Q(:,ind_not_null);

% Init matrix factorization
[M,N2] = size(Q_r);
K = M + 1;
rng(1); % to get predictable sequence of numbers
P_r = rand(K,N2);

% Default values to unspecified parameters
if nargin < 2 || isempty(dyn)
    dyn = 255;
end
if nargin < 3 || isempty(maxitr)
    maxitr = 2*M;
end
if nargin < 4 || isempty(tol)
    tol = 1e-5;
end

% Init output arguments
itr = 0;
err = 1e10;
errvec = zeros(maxitr,1);

%% Matrix factorization algorithm
UNS = ones(K,K);
E = eye(K);
normQ2 = norm(Q,'fro')^2;

% Main loop
while err > tol && itr < maxitr
    
    %- Update T so that sum(T(i,:)) = 0 for all i
      P_P_t = P_r*P_r';
    if rcond(P_P_t) > 1e-10
        A = E / P_P_t; % inv(P_P_t)
    else
        A =  E / (P_P_t + 1e-10*E); % pinv(P_P_t);
    end
    T = Q_r * P_r' * A * (E - 1/sum(A(:)) * UNS * A );

    %- Update V with Gillis' method and code
    T_t_T = T'*T; 
    T_t_Q = T'*Q_r; 
    for k = 1:K
        row_P_k = P_r(k,:);
        %
        V_new = ( T_t_Q(k,:) - T_t_T(k,:)*P_r ) / T_t_T(k,k);
        V_new = max(V_new,-row_P_k);
        %
        row_P_k = row_P_k + V_new;        
        P_r(k,:) = row_P_k;
    end
    
    %- Set maximun value of each pattern to max_dyn
    vect_max_P = max(P_r,[],2);
    f = dyn * ones(K,1) ./ vect_max_P;
    for k = 1:K         % Possibily not enough memory using repmat
        P_r(k,:) = f(k) * P_r(k,:);
        T(:,k) = T(:,k) / f(k); % T is compensated
    end
    
    %- Relative factorization error
    itr = itr + 1;
    err = norm(Q_r-T*P_r,'fro')^2/normQ2;
    errvec(itr) = err;
    fprintf('Iteration %d : error = %f\n',itr,err);
end

% discard zeros
errvec = errvec(1:itr);

%% 
% Put zero columns back to P
P = zeros(K,size(Q,2)); 
P(:,ind_not_null) = P_r; 

end

