function [e_rec] = reconstruction_error(X, X_hat)
%RECONSTRUCTION_ERROR Compute reconstruction error
%   In this function, the student should compute the reconstruction error
%   between the original dataset and the reconstructed one, by following
%   Eq. 7 from Assignment 1.
%
%   input -----------------------------------------------------------------
%   
%       o X      : (N x M), original data set with M samples each being of dimension N.
%       o X_hat  : (N x M), reconstructed data set with M samples each being of dimension N.
%
%   output ----------------------------------------------------------------
%
%       o e_rec  :  reconstruction error

% ====================== Implement Eq. 7 Here ====================== 
e_rec = [];
e_rec = norm(X-X_hat);
end