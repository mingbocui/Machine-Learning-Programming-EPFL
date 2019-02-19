function [ logl ] = my_gmmLogLik(X, Priors, Mu, Sigma)
%MY_GMMLOGLIK Compute the likelihood of a set of parameters for a GMM
%given a dataset X
%
%   input------------------------------------------------------------------
%
%       o X      : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o Priors : (1 x K), the set of priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu     : (N x K), an NxK matrix corresponding to the centroids mu = {mu^1,...mu^K}
%       o Sigma  : (N x N x K), an NxNxK matrix corresponding to the 
%                    Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%
%   output ----------------------------------------------------------------
%
%      o logl       : (1 x 1) , loglikelihood
%%


% Auxiliary Variables
[N, M] = size(X);
[~, K] = size(Mu);

% prob = my_gaussPDF(X, Mu, Sigma);
% sum_M =0;
% for i =1:M
%     sum_K = 0;
%     for j=1:K
%         sum_K = sum_K + Priors(1,j)*my_gaussPDF(X(:,i), Mu(:,j), Sigma(:,:,j));
%     end
%     sum_M = sum_M + log(sum_K);
% end
% 
% logl = sum_M;
logl = 0;

prob_prev =zeros(K,M);
for j=1:K
    prob_prev(j,:) = my_gaussPDF(X, Mu(:,j), Sigma(:,:,j));
%     Priors(1,j)*
%     logl = logl + log(Priors(1,j) * sum(my_gaussPDF(X, Mu(:,j), Sigma(:,:,j))));
end

logl = sum(log(Priors * prob_prev));






end

