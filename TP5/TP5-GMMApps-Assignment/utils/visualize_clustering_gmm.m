function [h] = visualize_clustering_gmm(X, labels_gmm, Priors, Mu, Sigma, type, softThresholds, plot_type)

K = length(Priors);
options.labels      = labels_gmm;
options.class_names = {};
options.title       = 'Data clustered with GMM';

if(strcmp(type,'soft'))

    if  sum(unique(labels_gmm) == 0)
        options.colors(1,:) = 0.5*[1;1;1];
        options.colors(2:K+1,:) = hsv(K);
    else
        options.colors = hsv(K);
    end
    options.softThresholds = softThresholds;
elseif (strcmp(type,'hard'))
    options.colors = hsv(K);
    options.softThresholds = [];
end

switch plot_type
    
    case 0 % Plot cluster Labels only
        
        if exist('h','var') && isvalid(h), delete(h);end
        h = ml_plot_data(X',options);hold on;
%         if(strcmp(type,'soft'))
%             legend('Not clustered', 'Cluster 1', 'Cluster 2', 'Cluster 3');
%         elseif (strcmp(type,'hard'))
%             legend('Cluster 1', 'Cluster 2', 'Cluster 3');
%         end
    case 1 % Plot the cluster boundary
        options.method_name = 'gmm';
        options.class_names = {};
        options.title       = 'Cluster boundaries';
        options.labels         = labels_gmm;
        options.b_plot_boundary = true;
        options.gmm.Mu         = Mu;
        options.gmm.Priors     = Priors;
        options.gmm.Sigma      = Sigma;
        options.type           = type;
        if exist('h','var') && isvalid(h), delete(h);end
        h = ml_plot_class_boundary(X',options);hold on;
end

end