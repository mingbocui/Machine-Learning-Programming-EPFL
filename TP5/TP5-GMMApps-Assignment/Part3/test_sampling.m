%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION
addpath(genpath("..\..\..\ML_toolbox-master\ML_toolbox-master\"))

addpath(genpath("../utils"))
addpath(genpath("../Part1"))

clear; 
close all; 
clc;

dataset_path = '../../TP5-GMMApps-Datasets/';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         1) Sampling from 2D Dataset
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nbPoints = 1000;
%% ADD CODE HERE
% Load a dataset, and train GMM model and sample nbPoints points from it
data = crescentfullmoon();
X = data(:,1:2)';%transpose
Y = data(:,3)'+1;
validSize = 0.2;
[Xtrain, Ytrain, Xtest, Ytest] = split_data(X, Y, validSize);

params.cov_type = 'full';
params.k = 4;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'random';

models = my_gmm_models(Xtrain, Ytrain, params);

%%%% sample datapoints from class 1 by cuimingbo
XNew = sample_model(2,models,nbPoints);

%% END CODE

% plot both the original data and the sampled ones
figure('Name', 'Original dataset')
dotsize = 12;
ax1 = subplot(1,2,1);
scatter(X(1,:), X(2,:), dotsize);
title('Original Data')
ax2 = subplot(1,2,2);
scatter(XNew(1,:), XNew(2,:), dotsize);
title('Sampled Data')
linkaxes([ax1,ax2],'xy')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         2) Sampling from high-dimensional data
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

train_data = csvread('mnist_train.csv', 1, 0);  
nbSubSamples = 2000;
idx = randperm(size(train_data, 1), nbSubSamples);
train_data = train_data(idx,:);

% extract the data
Xtrain = train_data(:,2:end)'; % pixels: 0-255, 784(28*28) by 2000
Ytrain = train_data(:,1)'+1;%0-9 to 1-10

plot_digits(Xtrain)

%%%%%%%%%%%% what?
p = 40; % in cases you need this, use this value

%% ADD CODE HERE

% sample from the train or test?
params2.cov_type = 'full';
params2.k = 500;
params2.max_iter_init = 100;
params2.max_iter = 500;
params2.d_type = 'L2';
params2.init = 'uniform';

[ Vtrain, Ltrain, MuPCA_train ] = compute_pca( Xtrain ); % reduce dimensionality
[A_p_train, X_low_dimension] = project_pca(Xtrain, MuPCA_train, Vtrain, p);
%%%%% UNSUPERVISED LEARNING
models_2 = [struct()];
[Priors, Mu, Sigma, iter] = my_gmmEM(X_low_dimension, params);
models_2.Priors = Priors;
models_2.Mu = Mu;
models_2.Sigma = Sigma;

X_sample = sample_multi_class(models_2,nbPoints);
XHat = reconstruct_pca(X_sample, A_p_train, MuPCA_train);
% plot the reconstructed
plot_digits(XHat)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         1) Sampling from a GMM per class
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ADD CODE HERE
class = 5;
params2.cov_type = 'full';
params2.k = 10;
params2.max_iter_init = 100;
params2.max_iter = 500;
params2.d_type = 'L2';
params2.init = 'uniform';

[ Vtrain, Ltrain, MuPCA_train ] = compute_pca( Xtrain );
[A_p_train, X_low_dimension] = project_pca(Xtrain, MuPCA_train, Vtrain, p);

models_2  = my_gmm_models(X_low_dimension, Ytrain, params2); %how use gmm model without the Ytrain

%%%% sample datapoints from class 1 by cuimingbo
X_sample = sample_per_class(models_2, class+1, nbPoints);
XHat = reconstruct_pca(X_sample, A_p_train, MuPCA_train);
%% END CODE

% plot the reconstructed
plot_digits(XHat)





