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

%Compute the likelihood of each datapoint for each K
P_xi = zeros(K,M);
for i=1:K
    P_xi(i,:) = my_gaussPDF(X, Mu(:,i), Sigma(:,:,i));
end

%Compute the total log likelihood
alpha_P_xi = Priors*P_xi;
alpha_P_xi(alpha_P_xi < realmin) = realmin;
logl = sum(log(alpha_P_xi));


end

