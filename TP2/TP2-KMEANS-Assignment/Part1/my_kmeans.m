function [labels, Mu, Mu_init, iter] =  my_kmeans(X,K,init,type,MaxIter,plot_iter)
%MY_KMEANS Implementation of the k-means algorithm
%   for clustering.
%
%   input -----------------------------------------------------------------
%   
%       o X        : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o K        : (int), chosen K clusters
%       o init     : (string), type of initialization {'random','uniform'}
%       o type     : (string), type of distance {'L1','L2','LInf'}
%       o MaxIter  : (int), maximum number of iterations
%       o plot_iter: (bool), boolean to plot iterations or not (only works with 2d)
%
%   output ----------------------------------------------------------------
%
%       o labels   : (1 x M), a vector with predicted labels labels \in {1,..,k} 
%                   corresponding to the k-clusters.
%       o Mu       : (N x k), an Nxk matrix where the k-th column corresponds
%                          to the k-th centroid mu_k \in R^N 
%       o Mu_init  : (N x k), same as above, corresponds to the centroids used
%                            to initialize the algorithm
%       o iter     : (int), iteration where algorithm stopped
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxiliary Variable
[N, M] = size(X);
d_i    = zeros(K,M);
k_i    = zeros(1,M);
r_i    = zeros(K,M);
if plot_iter == [];plot_iter = 0;end

% Auxiliary Variable
% [N, M] = size(X);
% if plot_iter == [];plot_iter = 0;end

% Output Variables
labels  = zeros(1,M);
Mu      = zeros(N, K);
Mu_init = zeros(N, K);
% iter      = 0;

% Step 1. Mu Initialization
% Mu_init = ...
Mu_init = kmeans_init(X, K, init);

%%%%%%%%%%%%%%%%%         TEMPLATE CODE      %%%%%%%%%%%%%%%%
% Visualize Initial Centroids if N=2 and plot_iter active
colors     = hsv(K);
if (N==2 && plot_iter)
    options.title       = sprintf('Initial Mu with <%s> method', init);
    ml_plot_data(X',options); hold on;
    ml_plot_centroid(Mu_init',colors);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


iter = 0;
while true

    %%%%% Implement K-Means Algorithm HERE %%%%%    
    
    
    % Step 2. Distances from X to Mu
	% ...
%     Mu = Mu_init;
%     Mu_prev = Mu;
    %r_i    = zeros(K,M);
    d_i = my_distX2Mu(X, Mu_init, type);

    
    
	% Step 3. Assignment Step: Mu Responsability
	% Equation 5 and 6	
%     for i=1:M
%         [~,k_i(i)]=min(d_i(:,i));
%     end
    
    [~,k_i]=min(d_i,[],1);
    for i=1:K
        for j=1:M
            if(i==k_i(j))
                r_i(i,j)=1;
            else
                r_i(i,j)=0;

%             r_i(k_i(j),j)=1;
        end
        end
    end
    
% for i=1:M
%     for k=1:K
%         if(k_i(i)==k)
%             r_i(k,i)=1;
%         else
%             r_i(k,i)=0;
%         end
%     end
% end
labels=k_i;


%     for i=1:K
%         if(sum(r_i(i,:))==0)
%             %disp('here')
%             Mu_init = kmeans_init(X, K, init);
% 
%             iter = 0;
%             break;
%         end
%     end
    


	% Step 4. Update Step: Recompute Mu	
    % Equation 7	
%     Mu_prev = Mu;
%     Mu = X*r_i';
%     Mu = Mu./repmat(sum(Mu,1),[size(Mu,1),1]);

    for i=1:N
        for j=1:K
            Mu(i,j) = r_i(j,:)*X(i,:)'/sum(r_i(j,:));
        end
    end



	% Check for stopping conditions (Mu stabilization or MaxIter)
	%...     


   if(norm(Mu-Mu_init)==0 && iter~=0)
       break;
   end
   Mu_init=Mu;
   if(iter>MaxIter)
        break;
   end
   iter = iter+1;
    
    
   for i=1:K
        if(sum(r_i(i,:))==0)
            %disp('here')
            Mu_init = kmeans_init(X, K, init);
            iter = 0;
            break;
        end
   end
    
    
    %%%%%%%%%%%%%%%%%         TEMPLATE CODE      %%%%%%%%%%%%%%%%       
    if (N==2 && iter == 1 && plot_iter)
        options.labels      = labels;
        options.title       = sprintf('Mu and labels after 1st iter');
        ml_plot_data(X',options); hold on;
        ml_plot_centroid(Mu',colors);
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
%    if(norm(Mu-Mu_init)==0)
%        break;
%    end
%    Mu_init=Mu;
%     if(iter>MaxIter)
%         break;
%     end
%     iter = iter+1;

end  
%commented by CUIMINGBO
% %%%%%%%%%%%   TEMPLATE CODE %%%%%%%%%%%%%%%
if (N==2 && plot_iter)
    options.labels      = labels;
    options.class_names = {};
    options.title       = sprintf('Mu and labels after %d iter', iter);
    ml_plot_data(X',options); hold on;    
    ml_plot_centroid(Mu',colors);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%end
% commented by CUIMINGBO
%     options.labels      = labels;
%     options.class_names = {};
%     options.title       = sprintf('Mu and labels after %d iter', iter);
%     ml_plot_data(X',options); hold on;
end
