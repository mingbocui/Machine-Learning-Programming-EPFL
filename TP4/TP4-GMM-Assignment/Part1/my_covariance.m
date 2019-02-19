function [ Sigma ] = my_covariance( X, X_bar, type )
%MY_COVARIANCE computes the covariance matrix of X given a covariance type.
%
% Inputs -----------------------------------------------------------------
%       o X     : (N x M), a data set with M samples each being of dimension N.
%                          each column corresponds to a datapoint
%       o X_bar : (N x 1), an Nx1 matrix corresponding to mean of data X
%       o type  : string , type={'full', 'diag', 'iso'} of Covariance matrix
%
% Outputs ----------------------------------------------------------------
%       o Sigma : (N x N), an NxN matrix representing the covariance matrix of the 
%                          Gaussian function
%%

% Auxiliary Variable
[N, M] = size(X);

% Output Variable
Sigma = zeros(N, N);

zeroed_X = X - X_bar;
switch type
    case 'full'
        Sigma = (1/(M-1)) * (zeroed_X * zeroed_X');
    case 'diag'
        Sigma = diag(diag((1/(M-1)) * (zeroed_X * zeroed_X')));
    case 'iso'
        sig_iso = (1/(N*M)) * sum(sum(zeroed_X.^2,1));
        zerosw = zeros(1,N);
        zeros_ = zerosw + sig_iso;
        Sigma = diag(zeros_);
end





end

