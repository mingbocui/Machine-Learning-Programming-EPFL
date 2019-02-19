function prob = my_gaussPDF(X, Mu, Sigma)
%MY_GAUSSPDF computes the Probability Density Function (PDF) of a
% multivariate Gaussian represented by a mean and covariance matrix.
%
% Inputs -----------------------------------------------------------------
%       o X     : (N x M), a data set with M samples each being of dimension N.
%                          each column corresponds to a datapoint
%       o Mu    : (N x 1), an Nx1 vector corresponding to the mean of the 
%							Gaussian function
%       o Sigma : (N x N), an NxN matrix representing the covariance matrix 
%						   of the Gaussian function
% Outputs ----------------------------------------------------------------
%       o prob  : (1 x M),  a 1xM vector representing the probabilities for each 
%                           M datapoints given Mu and Sigma    
%%

% Auxiliary Variables
[N,M] = size(X);
centeralized_X = X - Mu;
coef = 1/(((2*pi)^(N/2)) * sqrt(det(Sigma)));
% prob=zeros(1,M);
matrix_conv = -0.5 * centeralized_X' * pinv(Sigma) * centeralized_X;
diag_mat = (diag(matrix_conv))';
%alaways no need to loop on samples 
prob = coef * exp(diag_mat);





end