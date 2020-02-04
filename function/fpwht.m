function [y_pos, y_neg] = fpwht(x,N,ordering)
%FPWHT Fast Positive Discrete Walsh-Hadamard Transform
%   Y = FWHT(X) is the discrete Walsh-Hadamard transform of vector X. The 
%   transform coefficients are stored in Y. If X is a matrix, the function 
%   operates on each column.  
%
%   Y = FWHT(X,N) is the N-point discrete Walsh-Hadamard transform of the 
%   vector X where N must be a power of two. X is padded with zeros if it 
%   has less than N points and truncated if it has more. The default value
%   of N is equal to the length of the vector X if it is a power of two or
%   the next power of two greater than the signal vector length. The
%   function errors out if N is not equal to a power of two.
%
%   Y = FWHT(X,N,ORDERING) or FWT(X,[],ORDERING) specifies the order of the
%   Walsh-Hadamard transform coefficients. ORDERING can be 'sequency', 
%   'hadamard' or 'dyadic'. Default ORDERING type is 'sequency'.
%
%   
%   EXAMPLES:
%
%   % Example 1: Walsh-Hadamard transform of a signal made up of Walsh 
%                % functions
%                w1 = [1 1 1 1 1 1 1 1];
%                w2 = [1 1 1 1 -1 -1 -1 -1];
%                w3 = [1 1 -1 -1 -1 -1 1 1];
%                w4 = [1 1 -1 -1 1 1 -1 -1];
%                x = w1 + w2 + w3 + w4; % signal formed by adding Walsh 
%                                       % functions  
%                y = fwht(x); % first four values of y should be non-zero 
%                             % equal to one
%
%   % Example 2: Walsh-Hadamard transform - 'hadamard' function and ordering
%                w = hadamard(8); % Walsh functions in Hadamard order
%                x = w(:,1) + w(:,2) + w(:,3) + w(:,4);
%                y = fwht(x,[],'hadamard'); % first four values equal to one
%
%   For more information see the <a href="matlab:web(fullfile(docroot,'signal/examples/discrete-walsh-hadamard-transform.html'))">Discrete Walsh-Hadamard Transform Example</a> 
%   or enter "doc fwht" at the MATLAB command line.
%   See also IFWHT, FFT, IFFT, DCT, IDCT, DWT, IDWT.

%   Copyright 2008-2013 The MathWorks, Inc.

%   Author: N. Ducros
%   Institution: Creatis laboratory, University of Lyon, France
%   Date: 30 Nov 2018

% error out if number of input arguments is not between 1 and 3
narginchk(1,3)
if isempty(x)
    y_pos = [];
    y_neg = [];
    return
end
% check optional inputs' specifications and/or make default assignments
if nargin < 3
    ordering = 'sequency';  % default ordering is sequency
    if nargin < 2
        N = defaulttransformlength(size(x));
    end
end

% Cast to enforce precision rules. 
N = signal.internal.sigcasttofloat(N,'double','fwht','N','allownumeric');
signal.internal.sigcheckfloattype(x,'','fwht','X');

if isempty(N)
  N = defaulttransformlength(size(x));
end
validatetransformlength(N);
validateordering(ordering);

% do pre-processing on input signal if necessary
[x,tFlag] = preprocessing(x,N,ordering);

% calculate first stage coefficients and store them in x_pos and x_neg
ind_odd = 1:2:N-1;
x_pos = zeros(size(x));
x_pos(ind_odd) = x(ind_odd)+ x(ind_odd+1);
x_pos(ind_odd+1) = x(ind_odd)
x_neg = zeros(size(x));
x_neg(ind_odd+1) = x(ind_odd+1)

