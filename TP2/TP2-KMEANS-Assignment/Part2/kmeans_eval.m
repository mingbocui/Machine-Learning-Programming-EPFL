function [RSS_curve, AIC_curve, BIC_curve] =  kmeans_eval(X, K_range,  repeats, init, type, MaxIter)
%KMEANS_EVAL Implementation of the k-means evaluation with clustering
%metrics.
%
%   input -----------------------------------------------------------------
%   
%       o X        : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o repeats  : (1 X 1), # times to repeat k-means
%       o K_range  : (1 X K), Range of k-values to evaluate
%       o init     : (string), type of initialization {'random','uniform','plus'}
%       o type     : (string), type of distance {'L1','L2','LInf'}
%       o MaxIter  : (int), maximum number of iterations
%
%   output ----------------------------------------------------------------
%       o RSS_curve  : (1 X K_range), RSS values for each value of K \in K_range
%       o AIC_curve  : (1 X K_range), AIC values for each value of K \in K_range
%       o BIC_curve  : (1 X K_range), BIC values for each value of K \in K_range
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('../Part1/')

RSS_curve = zeros(1, length(K_range));
AIC_curve = zeros(1, length(K_range));
BIC_curve = zeros(1, length(K_range));

rss=0;
aic=0;
bic=0;

for j=1:repeats
    for i=1:length(K_range)
        [labels1, centroids1, ~, ~] =  my_kmeans(X,K_range(i),init,type,MaxIter,0);
        [rss,aic,bic] = my_metrics(X, labels1, centroids1);
        RSS_curve(1,i) = RSS_curve(1,i) + rss;
        AIC_curve(1,i) = AIC_curve(1,i) + aic;
        BIC_curve(1,i) = BIC_curve(1,i) + bic;
    end
end
    RSS_curve = RSS_curve / repeats;
    AIC_curve = AIC_curve / repeats;
    BIC_curve = BIC_curve / repeats;

%not working
% for i=1:length(K_range)
%     [labels1, centroids1, ~, ~] =  my_kmeans(X,K_range(i),init,type,MaxIter,0);
%     for j=1:repeats
%         [rss,aic,bic] = my_metrics(X, labels1, centroids1);
%         RSS_curve(1,i) = RSS_curve(1,i) + rss;
%         AIC_curve(1,i) = AIC_curve(1,i) + aic;
%         BIC_curve(1,i) = BIC_curve(1,i) + bic;
%     end
% %     RSS_curve(1,i) = RSS_curve(1,i) / repeats;
% %     AIC_curve(1,i) = AIC_curve(1,i) / repeats;
% %     BIC_curve(1,i) = BIC_curve(1,i) / repeats;
% end
%     RSS_curve = RSS_curve / repeats;
%     AIC_curve = AIC_curve / repeats;
%     BIC_curve = BIC_curve / repeats;

end
