%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath("../check_utils_encr")
addpath("../Part1")

% TP1 Practical Path (for PCA functions) ** <-- Fill in this path
tp1_path = '../../../TP1-PCA/TP1-PCA-Solution/';
addpath(genpath(tp1_path))

clear; 
close all; 
clc;

dataset_path = '../../TP2-KMEANS-Datasets/';
rng(42);
seed = rng;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%              1) Load Digits Testing Dataset                 %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('digits.csv');
true_K = 4;
[X, labels] = ml_load_digits_64('data/digits.csv', 0:true_K-1);

% Generate Variables
[M, N]  = size(X);
sizeIm  = sqrt(N);
idx = randperm(M);
nSamples = round(M);

X = X';

% Plot 64 random samples of the dataset as images
if exist('h0','var') && isvalid(h0), delete(h0);end
h0  = ml_plot_images(X(:,idx(1:64))',[sizeIm sizeIm]);

% Plot the first 8 dimensions of the image as data points
plot_options = [];
plot_options.labels = labels(idx(1:nSamples));
plot_options.title = '';
if exist('h1','var') && isvalid(h1), delete(h1);end
h1  = ml_plot_data(X([1 2 3 4 5 6 7 8], idx(1:nSamples))',plot_options);
axis equal;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         2) Run K-means EVAL on the raw data                %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% K-means Evaluation Parameters
K_range=1:10; type='L2'; repeats = 10; init = 'random'; MaxIter = 100;

% Evaluate K-means to find the optimal K
[RSS_curve,AIC_curve,BIC_curve] = kmeans_eval(X, K_range, repeats, init, type, MaxIter);

% Plot Metric Curves
if exist('h_metrics','var') && isvalid(h_metrics),  delete(h_metrics); end
h_metrics = figure('Color',[1 1 1]);hold on;
plot(RSS_curve,'--o', 'LineWidth', 1); hold on;
plot(AIC_curve,'--o', 'LineWidth', 1); hold on;
plot(BIC_curve,'--o', 'LineWidth', 1); hold on;
xlabel('K')
legend('RSS', 'AIC', 'BIC')
title('Clustering Evaluation metrics on Original Data','Interpreter','LaTex')
grid on
axis tight


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%     3) Project data to 4D using PCA and Run K-means EVAL   %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('D:\EPFL COURSES\2018-2019_Semester_1\Machine Learning Programming\Exercise\TP1\TP1-PCA-Assignment-293330\Part1');
% Perform PCA on the digits dataset
[V, L, pca_Mu] = compute_pca(X);

% Project Digits Dataset to its first 3 principal components
p = 4;
[A_p, Y] = project_pca(X, pca_Mu, V, p);

% Visualize Projected Dataset
plot_options = [];
plot_options.title = 'Digits projected to 4d-subspace';
plot_options.labels = labels;
h2  = ml_plot_data(Y',plot_options);
axis tight
legend('1','2','3','4')

%% K-means Evaluation Parameters
K_range=1:10; type='L2'; repeats = 10; init = 'random'; MaxIter = 100;

% Evaluate K-means to find the optimal K
[RSS_curve,AIC_curve,BIC_curve] = kmeans_eval(Y, K_range, repeats, init, type, MaxIter);

% Plot Metric Curves
if exist('h_metrics','var') && isvalid(h_metrics),  delete(h_metrics); end
h_metrics = figure('Color',[1 1 1]);hold on;
plot(RSS_curve,'--o', 'LineWidth', 1); hold on;
plot(AIC_curve,'--o', 'LineWidth', 1); hold on;
plot(BIC_curve,'--o', 'LineWidth', 1); hold on;
xlabel('K')
legend('RSS', 'AIC', 'BIC')
title('Clustering Evaluation metrics on Original Data','Interpreter','LaTex')
grid on
axis tight


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%       4) Test F1-measure implementation on projected data       %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Run k-means Once for metric evaluation
K = 5; init='random'; type='L2'; MaxIter = 100; plot_iter = 0;
[est_labels, Mu] =  my_kmeans(Y, K, init, type, MaxIter, plot_iter);

% Compute F1-Measure for estimated labels
[F1_overall, P, R, F1] =  my_f1measure(est_labels(:), labels(:));
fprintf('F1 measure = %2.4f for K = %d\n',F1_overall, K)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Test my_f1measure.m function
test_f1measure(est_labels(:), labels(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 5) Find the F1-measure for the different number of clusters%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K_range=1:10; type='L2'; init='random'; MaxIter = 100; repeats = 10;

% Evaluate k-means on Original Dataset see how f-measure varies with k
f1measure_eval(X, K_range,  repeats, init, type, MaxIter, labels, 'Clustering F1-Measure -- Original Dataset--');

pause(1);
% Evaluate k-means on Original Dataset see how f-measure varies with k
f1measure_eval(Y, K_range,  repeats, init, type, MaxIter, labels, 'Clustering F1-Measure -- Projected Dataset--');
