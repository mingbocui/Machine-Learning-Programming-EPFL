function [RSS, AIC, BIC] =  my_metrics(X, labels, Mu)
%MY_METRICS Computes the metrics (RSS, AIC, BIC) for clustering evaluation
%
%   input -----------------------------------------------------------------
%   
%       o X        : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o labels   : (1 x M), a vector with predicted labels labels \in {1,..,k} 
%                   corresponding to the k-clusters.
%       o Mu       : (N x k), an Dxk matrix where the k-th column corresponds
%                          to the k-th centroid mu_k \in R^D
%
%   output ----------------------------------------------------------------
%
%       o RSS      : (1 x 1), Residual Sum of Squares
%       o AIC      : (1 x 1), Akaike Information Criterion
%       o BIC      : (1 x 1), Bayesian Information Criteria
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxiliary Variables
% [D, N] = size(X);
% [~, K] = size(Mu);
[N, M] = size(X);
[N, K] = size(Mu);

% Compute RSS (Equation 8)
RSS  = 0; 
AIC  = 0;
BIC  = 0;
for i = 1:M
    RSS = RSS + sum(power(X(:,i)-Mu(:,labels(i)),2));
end
AIC = RSS + 2 * K * N;
BIC = RSS + K * N * log(M);



end