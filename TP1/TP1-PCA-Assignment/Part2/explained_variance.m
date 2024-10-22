function [ exp_var, cum_var, p ] = explained_variance( L, Var )
%EXPLAINED_VARIANCE Function that returns the optimal p given a desired
%   explained variance. The student should convert the Eigenvalue matrix 
%   to a vector and visualize the values as a 2D plot.
%   input -----------------------------------------------------------------
%   
%       o L      : (N x N), Diagonal Matrix composed of lambda_i 
%       o Var    : (1 x 1), Desired Variance to be explained
%  
%   output ----------------------------------------------------------------
%
%       o exp_var  : (N x 1) vector of explained variance
%       o cum_var  : (N x 1) vector of cumulative explained variance
%       o p        : optimal principal components given desired Var


% ====================== Implement Eq. 8 Here ====================== 
N = size(L,1);
exp_var = [];
lambda = diag(L);
lambda_sum = sum(lambda);
for i=1:1:N
    exp_var(i,1) = lambda(i)/lambda_sum;
end   

% ====================== Implement Eq. 9 Here ======================

cum_var = cumsum(exp_var);
% ====================== Implement Eq. 10 Here ====================== 
cum_var_prime = cum_var;
cum_var_prime(find(cum_var_prime<Var))=Inf;
[~,p] = min(cum_var_prime);

% Visualize/Plot Explained Variance from Eigenvalues
figure
hold on
plot(cum_var,'r--')
plot(p,cum_var(p),'ro')
xlabel("Eigenvector Index")
ylabel("%Cumulative Variance Explained")
title("Explained Variance from Eigenvalues")
grid on
ax = gca;
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
ax.Layer = 'top';

end

