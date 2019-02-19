function [y_est, var_est] = my_gmr(Priors, Mu, Sigma, X, in, out)
%MY_GMR This function performs Gaussian Mixture Regression (GMR), using the 
% parameters of a Gaussian Mixture Model (GMM) for a D-dimensional dataset,
% for D= N+P, where N is the dimensionality of the inputs and P the 
% dimensionality of the outputs.
%
% Inputs -----------------------------------------------------------------
%   o Priors:  1 x K array representing the prior probabilities of the K GMM 
%              components.
%   o Mu:      D x K array representing the centers of the K GMM components.
%   o Sigma:   D x D x K array representing the covariance matrices of the 
%              K GMM components.
%   o X:       N x M array representing M datapoints of N dimensions.
%   o in:      1 x N array representing the dimensions of the GMM parameters
%                to consider as inputs.
%   o out:     1 x P array representing the dimensions of the GMM parameters
%                to consider as outputs. 
% Outputs ----------------------------------------------------------------
%   o y_est:     P x M array representing the retrieved M datapoints of 
%                P dimensions, i.e. expected means.
%   o var_est:   P x P x M array representing the M expected covariance 
%                matrices retrieved. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,M] = size(X);
[D,K] = size(Mu);
P = D-N;

beta_sum = 0;
% maybe could be replaced by smart matrix calculation
for i=1:K
    prob = my_gaussPDF(X, Mu(in,i), Sigma(in,in,i));
    beta_sum = beta_sum + Priors(1,i)*prob; 
end
for i=1:K
    prob = my_gaussPDF(X, Mu(in,i), Sigma(in,in,i));
    beta(i,:) = (Priors(1,i) * prob)./ beta_sum;
end
% calculate uk
uk_p = zeros(P,M,K);
for i=1:K
    uk_p(:,:,i) = repmat(Mu(out,i),1,M) + Sigma(out,in,i) * pinv(Sigma(in,in,i)) * (X - repmat(Mu(in,i),1,M));
end

y_est = zeros(P,M);
for i=1:K
    y_est = y_est + (repmat(beta(i,:),P,1)).* uk_p(:,:,i);
end
Sigma_p = zeros(P,P,K);
for i=1:K
    Sigma_p(:,:,i) = Sigma(N+1:end,N+1:end,i) - Sigma(N+1:end,1:N,i)*pinv(Sigma(1:N,1:N,i))*Sigma(1:N,N+1:end,i);
end
var_est = zeros(P,P,M);
for i = 1:M
    var_sum = zeros(P);
    for j = 1:K
        temp = beta(j,i)*(uk_p(:,i,j)*uk_p(:,i,j)'+Sigma_p(:,:,j));
        var_est(:,:,i) = var_est(:,:,i) + temp;
        temp2 = beta(j,i)*uk_p(:,i,j);
        var_sum = var_sum + temp2;
    end
    var_est(:,:,i) = var_est(:,:,i) - var_sum*var_sum';
end
end