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
Pk_x  = zeros(params.k,M);
Pk_x_aux  = zeros(params.k,M);
K = params.k;
% for i=1:K
%     sum = 0;
%     for n=1:K
%         sum = sum + 
%     end
%     for j=1:M
%         Priors(1,i)*my_gaussPDF(X(:,j), Mu(:,i), Sigma(:,:,i));
%         prob = my_gaussPDF(X, Mu, Sigma)
%         Pk_x(i,j) = 
%     end
% end

for i=1:M
    sum = 0;
    for n=1:K
        sum =sum + Priors(1,n)*my_gaussPDF(X(:,i), Mu(:,n), Sigma(:,:,n));
    end
    for j=1:K
        Pk_x(j,i) = Priors(1,j)*my_gaussPDF(X(:,i), Mu(:,j), Sigma(:,:,j))/sum;
    end
end

% for i =1:K
% Pk_x_aux(i,:) = my_gaussPDF(X, Mu(:,i), Sigma(:,:,i));
% end
% Pk_x_aux2 = sum(Pk_x_aux,1);
% Pk_x = Pk_x_aux2./ (Priors*Pk_x_aux);
%
%
%
%
%



end

