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

Priors = mean(Pk_x,2)';


for i=1:params.k
    Mu(:,i) = sum((Pk_x(i,:).*X),2)./sum(Pk_x(i,:));
end

Sig = zeros(N,N,params.k);
Sig_diag = zeros(N,N,params.k);
Sig_iso = zeros(N,N,params.k);
% for i=1:params.k
%    Sig(:,:,i) = ((Pk_x(i,:).*(X-Mu(:,i))) * (X-Mu(:,i))')./sum(Pk_x(i,:));
% end
% 
% for i=1:params.k
%     sum1 = zeros(N,N);
%     for j=1:M
%         sum1 = sum1 + Pk_x(i,j) * (X(:,j) - Mu(:,i)) * (X(:,j) - Mu(:,i))';
%     end
%     Sig(:,:,i) = sum1./sum(Pk_x(i,:));
%     Sig_2(:,:,i) = Sig(:,:,i) + 1e-5;
%     Sig_diag(:,:,i) = diag(diag(Sig_2(:,:,i)));
% %    Sig(:,:,i) = ((Pk_x(i,:).*(X-Mu(:,i))) * (X-Mu(:,i))')./sum(Pk_x(i,:));
% 
% end
for i=1:params.k
% Mu(:,i) = sum((Pk_x(i,:).*X),2)./sum(Pk_x(i,:));
Sig(:,:,i) = (repmat(Pk_x(i,:),N,1).*(X-Mu(:,i)) * (X-Mu(:,i))')./sum(Pk_x(i,:));
Sig(:,:,i) = Sig(:,:,i) +1e-5;
Sig_diag(:,:,i) = diag(diag(Sig(:,:,i)));
aux = sum(Pk_x(i,:).*sum((X-Mu(:,i)).*(X-Mu(:,i)),1))/(N * sum(Pk_x(i,:)));
zerodiag = zeros(1,N) +aux;
Sig_iso(:,:,i) = diag(zerodiag);
end

% Sig = Sig + 1e-5;

switch params.cov_type
    case 'full'
        Sigma = Sig;
    case 'diag'
        Sigma = Sig_diag;
%         Sigma = diag(diag(Sig));
    case 'iso'
        Sigma = Sig_iso;
%         for i=1:params.k
%             sum2 = 0;
%             for j=1:M
%                 sum2 = sum2 + Pk_x(i,j) * (X(:,j) - Mu(:,i))' * (X(:,j) - Mu(:,i));
%             end
%             sum2 = sum2 / (N * sum(Pk_x(i,:)));
%             zerodiag = zeros(1,N) + sum2;
%             Sigma(:,:,i) = diag(zerodiag);
%         end
%         Sigma = Sigma +1e-5;
end





end

