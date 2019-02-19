function [ Priors0, Mu0, Sigma0, labels0 ] = my_gmmInit(X, params)
%MY_GMMINIT Computes initial estimates of the parameters of a GMM 
% to be used for the EM algorithm
%   input------------------------------------------------------------------
%
%       o X         : (N x M), a data set with M samples each being of 
%                           dimension N, each column corresponds to a datapoint.
%       o params : Structure containing the paramaters of the algorithm:
%           * cov_type: Type of the covariance matric among 'full', 'iso',
%           'diag'
%           * k: Number of clusters for the k-means initialization
%           * d_type: Distance metric for the k-means initialization
%           * init: Type of initialization for the k-means
%           * max_iter_init: Max number of iterations for the k-means
%   output ----------------------------------------------------------------
%       o Priors0   : (1 x K), the set of priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu0       : (N x K), an NxK matrix corresponding to the centroids 
%                           mu = {mu^1,...mu^K}
%       o Sigma0    : (N x N x K), an NxNxK matrix corresponding to the 
%                       Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%       o labels0   : (1 x M), a vector of labels \in {1,..,k} 
%                           corresponding to the k-th Gaussian component

%%
% Auxiliary Variables
[N, M] = size(X);
K = params.k;
Sigma0 = zeros(N,N,K);

Priors0_ =zeros(1,K);
Priors0 = Priors0_ + 1/K;

% Mu0 =  kmeans_init(X, params.k, params.init);
[labels0, Mu0, Mu, iter] =  my_kmeans(X, K, params.init, params.d_type, params.max_iter_init, 0);
for i=1:K
    % we are only interested in the points in X
    Sigma0(:,:,i) = my_covariance( X(:,labels0==i), Mu0(:,i), params.cov_type );
end




end

