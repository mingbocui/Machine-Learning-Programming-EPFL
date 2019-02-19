function [d] =  my_distX2Mu(X, Mu, type)
%MY_DISTX2Mu Computes the distance between X and Mu.
%
%   input -----------------------------------------------------------------
%   
%       o X     : (D x N), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o Mu    : (D x k), an Nxk matrix where the k-th column corresponds
%                          to the k-th centroid mu_k \in R^N
%       o type  : (string), type of distance {'L1','L2','LInf'}
%
%   output ----------------------------------------------------------------
%
%       o d      : (k x N), distances between X and Mu 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxiliary Variables
[D, N] = size(X);
[~, k] = size(Mu);

% Output Variable
d = zeros(k,N);

% Output Variable
for i=1:k
    for j = 1:N
        d(i,j) = my_distance(X(:,j), Mu(:,i), type);        
    end
end


end