function [ y_est ] =  my_knn(X_train,  y_train, X_test, params)
%MY_KNN Implementation of the k-nearest neighbor algorithm
%   for classification.
%
%   input -----------------------------------------------------------------
%   
%       o X_train  : (N x M_train), a data set with M_test samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o y_train  : (1 x M_train), a vector with labels y \in {1,2} corresponding to X_train.
%       o X_test   : (N x M_test), a data set with M_test samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o params : struct array containing the parameters of the KNN (k,
%                  d_type and eventually the parameters for the Gower
%                  similarity measure)
%
%   output ----------------------------------------------------------------
%
%       o y_est   : (1 x M_test), a vector with estimated labels y \in {1,2} 
%                   corresponding to X_test.
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Auxiliary Variables
[N, M_test]  = size(X_test);
[~, M_train] = size(X_train);
y_est        = zeros(1, M_test);

k = params.k;
d = zeros(M_train,M_test);

% for i = 1:M_train
%     for j = 1:M_test
%         d(i,j) = my_distance(X_train(:,i),X_test(:,j),params);    
%     end
% end
for j = 1:M_test
    for i = 1:M_train
        d(i,j) = my_distance(X_train(:,i),X_test(:,j),params);    
    end
    dist_jth_test_train = d(:,j);
        %sort
    [result, labels] = sort(dist_jth_test_train);
        %got the nearest k train data point
     labels_k = labels(1:k);
        %
     test_labels = y_train(labels_k);
     y_est(1,j) = mode(test_labels);
%      unique_labels = unique(test_labels);
%         [repeat_times, repeat_labels] = hist(test_labels, unique_labels);
%         [~,position_of_most_repeat_labels] = max(repeat_times);
%         y_est(1:j) = repeat_labels(position_of_most_repeat_labels);
end
end