function [Priors,Mu,Sigma] = maximization_step(X, Pk_x, params)
%MAXIMISATION_STEP Compute the maximization step of the EM algorithm
%   input------------------------------------------------------------------
%       o X         : (N x M), a data set with M samples each being of 
%       o Pk_x      : (K, M) a KxM matrix containing the posterior probabilty
%                     that a k Gaussian is responsible for generating a point
%                     m in the dataset, output of the expectation step
%       o params    : The hyperparameters structure that contains k, the number of Gaussians
%                     and cov_type the coviariance type
%   output ----------------------------------------------------------------
%       o Priors    : (1 x K), the set of updated priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu        : (N x K), an NxK matrix corresponding to the updated centroids 
%                           mu = {mu^1,...mu^K}
%       o Sigma     : (N x N x K), an NxNxK matrix corresponding to the
%                   updated Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%%

% Additional variables
[N, M] = size(X);
Priors = zeros(1,params.k);
Mu = zeros(N,params.k);
Sigma = zeros(N,N,params.k);
eps = 1e-5;

% Compute cumulated posterior probability
Sum_Pk_x = sum(Pk_x,2);

% Update Means and Covariance Matrix
for k=1:params.k
    % Update Priors
    Priors(k) = Sum_Pk_x(k)/M;

    % Update Means
    Mu(:,k) = X*Pk_x(k,:)' / Sum_Pk_x(k);         

    %%% Update Full Covariance Matrices  -- FAST WAY --- %%%
    % Demean Data
    X_ = bsxfun(@minus, X, Mu(:,k));                
    % Compute Full Sigma
    Sigma(:,:,k) = (repmat(Pk_x(k,:),N,1).*X_*X_')./ Sum_Pk_x(k); 

    %%% Update Full Covariance Matrices  -- SLOW WAY ---  %%%               
%     Sigma_ = zeros(N,N);
%     for i=1:M 
%        Sigma_ = Sigma_ + (Pk_x(k,i) * (X(:,i)- Mu(:,k))*(X(:,i)- Mu(:,k))'); 
%     end
%     Sigma(:,:,k) = Sigma_/ Sum_Pk_x(k);        

    switch params.cov_type
        case 'diag'
            Sigma(:,:,k) = diag(diag(Sigma(:,:,k)));

        case 'iso'
            sqr_dist = sum((X - repmat(Mu(:,k),1,M)).^2,1);                                
            Sigma(:,:,k) = eye(N,N)*(sqr_dist*Pk_x(k,:)' ./ Sum_Pk_x(k) ./N); 

    end        

    % Add a tiny variance to avoid numerical instability
    Sigma(:,:,k) = Sigma(:,:,k) + eps.*diag(ones(N,1));
end    
end

