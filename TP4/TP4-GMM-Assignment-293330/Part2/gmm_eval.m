function [AIC_curve, BIC_curve] =  gmm_eval(X, K_range, repeats, params)
%GMM_EVAL Implementation of the GMM Model Fitting with AIC/BIC metrics.
%
%   input -----------------------------------------------------------------
%       o X        : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o K_range  : (1 X K), Range of k-values to evaluate
%       o repeats  : (1 X 1), # times to repeat k-means
%       o params : Structure containing the paramaters of the algorithm:
%           * cov_type: Type of the covariance matric among 'full', 'iso',
%           'diag'
%           * d_type: Distance metric for the k-means initialization
%           * init: Type of initialization for the k-means
%           * max_iter_init: Max number of iterations for the k-means
%           * max_iter: Max number of iterations for EM algorithm
%
%   output ----------------------------------------------------------------
%       o AIC_curve  : (1 X K), vector of max AIC values for K-range
%       o BIC_curve  : (1 X K), vector of max BIC values for K-range
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Additional variables
AIC_curve = zeros(1, length(K_range));
BIC_curve = zeros(1, length(K_range));

for i=1:length(K_range)
    AIC_prev=zeros(1,repeats);
    BIC_prev=zeros(1,repeats);
    params.k = K_range(i);
    for j=1:repeats    
          [  Priors, Mu, Sigma, ~ ] = my_gmmEM(X, params);
          [AIC_prev(1,j), BIC_prev(1,j)] =  gmm_metrics(X, Priors, Mu, Sigma, params.cov_type);
    end
    AIC_curve(1,i) = min(AIC_prev);
    BIC_curve(1,i) = min(BIC_prev);
    
end



end