L = 1;
% same data type as x to enforce precision rules
y_pos = zeros(size(x),class(x)); %#ok<ZEROLIKE> 
y_neg = zeros(size(x),class(x)); %#ok<ZEROLIKE> 
for nStage = 2:log2(N) % log2(N) = number of stages in the flow diagram
    % calculate coefficients for the ith stage specified by nStage
    M = 2^L;
    J = 0; K = 1;
    while (K < N)
        for j = J+1:2:J+M-1
            if strcmpi(ordering,'sequency') == 1
                y_pos(K,:) = x_pos(j,:) + x_pos(j+M,:);
                y_pos(K+1,:) = x_pos(j,:);
                y_pos(K+2,:) = x_pos(j+1,:);
                y_pos(K+3,:) = x_neg(j+1,:) + x_neg(j+1+M,:);
                %
                y_neg(K,:) = 0;
                y_neg(K+1,:) = x_neg(j+M,:);
                y_neg(K+2,:) = x_pos(j+1+M,:);
                y_neg(K+3,:) = 0;
                
                %-- test
                y_pos(K,:) = x_pos(j,:) + x_pos(j+M,:);
                y_pos(K+1,:) = x_pos(j,:);
                y_pos(K+2,:) = x_pos(j+1,:);
                y_pos(K+3,:) = x_neg(j+1,:) + x_neg(j+1+M,:);
                %
                y_neg(K,:) = 0;
                y_neg(K+1,:) = x_neg(j+M,:);
                y_neg(K+2,:) = x_pos(j+1+M,:);
                y_neg(K+3,:) = x_neg(j+1,:) + x_neg(j+1+M,:);
                
            else
                y_pos(K,:) = x_pos(j,:) + x_pos(j+M,:);
                y_pos(K+1,:) = x_pos(j,:);
                y_pos(K+2,:) = x_pos(j+1,:) + x_pos(j+1+M,:);
                y_pos(K+3,:) = x_pos(j+1,:);
                %
                y_neg(K,:) = 0;
                y_neg(K+1,:) = x_neg(j+M,:);
                y_neg(K+2,:) = 0;
                y_neg(K+3,:) = x_neg(j+1+M,:);
            end
            K = K + 4;
        end
        J = J + 2*M;
    end
    % store coefficients in x at the end of each stage
    x_pos = y_pos,
    x_neg = y_neg,
    L = L + 1;
end
% perform scaling of coefficients
y_pos = x_pos ./ N;
y_neg = x_neg ./ N;

if tFlag
    y_pos = transpose(y_pos);
    y_neg = transpose(y_neg);
end

%--------------------------------------------------------------------------

function validatetransformlength(N)
% check if transform length is specified correctly - positive scalar and
% power of two
% sigDim = [rows cols] of input signal

if ~isempty(find(char(num2str(log2(N)))=='.', 1)) || (N < 1)
    error(message('signal:fwht:InvalidTransformLength'));
end
 
%--------------------------------------------------------------------------

function N = defaulttransformlength(sigDim) 
% this function assigns default transform length as signal length if it is
% a power of two or the next power of two greater than signal length
% sigDim = [rows cols] of input signal

if min(sigDim) == 1
    N = max(sigDim);
else
    N = sigDim(1);
end
if ~isempty(find(char(num2str(log2(N)))=='.', 1))
    p = ceil(log2(N));
    N = 2^p;
end

%--------------------------------------------------------------------------

function validateordering(ordering) 
% this functions checks if the specified ordering is a string input and one
% of sequency, hadamard or dyadic'
if ~ischar(ordering) || ~any(strcmpi(ordering,{'sequency','hadamard','dyadic'}))
    error(message('signal:fwht:InvalidOrderingType', 'ORDERING', 'sequency', 'hadamard', 'dyadic'));
end
    
%--------------------------------------------------------------------------

function [x,tFlag] = preprocessing(x,N,ordering)
% this function performs zero-padding, truncation or input bit-reversal if
% necessary. NROWS amd MCOLS specify the output orientation which is kept
% same as that of input.

tFlag = false;
if size(x,1) == 1
    x = x(:); % column vectorizing input sequence
    tFlag = true;
end
n = size(x,1);    
if n < N
    % zero-pad
    x(n+1:N,:) = 0;
elseif n > N
    % truncate
    x = x(1:N,:);
end
% Re-arrange input in bit-reversed order if ordering is hadamard
if strcmpi(ordering,'hadamard') == 1
    x = bitrevorder(x);
end

%--------------------------------------------------------------------------