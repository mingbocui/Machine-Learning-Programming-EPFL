function [acc_curve] = knn_eval( X_train, y_train, X_test, y_test, k_range, params)
%KNN_EVAL Implementation of kNN evaluation.
%
%   input -----------------------------------------------------------------
%   
%       o X_train   : (N x M_train), a data set with M_test samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o y_train   : (1 x M_train), a vector with labels y \in {0,1} corresponding to X_train.
%       o X_test    : (N x M_test), a data set with M_test samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o y_test    : (1 x M_test), a vector with labels y \in {0,1} corresponding to X_test.
%       o k_range   : (1 X K), Range of k-values to evaluate
%
%   output ----------------------------------------------------------------
%       o acc_curve : (1 X K), Accuracy for each value of K
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% params.d_type = 'L2';

acc_curve = zeros(1, length(k_range));

for i=1:length(k_range)
    params.k = k_range(i);
    y_est  =  my_knn(X_train,  y_train, X_test, params);
    acc_curve(1,i) =  my_accuracy(y_test, y_est);
end


end

