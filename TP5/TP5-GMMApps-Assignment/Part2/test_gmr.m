%% DO NOT MODIFY THIS UNLESS YOU ARE ON YOUR OWN COMPUTER
addpath(genpath("C:\Program Files\MATLAB\toolbox\ML_toolbox-master"))
addpath(genpath("~/Repositories/ML_toolbox/")) % TODO CHANGE FOR
%WINDOWS LOCATION
addpath(genpath("..\..\..\ML_toolbox-master\ML_toolbox-master\"))

addpath(genpath("../check_utils_encr"))
addpath(genpath("../utils"))

clear; 
close all; 
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%               1) Load 1D Regression Datasets               %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%  (1a) Generate Data from a noisy line %%%%%%
dataset_type = '1d-sine';
[ X, y_true, y ] = load_regression_datasets( dataset_type );
Xi = [X  y]';

%% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
% Fit GMM with Chosen parameters
params.cov_type = 'full';
params.k = 5;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'plus';

% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
[Priors, Mu, Sigma] = my_gmmEM(Xi, params);

%% Test your implementation of Gaussian Mixture Regression
N = size(X,2); P = size(y,2);
in  = 1:N;
out = N+1:(N+P);
[y_est, var_est] = my_gmr(Priors, Mu, Sigma, X', in, out);

%% Plot Ground Truth Datapoints
figure('Name', '1D Dataset')
subplot(2,1,1)
options             = [];
options.points_size = 20;
options.labels      = zeros(size(X,1),1);
options.title       = 'Example 1D Linear Data'; 
options.plot_figure = true;
ml_plot_data([X(:),y(:)],options); hold on;

% Plot True function
plot(X,y_true,'-k','LineWidth',2);
legend({'data','y = f(x)'})

%% Plot Datapoints
subplot(2,1,2)
options             = [];
options.points_size = 15;
options.plot_figure = true;
options.title       = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.labels      = zeros(length(y_est),1);
ml_plot_data([X(:),y(:)],options); hold on;
title('Original data and true function')

% Plot True function 
plot(X,y_true,'-k','LineWidth',1); hold on;

% Plot Estimated function 
options             = [];
options.var_scale   = 2;
options.title       = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.plot_figure = false;
ml_plot_gmr_function(X, y_est, var_est, options)
legend({'data','y = f(x)','$Var\{p(y|x)\}$','$+2\sigma\{p(y|x)\}$', ...
    '$-2\sigma\{p(y|x)\}$','$\hat{y} = E\{p(y|x)\}$' }, 'Interpreter','latex')
title('Estimated regression')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%             2) Load 2D Regression Datasets                 %%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%% (2a) Sin/Cos Dataset %%%%%%
dataset_type = '2d-gmm';%
[ X, y_true, y, ftruth ] = load_regression_datasets( dataset_type );
Xi = [X  y]';

% Fit GMM with Chosen parameters
params.cov_type = 'full';
params.k = 4;
params.max_iter_init = 100;
params.max_iter = 500;
params.d_type = 'L2';
params.init = 'plus';

% Run MY GMM-EM function, estimates the paramaters by maximizing loglik
[Priors, Mu, Sigma, ~] = my_gmmEM(Xi, params);

% Compute Regressive signal and variance
N = size(X,2); P = size(y,2); M = size(X,1);
in  = 1:N;       % input dimensions
out = N+1:(N+P); % output dimensions
[y_est, var_est] = my_gmr(Priors, Mu, Sigma, X', in, out);

% Function handle for my_gmr.m
f = @(X) my_gmr(Priors,Mu,Sigma,X, in, out);

%% Plotting Ground Truth
% Plot True Function
figure('Name', '2D Dataset')
subplot(1,2,1)
options           = [];
options.title = 'Training Data';
options.surf_type = 'surf';
options.bFigure = false;
ml_plot_value_func(X,ftruth,[1 2],options);hold on

% Plot Noisy Data from Function
options = [];
options.plot_figure = true;
options.points_size = 10;
options.labels = zeros(M,1);
options.plot_labels = {'x1','x2','y'};
ml_plot_data([X y],options);
title('Original data and true function')
        
%% Plotting Options for Regressive Function
subplot(1,2,2)
options           = [];
options.title     = 'Estimated y=f(x) from Gaussian Mixture Regression';
options.regr_type = 'GMR';
options.surf_type = 'surf';
options.bFigure = false;
ml_plot_value_func(X,f,[1 2],options);hold on

% Plot Training Data
options = [];
options.plot_figure = true;
options.points_size = 12;
options.labels = zeros(M,1);
options.plot_labels = {'x1','x2','y'};
ml_plot_data([X y],options);
title('Estimated regression')


