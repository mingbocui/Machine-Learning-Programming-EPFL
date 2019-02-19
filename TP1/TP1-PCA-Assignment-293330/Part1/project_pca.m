function [A_p, Y] = project_pca(X, Mu, V, p)
%PROJECT_PCA Compute Projection Matrix and Projected data y
%   In this function, the student should construct the projection matrix
%   from the Eigenvectors and the data projected to lower-dimensional space
%   by following Eq. 4 and 5 in Assignment 1.
%
%   input -----------------------------------------------------------------
%   
%       o X      : (N x M), a data set with M samples each being of dimension N.
%       o Mu     : (M x 1), Mean Vector from Original Data
%       o V      : (N x N), Eigenvector Matrix from PCA.
%       o p      :  Number of Components to keep.
%
%   output ----------------------------------------------------------------
%
%       o A_p    : (p x N), Projection Matrix.
%       o Y      : (p x M), Projected data set with N samples each being of dimension k.

% Auxiliary variables
[N, M] = size(X);

% Output Variables
A_p = [];
Y   = [];

% ====================== Implement Eq. 4 Here ====================== 
A_p = V(:,1:p)';
% ====================== Implement Eq. 5 Here ====================== 
X = X - Mu;
Y = A_p* X;

end