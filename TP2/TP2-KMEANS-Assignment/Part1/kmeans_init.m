function [Mu] =  kmeans_init(X, k, init)
%KMEANS_INIT This function computes the initial values of the centroids
%   for k-means algorithm, depending on the chosen method.
%
%   input -----------------------------------------------------------------
%   
%       o X     : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o k     : (double), chosen k clusters
%       o init  : (string), type of initialization {'random','uniform'}
%
%   output ----------------------------------------------------------------
%
%       o Mu    : (N x k), an Nxk matrix where the k-th column corresponds
%                          to the k-th centroid mu_k \in R^N                   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxiliary Variable
[N, M] = size(X);

% Output Variable
Mu = zeros(N, k);
if(strcmp(init,'random'))
%     indices = randsample(M,k);
%     Mu = X(:,indices);
indices = randperm(M,k);
Mu = X(:,indices);
%     Mu = datasample(X,k,2);
elseif(strcmp(init,'uniform'))
%      min_x1 = min(X,[],2);
% %     min_x2 = min(min(X,[],1));
%       max_x1 = max(X,[],2);
%     max_x2 = max(max(X,[],1));
%     mu_x = rand(1,1)*abs(min_x1-min_x2)+min
%       for j=1:k
%           Mu(:,j)=rand(N,1).*(max_x1-min_x1)+min_x1;
%       end
      Mu = datasample(X,k,2);
      
end
% switch init
%     case 'random'  % Select K datapoints at random from X
%         Mu = datasample(X,k,2);
%         
%     case 'uniform' % Select k datapoints uniformly at random from the range of X                
%         N_min = min(X,[],2);
%         N_max = max(X,[],2);
%         
%         for i = 1:k
%             Mu(:,i) = (rand(N,1)-ones(N,1)*0.5).*(N_max-N_min)+(N_max+N_min)/2;
%         end
%         
%     otherwise
%         warning('Unexpected initialization type. No centroids computed.')
% end
   



end