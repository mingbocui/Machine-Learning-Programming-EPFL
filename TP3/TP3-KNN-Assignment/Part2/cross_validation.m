function [TP_rate_F_fold, FP_rate_F_fold, std_TP_rate_F_fold, std_FP_rate_F_fold] =  cross_validation(X, y, F_fold, valid_ratio, k_range)
%CROSS_VALIDATION Implementation of F-fold cross-validation for kNN algorithm.
%
%   input -----------------------------------------------------------------
%
%       o X         : (N x M), a data set with M samples each being of dimension N.
%                           each column corresponds to a datapoint
%       o y         : (1 x M), a vector with labels y \in {0,1} corresponding to X.
%       o F_fold    : (int), the number of folds of cross-validation to compute.
%       o valid_ratio  : (double), Training/Testing Ratio.
%       o k_range   : (1 x K), Range of k-values to evaluate
%
%   output ----------------------------------------------------------------
%
%       o TP_rate_F_fold  : (1 x K), True Positive Rate computed for each value of k averaged over the number of folds.
%       o FP_rate_F_fold  : (1 x K), False Positive Rate computed for each value of k averaged over the number of folds.
%       o std_TP_rate_F_fold  : (1 x K), Standard Deviation of True Positive Rate computed for each value of k.
%       o std_FP_rate_F_fold  : (1 x K), Standard Deviation of False Positive Rate computed for each value of k.
%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TP_rate_F_fold = zeros(1,length(k_range));
FP_rate_F_fold = zeros(1,length(k_range));
std_TP_rate_F_fold = zeros(1,length(k_range));
std_FP_rate_F_fold = zeros(1,length(k_range));

Tp = zeros(F_fold,length(k_range));
Fp = zeros(F_fold,length(k_range));

for j=1:F_fold
    [X_train, y_train, X_test, y_test] = split_data( X, y, valid_ratio); 
    [TP_rate, FP_rate] = knn_ROC( X_train, y_train, X_test, y_test, k_range);
    Tp(j,:) = TP_rate;
    Fp(j,:) = FP_rate;
end
std_TP_rate_F_fold = std(Tp);
std_FP_rate_F_fold = std(Fp);
TP_rate_F_fold = mean(Tp,1);
FP_rate_F_fold = mean(Fp,1);
end