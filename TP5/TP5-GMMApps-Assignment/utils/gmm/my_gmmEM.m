function [  Priors, Mu, Sigma, iter, PriorsList, MuList, SigmaList ] = my_gmmEM(X, params)
%MY_GMMEM Computes maximum likelihood estimate of the parameters for the 
% given GMM using the EM algorithm and initial parameters
%   input------------------------------------------------------------------
%       o X         : (N x M), a data set with M samples each being of 
%                           dimension N, each column corresponds to a datapoint.
%       o params : Structure containing the paramaters of the algorithm:
%           * cov_type: Type of the covariance matric among 'full', 'iso',
%           'diag'
%           * k: Number of gaussians
%           * max_iter: Max number of iterations

%   output ----------------------------------------------------------------
%       o Priors    : (1 x K), the set of FINAL priors (or mixing weights) for each
%                           k-th Gaussian component
%       o Mu        : (N x K), an NxK matrix corresponding to the FINAL centroids 
%                           mu = {mu^1,...mu^K}
%       o Sigma     : (N x N x K), an NxNxK matrix corresponding to the
%                   FINAL Covariance matrices  Sigma = {Sigma^1,...,Sigma^K}
%       o iter      : (1 x 1) number of iterations it took to converge
%%

% Auxiliary Variables
logl_old = -realmax;
t_iter   = 0;

% Stopping threshold for EM iterative update
logl_thres = 1e-6;
under_thresh = 0;

%%%%%% STEP 1: Initialization of Priors, Means and Covariances %%%%%%
% ADD CODE HERE
[Priors, Mu, Sigma] = my_gmmInit(X, params);
PriorsList(1,:,:) = Priors;
MuList(1,:,:) = Mu;
SigmaList(1,:,:,:) = Sigma;
% END CODE

while t_iter <= params.max_iter && under_thresh < 10
    
    % ADD CODE HERE
    %%%%%% STEP 2: Expectation Step: Membership probabilities %%%%%%
    Pk_x = expectation_step(X, Priors, Mu, Sigma, params);
    
    %%%%%% STEP 3: Maximization Step: Update Priors, Means and Sigmas %%%%%%    
    [Priors,Mu,Sigma] = maximization_step(X, Pk_x, params);
    
    %%%%%% Stopping criterion %%%%%%
    logl = my_gmmLogLik(X, Priors, Mu, Sigma);
    if abs(logl_old - logl) < logl_thres
        under_thresh = under_thresh + 1;
    else
        under_thresh = 0;
    end
    
    logl_old = logl;
    t_iter = t_iter + 1;
    
    PriorsList(t_iter+1,:,:) = Priors;
    MuList(t_iter+1,:,:) = Mu;
    SigmaList(t_iter+1,:,:,:) = Sigma;
    % END CODE
end
iter= t_iter;
end

