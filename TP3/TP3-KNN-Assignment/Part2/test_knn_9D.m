%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
addpath(genpath("D:\EPFL COURSES\2018-2019_Semester_1\Machine Learning Programming\Exercise\ML_toolbox-master\ML_toolbox-master\"))
%WINDOWS LOCATION

addpath("../check_utils_encr")
addpath("../utils")
addpath("../Part1")

clear; 
close all; 
clc;

dataset_path = '../../TP3-KNN-Datasets/';
rng(42);
seed = rng;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           1) Load 9D KNN Function Testing Dataset          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Load Wisconsin Breast Cancer Dataset
% [X, y, class_names] = ml_load_data(strcat(ml_toolbox_path,'data/breast-cancer-wisconsin.csv'),'csv','last');

% On Linux Systems
[X, y, class_names] = ml_load_data('breast-cancer-wisconsin.csv','csv','last');

% Breast-Cancer-Wisconsin Dataset
% https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+%28Diagnostic%29
% Nine real-valued features are computed for each cell nucleus:
%   Feature                          Range
%   1. Clump Thickness               1 - 10
%   2. Uniformity of Cell Size       1 - 10
%   3. Uniformity of Cell Shape      1 - 10
%   4. Marginal Adhesion             1 - 10
%   5. Single Epithelial Cell Size   1 - 10
%   6. Bare Nuclei                   1 - 10
%   7. Bland Chromatin               1 - 10
%   8. Normal Nucleoli               1 - 10
%   9. Mitoses                       1 - 10

% Transpose matrices to have datapoints as columns and dimensions as rows
X = X';
y = y';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     2) Data Handling for Classification (split_data.m)        %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select Training/Testing Ratio
valid_ratio = 0.8;

% Split data into a training dataset that kNN can use to make predictions
% and a test dataset that we can use to evaluate the accuracy of the model.
[X_train, y_train, X_test, y_test] = split_data(X, y, valid_ratio);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         3) Choosing K by visualizing knn_eval.m            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select Range of K to test accuracy
M_train = length(X_train);
k_range = [1:5:ceil(M_train)];
params.d_type = 'L2';
acc_curve = knn_eval(X_train, y_train, X_test, y_test, k_range, params); 

% Plot Accuracy Curve
if exist('h_acc','var')     && isvalid(h_acc),     delete(h_acc);    end
h_acc = figure;hold on;
plot(k_range,acc_curve,'--o', 'LineWidth', 1, 'Color', [1 0 0]); hold on;
xlabel('k'); ylabel('Acc')
title('Classification Evaluation for KNN')
grid on

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%      4) Test Confusion Matrix (confusion_matrix.m)         %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select k
params.k = 5;
params.d_type = 'L2';

% kNN classification of test set
y_est =  my_knn(X_train, y_train, X_test, params);

% Confusion matrix computation for the classified data
C = confusion_matrix(y_test, y_est);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test knn_eval.m function for your estimated labels
pts = test_confusionmatrix(y_test, y_est);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                5) Plot ROC curve (knn_ROC.m)               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Split data randomly between train and test
valid_ratio = 0.9;
[X_train, y_train, X_test, y_test] = split_data( X, y, valid_ratio);

% Compute ROC curve
k_range = [1:8:ceil(length(y)*(1-valid_ratio))];
[TP_rate, FP_rate] = knn_ROC( X_train, y_train, X_test, y_test, k_range );

% Plot ROC Curve
if exist('h_roc','var')     && isvalid(h_roc),     delete(h_roc);    end
h_roc = figure;hold on;
plot(FP_rate, TP_rate, '--o', 'LineWidth', 1, 'Color', [1 0 0]); hold on;
xlabel('False Positive rate'); ylabel('True Positive rate = 1 - False Negative Rate')
title('ROC curve for KNN')
grid on
for i = 1:length(k_range)
    current_k = k_range(i);
    text(FP_rate(i)+0.001,TP_rate(i)-0.001+0.001*mod(i,3),['k = ' num2str(current_k)])
end
pause(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test knn_eval.m function for your estimated labels
pts = test_knnROC(X_train, y_train, X_test, y_test, k_range);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%          6) Cross validation (cross_validation.m)          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valid_ratio = 0.9;
k_range = [1:8:ceil(length(y)*(1-valid_ratio))];
F_fold = 10;

% Compute F-fold cross-validation
[TP_rate_F_fold, FP_rate_F_fold, std_TP_rate_F_fold, std_FP_rate_F_fold] =  cross_validation(X, y, F_fold, valid_ratio, k_range);

% Plot ROC curve for F-fold cross-validation with standard deviation
if exist('h_roc_fold','var')     && isvalid(h_roc_fold),     delete(h_roc_fold);    end
h_roc_fold = figure;hold on;
yneg = std_TP_rate_F_fold; ypos = yneg;
xneg = std_FP_rate_F_fold; xpos = xneg;
plot(FP_rate_F_fold, TP_rate_F_fold, '--o', 'LineWidth', 2, 'Color', [1 0 0]); hold on;
errorbar(FP_rate_F_fold,TP_rate_F_fold,yneg,ypos,xneg,xpos,'ko')
for i = 1:length(k_range)
    current_k = k_range(i);
    text(FP_rate_F_fold(i)+0.0005,TP_rate_F_fold(i)-0.0015,['k = ' num2str(current_k)])
end
xlabel('False Positive rate'); ylabel('True Positive rate = 1 - False Negative Rate')
title('ROC curve for KNN')
grid on
hold off

pause(1);
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test cross_validation.m function
pts = test_cross_validation(X, y, F_fold, valid_ratio, k_range);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%