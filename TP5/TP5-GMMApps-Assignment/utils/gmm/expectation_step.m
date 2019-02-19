function [Pk_x] = expectation_step(X, Priors, Mu, Sigma, params)
%EXPECTATION_STEP Computes the expection step of the EM algorihtm
% input------------------------------------------------------------------
%       o X         : (N x M), a data set with M samples each being of 
%                           dimension N, each column corresponds to a datapoint.
%       o Priors    : (1 x K), the set of updated priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu        : (N x K), an NxK matrix corresponding to the CURRENT centroids mu^(0) = {mu^1,...mu^K}
%       o Sigma     : (N x N x K), an NxNxK matrix corresponding to the CURRENT Covariance matrices   
% 					Sigma^(0) = {Sigma^1,...,Sigma^K} 
%       o params    : The hyperparameters structure that contains k, the number of Gaussians
% output----------------------------------------------------------------
%       o Pk_x      : (K, M) a KxM matrix containing the posterior probabilty that a k Gaussian is responsible
%                     for generating a point m in the dataset 
%%

% Additional variables
[N, M] = size(X);
Px_k = zeros(params.k,M);

% Compute probabilities p(x^i|k)
for k=1:params.k
    Px_k(k,:) = my_gaussPDF(X, Mu(:,k), Sigma(:,:,k));
end
    
%%% Compute posterior probabilities p(k|x) -- FAST WAY --- %%%
alpha_Px_k = repmat(Priors',[1 M]).*Px_k;
Pk_x = alpha_Px_k ./ repmat(sum(alpha_Px_k,1),[params.k 1]);    
    
    %%% Compute posterior probabilities p(k|x) -- SLOW WAY --- %%%
%     for i=1:M
%       Pk_x(:,i) = (Priors'.*Px_k(:,i))./(sum(Priors'.*Px_k(:,i)));
%     end      

end

