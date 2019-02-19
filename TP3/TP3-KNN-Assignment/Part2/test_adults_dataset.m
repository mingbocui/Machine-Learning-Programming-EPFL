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
%%           1) Load Dataset and Preprocess the Data          %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ratio = 0.1;
training_data = readtable(strcat(dataset_path,'adults_data.csv'));
data_type = {true, false, true, true, false, false, false, false, false, true, true, true, false, false};
[X, Y, rk] = preprocess_data(training_data,ratio, data_type);
params.data_type = data_type;
params.rk = rk;

test_preprocessing(dataset_path, data_type);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%           Split the Dataset into Training and Testing      %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valid_ratio = 0.7;
[X_train,Y_train,X_test,Y_test] = split_data(X,Y,valid_ratio);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    3) Test kNN implementation (my_knn) and Visualize Results  %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select k
params.k = 25; 
params.d_type = 'Gower';

% Compute y_estimate from k-NN
Y_est =  my_knn(X_train, Y_train, X_test, params);

% Check the accuracy
acc = my_accuracy(Y_test, Y_est);
conf = confusion_matrix(Y_test,Y_est);

test_gowersimilarity(X,data_type,rk);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%            Choosing K by visualizing knn_eval.m            %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Select Range of K to test accuracy
M_train = length(X_train);
k_range = [1:10:100];
acc_curve = knn_eval(X_train, Y_train, X_test, Y_test, k_range, params); 

% Plot Accuracy Curve
if exist('h_acc','var')     && isvalid(h_acc),     delete(h_acc);    end
h_acc = figure;hold on;
plot(k_range,acc_curve,'--o', 'LineWidth', 1, 'Color', [1 0 0]); hold on;
xlabel('k'); ylabel('Acc')
title('Classification Evaluation for KNN')
grid on